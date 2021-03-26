#!/bin/sh
#WAN=eth1
WAN=$2
LAN=eth0
CLASSFILE=/etc/ppp/ppp_class
OPTIONS=/etc/ppp/options
PAPFILE=/etc/ppp/pap-secrets
CHAPFILE=/etc/ppp/chap-secrets

PAPFILE1=/etc/ppp/pap-secrets1
CHAPFILE1=/etc/ppp/chap-secrets1

PAPFILE2=/etc/ppp/pap-secrets2
CHAPFILE2=/etc/ppp/chap-secrets2

PAPFILE3=/etc/ppp/pap-secrets3
CHAPFILE3=/etc/ppp/chap-secrets3
PAPFILE4=/etc/ppp/pap-secrets4
CHAPFILE4=/etc/ppp/chap-secrets4

PPPOEGET=/etc/ppp/pppoe_padt1

RESOLV=/etc/ppp/resolv.conf
LINKFILE=/etc/ppp/link
PPPFILE=/var/run/ppp
FIRSTFILE=/etc/ppp/first
FIRSTDEMAND=/etc/ppp/firstdemand
CONNECTFILE=/etc/ppp/connectfile
MCONNECTFILE=/var/ppp/mconnectfile
DNRDPIDFILE=/var/run/dnrd.pid
eval `flash get PPP_USER_NAME`
eval `flash get PPP_PASSWORD`
eval `flash get PPP_IDLE_TIME`
eval `flash get PPP_CONNECT_TYPE`
eval `flash get PPP_MTU_SIZE`
eval `flash get PPPOE_DNS_MODE`
eval `flash get DNS1`
eval `flash get DNS2`
eval `flash get DNS3`
eval `flash get PPP_SERVICE_NAME`
eval `flash get DNSRELAY_ENABLED`
eval `flash get OP_MODE`
eval `flash get-LangCode`
eval `flash get PPPOE_NETSNIPER`
if [ "$LangCode" = "SC" ]; then
	eval `flash get PPP_CLASS`
	eval `flash get PPP_XKJS`
else
	PPP_CLASS=0
	PPP_XKJS=0
fi
#MSS=`expr $PPP_MTU_SIZE - 8`
ifconfig $WAN 0.0.0.0
route del default gw 0.0.0.0 dev $WAN
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
flash class-pppoe $CLASSFILE $PAPFILE $CHAPFILE
flash get-pppoe $PPPOEGET $PAPFILE $CHAPFILE
if [ $PPP_CLASS != 0 -o $PPP_XKJS != 0 ]; then
    flash xkjs-pppoe $OPTIONS $PAPFILE1 $CHAPFILE1 $WAN  $LAN
    flash xkjs1-pppoe $OPTIONS $PAPFILE2 $CHAPFILE2 $WAN  $LAN
    flash hbxk-pppoe $OPTIONS $PAPFILE3 $CHAPFILE3
    flash hnxk-pppoe $OPTIONS $PAPFILE4 $CHAPFILE4
	flash set-xkjs-langpack
	ifconfig $WAN 0.0.0.0
	route del default gw 0.0.0.0 dev $WAN
fi

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
echo "mtu $PPP_MTU_SIZE" >> $OPTIONS  
echo "mru $PPP_MTU_SIZE" >> $OPTIONS  
echo "lcp-echo-interval 14" >> $OPTIONS  
echo "lcp-echo-failure 11" >> $OPTIONS  
echo "wantype $WAN_DHCP" >> $OPTIONS
eval `flash get PPPOE_WAN_IP_DYNAMIC`
if [ $PPPOE_WAN_IP_DYNAMIC = 1 ]; then
  eval `flash get PPPOE_IP_ADDR`
  echo "$PPPOE_IP_ADDR:0.0.0.0" >> $OPTIONS  
  echo "netmask 255.255.255.255" >> $OPTIONS  
fi

if [ -n "$PPP_SERVICE_NAME" ]; then
#  echo "plugin /etc/ppp/plugins/libplugin.a rp_pppoe_ac 62031090091393-Seednet_240_58  rp_pppoe_service $PPP_SERVICE_NAME $WAN" >> $OPTIONS
  echo "plugin /etc/ppp/plugins/libplugin.a rp_pppoe_service $PPP_SERVICE_NAME $WAN" >> $OPTIONS
else
  echo "plugin /etc/ppp/plugins/libplugin.a $WAN" >> $OPTIONS
fi

PID_FILE=/var/run/ppp0.pid
DNRD_PID=/var/run/dnrd.pid
RESOLV_CONF="/etc/resolv.conf"

   DNS="--cache=off"
   if [ $PPPOE_DNS_MODE != 1 ]; then
   
	if [ $DNSRELAY_ENABLED = 1 ]; then
      dnrd $DNS -s 168.95.1.1
   fi
   fi
   if [ $PPPOE_DNS_MODE = 1 ]; then
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
		if [ $DNSRELAY_ENABLED = 1 ]; then
      dnrd $DNS
   fi
   fi


if [ -r "$PPPFILE" ]; then
  rm $PPPFILE
fi


###############################add check schedule
inDisConnect=0
StartDial=0
isMConnect=0

eval `flash get MYDLINK_REGISTER_ST`
if [ $MYDLINK_REGISTER_ST = 1 ]; then
	if [ $PPP_CONNECT_TYPE = 2 ]; then
		PPP_CONNECT_TYPE=0
	fi
fi

if [ $PPP_CONNECT_TYPE = 0 ]; then
eval `flash get PPPOE_DIAL_SCHEDULE`
#eval `flash get NTP_ENABLED`
#eval `flash get NTP_TIMEZONE`
#TZ1=`echo $NTP_TIMEZONE | cut -d" " -f1`
#TZ2=`echo $NTP_TIMEZONE | cut -d" " -f2`
eval `flash get SCHEDULE_ENABLED`

if [ "$PPPOE_DIAL_SCHEDULE" != 'Always' ]; then
		if [ "$SCHEDULE_ENABLED" != 0 ]; then
			eval `flash get SCHEDULE_TBL_NUM`
				if [ "$SCHEDULE_TBL_NUM" != 0 ]; then
				 num=1
				 while [ $num -le $SCHEDULE_TBL_NUM ];
		  		do
		  			SCHEDULE_TBL=`flash get SCHEDULE_TBL | grep SCHEDULE_TBL$num=`
		  			SCH_ARGS=`echo $SCHEDULE_TBL | cut -f2 -d=`
		    			p1=`echo $SCH_ARGS | cut -f1 -d,`
		    			p2=`echo $SCH_ARGS | cut -f2 -d,`
		    			p3=`echo $SCH_ARGS | cut -f3 -d,`
		   			p4=`echo $SCH_ARGS | cut -f4 -d,`
		    			p5=`echo $SCH_ARGS | cut -f5 -d,`
		   			if [ "$p5" = "$PPPOE_DIAL_SCHEDULE" ]; then
		   				#echo "We got  schedule rule $p5"
		   				break;
		   			fi 
		  			num=`expr $num + 1`
		  		done
					
				fi
		fi
	fi
fi
############################


if [ $PPP_CONNECT_TYPE = 0 ] ; then
  {
   if [ $1 = "mconnect" ]; then
   if [ -r "$MCONNECTFILE" ]; then
   	rm -f $MCONNECTFILE
    fi
    fi
  while [ true ]; 
  do
 

	  if [ $WAN_DHCP != 3 ] || [ $PPP_CONNECT_TYPE != 0 ]; then
	    break
	  fi
	  if [ $1 = "mconnect" ]; then
	  	StartDial=1
	  else
	  	if [ "$PPPOE_DIAL_SCHEDULE" != 'Always' ]; then
	  		time_ck -e $SCH_ARGS
	  		StartDial=$? 
	  	else
		  	StartDial=1
	  	fi
	  fi
	  	
	if [ $StartDial = 1 ]; then
			inDisConnect=0
			  if [ ! -r "$CONNECTFILE" ]  && [ $PPP_CONNECT_TYPE = 0 ]; then
			    echo "pass" > $CONNECTFILE
			    if [ ! -f $FIRSTFILE ]; then
			      echo "pass" > $FIRSTFILE
			      #upnp.sh
			    fi
			    ##if [ ! -f /var/setdns_hostname_check ]; then
			    ##setfirewall dns_hostname $WAN_DHCP
			    ##fi
    
			    pppd &
			  fi
	else
		if [ -r "$LINKFILE" ] && [ $inDisConnect = 0 ]; then
			disconnect.sh option
			inDisConnect=1
		fi
  	fi	
  sleep 5
  done
  rm -f $FIRSTFILE
  } &
fi
 
if [ $PPP_CONNECT_TYPE = 2 ] ; then
  {

  echo "demand" >> $OPTIONS
  echo "idle $PPP_IDLE_TIME" >> $OPTIONS
  while [ true ]; 
  do
  eval `flash get PPP_CONNECT_TYPE`
  eval `flash get WAN_DHCP`

  if [ $WAN_DHCP != 3 ] || [ $PPP_CONNECT_TYPE != 2 ]; then
    break
  fi
  if [ ! -r "$CONNECTFILE" ]  && [ $PPP_CONNECT_TYPE = 2 ]; then
    echo "pass" > $CONNECTFILE
   if [ $1 = "mconnect" ]; then 
    if [ -r "$MCONNECTFILE" ]; then
    	#echo "can read $MCONNECTFILE"
	echo "mconnect " >> $OPTIONS
	else
	#echo "pppoe.sh can not read $MCONNECTFILE"
	rm -f $CONNECTFILE
	
	if [ $OP_MODE = 0 ]; then
		pppoe.sh all eth1
	fi
	if [ $OP_MODE = 2 ]; then
		pppoe.sh all wlan0
	fi
	exit
    fi
    fi
    if [ ! -f $FIRSTDEMAND ]; then
      echo "pass" > $FIRSTDEMAND
      #upnp.sh
    fi
	echo "sleep 3 pppoe.sh -> pppd"
 	sleep 3   
    pppd &
  fi
  sleep 10
  done
  rm -f $FIRSTDEMAND
  } &
fi


if [ $PPP_CONNECT_TYPE = 1 ]; then
   #upnp.sh
   if [ $1 = "mconnect" ]; then
   if [ -r "$MCONNECTFILE" ]; then
   	rm -f $MCONNECTFILE
    fi
    fi
   if [ $ENABLE_CONNECT = 1 ]; then
     echo "PPPOE connect!!"
     ##setfirewall dns_hostname $WAN_DHCP 
   pppd &
   fi
fi

