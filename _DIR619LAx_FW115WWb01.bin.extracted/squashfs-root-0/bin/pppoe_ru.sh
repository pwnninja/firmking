#!/bin/sh
#WAN=eth1
WAN=$2
OPTIONS=/etc/ppp/options
PAPFILE=/etc/ppp/pap-secrets
CHAPFILE=/etc/ppp/chap-secrets
RESOLV=/etc/ppp/resolv.conf
LINKFILE=/etc/ppp/link
PPPFILE=/var/run/ppp
FIRSTFILE=/etc/ppp/first
FIRSTDEMAND=/etc/ppp/firstdemand
CONNECTFILE=/etc/ppp/connectfile
MCONNECTFILE=/var/ppp/mconnectfile
DNRDPIDFILE=/var/run/dnrd.pid
eval `flash get PPPOE_RU_USER_NAME`
eval `flash get PPPOE_RU_PASSWORD`
eval `flash get PPPOE_RU_IDLE_TIME`
eval `flash get PPPOE_RU_CONNECT_TYPE`
eval `flash get PPPOE_RU_MTU_SIZE`
eval `flash get DNS_MODE`
eval `flash get DNS1`
eval `flash get DNS2`
eval `flash get DNS3`
eval `flash get PPPOE_RU_SERVICE_NAME`
eval `flash get PPPOE_RU_WANPHY_IP_DYNAMIC`
MSS=`expr $PPPOE_RU_MTU_SIZE - 8`
#ifconfig $WAN 0.0.0.0
if [ $PPPOE_RU_CONNECT_TYPE = 2 ] && [ $PPPOE_RU_WANPHY_IP_DYNAMIC = 0 ];then
route del default gw 0.0.0.0 dev $WAN
fi
if [ $1 = 'connect' ] || [ $1 = 'mconnect' ]; then
     ENABLE_CONNECT=1
else
     ENABLE_CONNECT=0
fi
#generate options file even the user name is null
#if [ -n "$PPP_USER_NAME" ] ; then
#  echo "name \"$PPP_USER_NAME\"" > $OPTIONS
#  echo "#################################################" > $PAPFILE  
#  echo "\"$PPP_USER_NAME\"	*	\"$PPP_PASSWORD\"" >> $PAPFILE
#  echo "#################################################" > $CHAPFILE
#  echo "\"$PPP_USER_NAME\"	*	\"$PPP_PASSWORD\"" >> $CHAPFILE
	flash gen-pppoe $OPTIONS $PAPFILE $CHAPFILE
#fi

# Realtek fast pptp forwarding
eval `flash get WAN_DHCP`
if [ $WAN_DHCP = 4 ]; then
  echo "1" > /proc/fast_pptp
else
  echo "0" > /proc/fast_pptp
fi		

#echo "sync" >> $OPTIONS  
echo "noauth" >> $OPTIONS  
echo "noipdefault" >> $OPTIONS  
echo "hide-password" >> $OPTIONS  
echo "defaultroute" >> $OPTIONS  
echo "persist" >> $OPTIONS  
echo "ipcp-accept-remote" >> $OPTIONS  
echo "ipcp-accept-local" >> $OPTIONS  
echo "nodetach" >> $OPTIONS  
echo "usepeerdns" >> $OPTIONS  
echo "mtu $MSS" >> $OPTIONS  
echo "mru $MSS" >> $OPTIONS  
echo "lcp-echo-interval 20" >> $OPTIONS  
echo "lcp-echo-failure 3" >> $OPTIONS  
echo "wantype $WAN_DHCP" >> $OPTIONS
eval `flash get PPPOE_RU_WAN_IP_DYNAMIC`
if [ $PPPOE_RU_WAN_IP_DYNAMIC = 1 ]; then
  eval `flash get PPPOE_RU_IP_ADDR`
  echo "$PPPOE_RU_IP_ADDR:0.0.0.0" >> $OPTIONS  
  echo "netmask 255.255.255.255" >> $OPTIONS  
fi

if [ -n "$PPPOE_RU_SERVICE_NAME" ]; then
  echo "plugin /etc/ppp/plugins/libplugin.a rp_pppoe_service $PPPOE_RU_SERVICE_NAME $WAN" >> $OPTIONS
else
  echo "plugin /etc/ppp/plugins/libplugin.a $WAN" >> $OPTIONS
fi

PID_FILE=/var/run/ppp0.pid
DNRD_PID=/var/run/dnrd.pid
RESOLV_CONF="/etc/resolv.conf"

#if [ ! -f $DNRD_PID ]; then
   DNS="--cache=off"
   if [ $DNS_MODE != 1 ]; then
      dnrd $DNS -s 168.95.1.1
   fi
   if [ $DNS_MODE = 1 ]; then
      if [ "$DNS1" != '0.0.0.0' ]; then
        DNS="$DNS -s $DNS1"
        	if [ ! -r $RESOLV_CONF ]; then
		echo nameserver $DNS1 > $RESOLV_CONF    
      fi
      fi
      if [ "$DNS2" != '0.0.0.0' ]; then
        DNS="$DNS -s $DNS2"
        	if [ ! -r $RESOLV_CONF ]; then
		echo nameserver $DNS2 >> $RESOLV_CONF
      fi 
      fi 
      dnrd $DNS
   fi
#fi

if [ -r "$PPPFILE" ]; then
  rm $PPPFILE
fi


#if [ $1 = "mconnect" ]; then
#     echo "PPPOE connect manually!!"
#   sleep 5
#   pppd &
#   exit
#fi


if [ $PPPOE_RU_CONNECT_TYPE = 0 ] ; then
  {
  while [ true ]; 
  do
  eval `flash get PPPOE_RU_CONNECT_TYPE`
  eval `flash get WAN_DHCP`

  if [ $WAN_DHCP != 7 ] || [ $PPPOE_RU_CONNECT_TYPE != 0 ]; then
    break
  fi
  if [ ! -r "$CONNECTFILE" ]  && [ $PPPOE_RU_CONNECT_TYPE = 0 ]; then
    echo "pass" > $CONNECTFILE
    if [ ! -f $FIRSTFILE ]; then
      echo "pass" > $FIRSTFILE
      #upnp.sh
    fi
    #sleep 5
    #pppd pty "pppoe -I $WAN -m $MSS -s"
    pppd 
  fi
  sleep 3
  done
  rm -f $FIRSTFILE
  } &
fi
 
if [ $PPPOE_RU_CONNECT_TYPE = 2 ] ; then
  {
  echo "demand" >> $OPTIONS
  echo "idle $PPPOE_RU_IDLE_TIME" >> $OPTIONS
  while [ true ]; 
  do
  eval `flash get PPPOE_RU_CONNECT_TYPE`
  eval `flash get WAN_DHCP`

  if [ $WAN_DHCP != 7 ] || [ $PPPOE_RU_CONNECT_TYPE != 2 ]; then
    break
  fi
  if [ ! -r "$CONNECTFILE" ]  && [ $PPPOE_RU_CONNECT_TYPE = 2 ]; then
    echo "pass" > $CONNECTFILE
    if [ $1 = "mconnect" ]; then 
    if [ -r "$MCONNECTFILE" ]; then
    	#echo "can read $MCONNECTFILE"
	echo "mconnect " >> $OPTIONS
	else
	#echo "pppoe.sh can not read $MCONNECTFILE"
	rm -f $CONNECTFILE
	pppoe_ru.sh all eth1
	exit
    fi
    fi
    if [ ! -f $FIRSTDEMAND ]; then
      echo "pass" > $FIRSTDEMAND
      #upnp.sh
    fi
    #sleep 5
    #pppd pty "pppoe -I $WAN -T 80 -U -m $MSS -s"  
    killall -9 igmpproxy 2> /dev/null
    killall -9 dnrd 2> /dev/null 
    killall -9 pppd 2> /dev/null
    pppd 
   
    fi
  sleep 5
  done
  rm -f $FIRSTDEMAND
  } &
fi


if [ $PPPOE_RU_CONNECT_TYPE = 1 ]; then
   #upnp.sh
    if [ $1 = "mconnect" ]; then
     if [ -r "$MCONNECTFILE" ]; then
   	rm -f $MCONNECTFILE
    fi
    fi
   if [ $ENABLE_CONNECT = 1 ]; then
     echo "PPPOE connect!!"
   #sleep 5
   #pppd pty "pppoe -I $WAN -m $MSS -s" &
   pppd &
   fi
fi

