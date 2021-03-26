#!/bin/sh
WAN=$1
MCONN=$2
OPTIONS=/etc/ppp/options
RPPTP=/etc/ppp/peers/rpptp
PAPFILE=/etc/ppp/pap-secrets
CHAPFILE=/etc/ppp/chap-secrets
RESOLV=/etc/ppp/resolv.conf
PPPFILE=/var/run/ppp
FIRSTFILE=/etc/ppp/firstpptp
FIRSTDEMAND=/etc/ppp/firstpptp_demand
CONNECTFILE=/etc/ppp/connectfile
MCONNECTFILE=/var/ppp/mconnectfile
RESOLV_CONF=/etc/resolv.conf	
PPTP_GWRU="/var/pptp_gw"
PPTP_IPDYNRU="/var/pptp_dyn"
START_STATIC_ROUTE=/bin/st_route.sh
STOP_STATIC_ROUTE=/bin/st_route_del.sh
PID_FILE=/var/run/ppp0.pid
DNRD_PID=/var/run/dnrd.pid
eval `flash get PPTP_RU_USER_NAME`
eval `flash get PPTP_RU_PASSWORD`
eval `flash get PPTP_RU_WANPHY_IP`
eval `flash get PPTP_RU_WANPHY_MASK`
eval `flash get PPTP_RU_WANPHY_GATEWAY`
eval `flash get PPTP_RU_SERVER_IP_ADDR`
eval `flash get PPTP_RU_MTU_SIZE`
eval `flash get DNS_MODE`
eval `flash get DNS1`
eval `flash get DNS2`
eval `flash get DNS3`
eval `flash get WAN_DHCP`
eval `flash get PPTP_RU_CONNECTION_TYPE`
eval `flash get PPTP_RU_IDLE_TIME`
eval `flash get PPTP_RU_WANPHY_IP_DYNAMIC`
eval `flash get IGMP_PROXY_DISABLED`
MSS=`expr $PPTP_RU_MTU_SIZE - 8`
if [ $1 = 'connect' ]; then
     ENABLE_CONNECT=1
else
     ENABLE_CONNECT=0
fi

if [ "$MCONN" != "" ]; then
   if [ "$MCONN" = "mconnect" ]; then
     ENABLE_CONNECT=1
     else
     ENABLE_CONNECT=0
   fi
fi
if [ $DNS_MODE = 1 ]; then
	DNS="--cache=off"
	
	eval `flash get DNS1`
    if [ "$DNS1" != '0.0.0.0' ]; then
        DNS="$DNS -s $DNS1"
        if [ ! -r $RESOLV_CONF ]; then
		echo nameserver $DNS1 > $RESOLV_CONF       
    fi
    fi
    dnrd $DNS
 else
 	if [ $PPTP_RU_WANPHY_IP_DYNAMIC = 1 ]; then
 		if [ ! -r $RESOLV_CONF ]; then
    		echo "nameserver $PPTP_RU_WANPHY_GATEWAY" > $RESOLV_CONF 
    		fi
    		dnrd -s $PPTP_RU_WANPHY_GATEWAY  --cache=off
    	else
    		if [ -r /var/eth1_gw ]; then
    			PPTP_RU_WANPHY_GATEWAY=`cat /var/eth1_gw`
			if [ -r $RESOLV_CONF ]; then
				line=0
		    		cat $RESOLV_CONF | grep nameserver > /tmp/ddfile 
		    		line=`cat /tmp/ddfile | wc -l`
		    		num=1
		    		while [ $num -le $line ];
		    		do
		      			pat0=` head -n $num /tmp/ddfile | tail -n 1`
		      			pat1=`echo $pat0 | cut -f2 -d " "`
		      			DNS="$DNS -s $pat1"
		      			num=`expr $num + 1`
		    		done
		    		dnrd --cache=off $DNS
		    		rm -f /tmp/ddfile 2> /dev/null
		    		
		    	else
    			echo "nameserver $PPTP_RU_WANPHY_GATEWAY" > $RESOLV_CONF 
				dnrd -s $PPTP_RU_WANPHY_GATEWAY --cache=off
    	fi
fi
    	fi
fi

if [ $PPTP_RU_CONNECTION_TYPE = 2 ] && [ $PPTP_RU_WANPHY_IP_DYNAMIC = 0 ]; then
route del  default dev $WAN
fi

#generate option file even the user name is null
#if [ -n "$PPTP_USER_NAME" ] ; then
	flash gen-pptp $OPTIONS $PAPFILE $CHAPFILE
#fi

echo "lock" >> $OPTIONS  
echo "noauth" >> $OPTIONS  
echo "nobsdcomp" >> $OPTIONS  
echo "nodeflate" >> $OPTIONS  
echo "usepeerdns" >> $OPTIONS  
echo "lcp-echo-interval 20" >> $OPTIONS
echo "lcp-echo-failure 3" >> $OPTIONS
echo "mtu $MSS" >> $OPTIONS
echo "wantype $WAN_DHCP" >> $OPTIONS
echo "allow-auth 129" >> $OPTIONS
echo "remotename PPTP" > $RPPTP
echo "linkname PPTP" >> $RPPTP
echo "ipparam PPTP" >> $RPPTP
echo "pty \"pptp $PPTP_RU_SERVER_IP_ADDR  --nolaunchpppd\"" >> $RPPTP
echo "name $PPTP_RU_USER_NAME" >> $RPPTP

eval `flash get PPTP_RU_SECURITY_ENABLED`
eval `flash get PPTP_RU_SECURITY_LENGTH`

if [ $PPTP_RU_SECURITY_ENABLED != 0 ]; then
	#echo "require-mppe" >> $RPPTP
  if [ $PPTP_RU_SECURITY_LENGTH = 0 ]; then
	#we want mppe 40 bit
	echo "require-mppe40" >> $RPPTP
	#we allow
	echo "require-mppe-40" >> $RPPTP
	echo "checkNoEncrypt" >> $RPPTP
  else
	#we want mppe 128bit
  	echo "require-mppe128" >> $RPPTP
  	#we allow
	echo "require-mppe-128" >> $RPPTP
	echo "checkNoEncrypt" >> $RPPTP
  fi
	echo "nomppe-stateful" >> $RPPTP
fi

echo "persist" >> $RPPTP
echo "noauth" >>$RPPTP
echo "file /etc/ppp/options" >>$RPPTP
echo "nobsdcomp" >>$RPPTP
echo "novj" >>$RPPTP

if [ -r "$PPPFILE" ]; then
  rm $PPPFILE
fi

if [ $PPTP_RU_CONNECTION_TYPE = 0 ]; then
  {
  while [ true ]; do
  eval `flash get PPTP_RU_CONNECTION_TYPE`
  eval `flash get WAN_DHCP`
  if [ $WAN_DHCP != 8 ] || [ $PPTP_RU_CONNECTION_TYPE != 0 ]; then
    break
  fi
  if [ ! -r "$CONNECTFILE" ]  && [ $PPTP_RU_CONNECTION_TYPE = 0 ]; then
    echo "pass" > $CONNECTFILE 
    echo $PPTP_RU_WANPHY_IP_DYNAMIC > $PPTP_IPDYNRU	
    echo $PPTP_RU_WANPHY_GATEWAY > $PPTP_GWRU
    if [ ! -f $FIRSTFILE ]; then
      echo "pass" > $FIRSTFILE
      #upnp.sh
    fi
    #sleep 5 
    exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:WAN Dialup;note:Try to establish PPTP line;"
     if [ ! -f /var/setwan_check ]; then
    	setfirewall restore $WAN_DHCP $PPTP_RU_WANPHY_IP_DYNAMIC
    fi
    pppd call rpptp 
  fi
  sleep 3
  done
  rm -f $FIRSTFILE
  } &
fi
if [ $PPTP_RU_CONNECTION_TYPE = 2 ] ; then
  {
  echo "persist" >> $OPTIONS
  echo "nodetach" >>$OPTIONS
  echo "connect /etc/ppp/true" >> $OPTIONS
  echo "demand" >> $OPTIONS
  echo "idle $PPTP_RU_IDLE_TIME" >> $OPTIONS
  echo "ktune" >> $OPTIONS
  echo "ipcp-accept-remote" >> $OPTIONS
  echo "ipcp-accept-local" >> $OPTIONS
  echo "noipdefault" >> $OPTIONS
  echo "defaultroute" >> $OPTIONS
  echo "hide-password" >> $OPTIONS
  while [ true ]; do
  eval `flash get PPTP_RU_CONNECTION_TYPE`
  eval `flash get WAN_DHCP`
  if [ $WAN_DHCP != 8 ] || [ $PPTP_RU_CONNECTION_TYPE != 2 ]; then
    break
  fi

  if [ ! -r "$CONNECTFILE" ]  && [ $PPTP_RU_CONNECTION_TYPE = 2 ]; then
    echo "pass" > $CONNECTFILE
    echo $PPTP_RU_WANPHY_IP_DYNAMIC > $PPTP_IPDYNRU	
    echo $PPTP_RU_WANPHY_GATEWAY > $PPTP_GWRU
    if [ "$MCONN" != "" ]; then
    if [ "$MCONN" = "mconnect" ]; then 
    if [ -r "$MCONNECTFILE" ]; then
    	#echo "can read $MCONNECTFILE"
	echo "mconnect " >> $OPTIONS
	else
	#echo "pppoe.sh can not read $MCONNECTFILE"
	rm -f $CONNECTFILE
	pptp_ru.sh eth1
	exit
    fi
    fi
    fi

    if [ ! -f $FIRSTDEMAND ]; then
      echo "pass" > $FIRSTDEMAND
      #upnp.sh
    fi
    #sleep 5
    exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:WAN Dialup;note:Try to establish PPTP line;"
    killall -9 igmpproxy 2> /dev/null
    killall -9 dnrd 2> /dev/null 
    killall -9 pppd 2> /dev/null
    pppd call rpptp
  fi
  sleep 3
  done
  rm -f $FIRSTDEMAND
  } &
fi
if [ $PPTP_RU_CONNECTION_TYPE = 1 ] ; then
   #upnp.sh
   if [ "$MCONN" != "" ]; then
    if [ "$MCONN" = "mconnect" ]; then
     if [ -r "$MCONNECTFILE" ]; then
   	rm -f $MCONNECTFILE
    fi
    fi
    fi
   if [ $ENABLE_CONNECT = 1 ]; then
   #sleep 5
   exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:WAN Dialup;note:Try to establish PPTP line;"
   echo "$PPTP_RU_WANPHY_IP_DYNAMIC" > $PPTP_IPDYNRU	
   echo "$PPTP_RU_WANPHY_GATEWAY" > $PPTP_GWRU
   if [ ! -f /var/setwan_check ]; then
    	setfirewall restore $WAN_DHCP $PPTP_RU_WANPHY_IP_DYNAMIC
    fi
   pppd call rpptp
   fi
fi


