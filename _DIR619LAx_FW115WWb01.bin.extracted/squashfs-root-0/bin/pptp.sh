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
RESOLV_CONF="/etc/resolv.conf"	
PPTP_GW="/var/pptp_gw"
PPTP_IPDYN="/var/pptp_dyn"
PID_FILE=/var/run/ppp0.pid
DNRD_PID=/var/run/dnrd.pid
LINKFILE=/etc/ppp/link
eval `flash get PPTP_USER_NAME`
eval `flash get PPTP_PASSWORD`
eval `flash get PPTP_IP_ADDR`
eval `flash get PPTP_SUBNET_MASK`
eval `flash get PPTP_GATEWAY`
eval `flash get PPTP_SERVER_IP_ADDR`
eval `flash get PPTP_MTU_SIZE`
eval `flash get DNS_MODE`
eval `flash get DNS1`
eval `flash get DNS2`
eval `flash get DNS3`
eval `flash get WAN_DHCP`
eval `flash get PPTP_CONNECTION_TYPE`
eval `flash get PPTP_IDLE_TIME`
eval `flash get PPTP_WAN_IP_DYNAMIC`
eval `flash get DNSRELAY_ENABLED`
eval `flash get OP_MODE`
#MSS=`expr $PPTP_MTU_SIZE - 8`
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
	 eval `flash get DNS2`
	  if [ "$DNS2" != '0.0.0.0' ]; then
        DNS="$DNS -s $DNS2"
	        	if [ ! -r $RESOLV_CONF ]; then
						echo nameserver $DNS2 > $RESOLV_CONF         
    			fi
	 fi
	 if [ $DNSRELAY_ENABLED = 1 ]; then
    dnrd $DNS
    fi
 else
 	if [ $PPTP_WAN_IP_DYNAMIC = 1 ]; then
 		if [ ! -r $RESOLV_CONF ]; then
    		echo "nameserver $PPTP_GATEWAY" > $RESOLV_CONF 
    		fi
	 			if [ $DNSRELAY_ENABLED = 1 ]; then
    		dnrd -s $PPTP_GATEWAY --cache=off
    			fi
    	else
    		if [ -r /var/eth1_gw ]; then
    			PPTP_WANPHY_GATEWAY=`cat /var/eth1_gw`
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
	 				if [ $DNSRELAY_ENABLED = 1 ]; then
		    		dnrd --cache=off $DNS
		    		fi
		    		rm -f /tmp/ddfile 2> /dev/null
		    		
		    	else
    				echo "nameserver $PPTP_WANPHY_GATEWAY" > $RESOLV_CONF 
	    			
		 			if [ $DNSRELAY_ENABLED = 1 ]; then
				dnrd -s $PPTP_WANPHY_GATEWAY --cache=off
    			fi
    		fi
fi
fi
fi
if [ $PPTP_CONNECTION_TYPE = 2 ]; then
	if [ $PPTP_WAN_IP_DYNAMIC = 0 ]; then
		if [ -r /var/eth1_gw ]; then
	    			PPTP_WANPHY_GATEWAY=`cat /var/eth1_gw`
	    fi
	else
		PPTP_WANPHY_GATEWAY=$PPTP_GATEWAY
	fi
	setfirewall serverip $WAN_DHCP $PPTP_IP_ADDR $PPTP_SUBNET_MASK $PPTP_SERVER_IP_ADDR $PPTP_WANPHY_GATEWAY
if [ -r /var/pptp_server ]; then
	PPTP_SERVER_IP_ADDR=`cat /var/pptp_server`
fi
#route del  default dev $WAN
fi

#generate option file even the user name is null
#if [ -n "$PPTP_USER_NAME" ] ; then
	rm -f /etc/ppp/ppp_class 2> /dev/null
	flash gen-pptp $OPTIONS $PAPFILE $CHAPFILE
#fi

echo "lock" >> $OPTIONS  
echo "noauth" >> $OPTIONS  
echo "nobsdcomp" >> $OPTIONS  
echo "nodeflate" >> $OPTIONS  
echo "usepeerdns" >> $OPTIONS  
echo "lcp-echo-interval 20" >> $OPTIONS
echo "lcp-echo-failure 3" >> $OPTIONS
#echo "mtu $MSS" >> $OPTIONS
echo "mtu $PPTP_MTU_SIZE" >> $OPTIONS
echo "wantype $WAN_DHCP" >> $OPTIONS
echo "holdoff 2" >> $OPTIONS
echo "allow-auth 129" >> $OPTIONS
echo "remotename PPTP" > $RPPTP
echo "linkname PPTP" >> $RPPTP
echo "ipparam PPTP" >> $RPPTP
echo "pty \"pptp $PPTP_SERVER_IP_ADDR  --nolaunchpppd\"" >> $RPPTP
echo "name $PPTP_USER_NAME" >> $RPPTP

eval `flash get PPTP_SECURITY_ENABLED`
eval `flash get PPTP_SECURITY_LENGTH`

if [ $PPTP_SECURITY_ENABLED != 0 ]; then
 	echo "+mppe required,stateless" >> $RPPTP
fi
if [ "$PPTP_SECURITY_ENABLED" = "0" ]; then
echo "noccp" >> $RPPTP 
fi
echo "persist" >> $RPPTP
echo "noauth" >>$RPPTP
echo "file /etc/ppp/options" >>$RPPTP
echo "nobsdcomp" >>$RPPTP
echo "novj" >>$RPPTP

if [ -r "$PPPFILE" ]; then
  rm $PPPFILE
fi
###############################add check schedule
inDisConnect=0
StartDial=0
isMConnect=0
if [ $PPTP_CONNECTION_TYPE = 0 ]; then
eval `flash get PPTP_DIAL_SCHEDULE`
#eval `flash get NTP_ENABLED`
#eval `flash get NTP_TIMEZONE`
#TZ1=`echo $NTP_TIMEZONE | cut -d" " -f1`
#TZ2=`echo $NTP_TIMEZONE | cut -d" " -f2`
eval `flash get SCHEDULE_ENABLED`

if [ "$PPTP_DIAL_SCHEDULE" != 'Always' ]; then
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
		   			if [ "$p5" = "$PPTP_DIAL_SCHEDULE" ]; then
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
if [ $PPTP_CONNECTION_TYPE = 0 ]; then
  {
  eval `flash get PPTP_CONNECTION_TYPE`
  eval `flash get WAN_DHCP`
  while [ true ]; do
 
  if [ $WAN_DHCP != 4 ] || [ $PPTP_CONNECTION_TYPE != 0 ]; then
    break
  fi
  
	if [ $ENABLE_CONNECT = 1 ]; then #manual connect
		StartDial=1
	else
		if [ "$PPTP_DIAL_SCHEDULE" != 'Always' ]; then
	  		time_ck -e $SCH_ARGS
	  		StartDial=$? 
	  	else
		  	StartDial=1
	  	fi
	fi
	
	
	
	if [ $StartDial = 1 ]; then
		inDisConnect=0
  		if [ ! -r "$CONNECTFILE" ]  && [ $PPTP_CONNECTION_TYPE = 0 ]; then
    		echo "pass" > $CONNECTFILE 
    		echo $PPTP_WAN_IP_DYNAMIC > $PPTP_IPDYN	
    		echo $PPTP_GATEWAY > $PPTP_GW
     		if [ $PPTP_WAN_IP_DYNAMIC = 0 ]; then
    			if [ -r /var/eth1_gw ]; then
    				PPTP_GATEWAY=`cat /var/eth1_gw`
    				route add -net default gw $PPTP_GATEWAY dev eth1 2> /dev/null 
    			fi
    		else
    			route add -net default gw $PPTP_GATEWAY dev eth1 2> /dev/null 
    		fi
	    if [ ! -f $FIRSTFILE ]; then
	      echo "pass" > $FIRSTFILE
	      #upnp.sh
	    fi
	    ##if [ ! -f /var/setdns_hostname_check ]; then      
	    ##	setfirewall dns_hostname $WAN_DHCP
	    ##fi
	    	#sleep 5 
	    	exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:WAN Dialup;note:Try to establish PPTP line;"
	    	pppd call rpptp 
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
if [ $PPTP_CONNECTION_TYPE = 2 ] ; then
  {
  echo "persist" >> $OPTIONS
  echo "nodetach" >>$OPTIONS
  echo "connect /etc/ppp/true" >> $OPTIONS
  echo "demand" >> $OPTIONS
  echo "idle $PPTP_IDLE_TIME" >> $OPTIONS
  echo "ktune" >> $OPTIONS
  echo "ipcp-accept-remote" >> $OPTIONS
  echo "ipcp-accept-local" >> $OPTIONS
  echo "noipdefault" >> $OPTIONS
  echo "defaultroute" >> $OPTIONS
  echo "hide-password" >> $OPTIONS
  while [ true ]; do
  eval `flash get PPTP_CONNECTION_TYPE`
  eval `flash get WAN_DHCP`
  if [ $WAN_DHCP != 4 ] || [ $PPTP_CONNECTION_TYPE != 2 ]; then
    break
  fi

  if [ ! -r "$CONNECTFILE" ]  && [ $PPTP_CONNECTION_TYPE = 2 ]; then
    echo "pass" > $CONNECTFILE
    echo $PPTP_WAN_IP_DYNAMIC > $PPTP_IPDYN	
    echo $PPTP_GATEWAY > $PPTP_GW
    if [ "$MCONN" != "" ]; then
    if [ "$MCONN" = "mconnect" ]; then 
    if [ -r "$MCONNECTFILE" ]; then
    	#echo "can read $MCONNECTFILE"
	echo "mconnect " >> $OPTIONS
	else
	#echo "pppoe.sh can not read $MCONNECTFILE"
	rm -f $CONNECTFILE
	if [ $OP_MODE = 0 ]; then
		pptp.sh eth1
	fi
	if [ $OP_MODE = 2 ]; then
		pptp.sh wlan0
	fi
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
    sleep 5
    pppd call rpptp
  fi
  sleep 10
  done
  rm -f $FIRSTDEMAND
  } &
fi
if [ $PPTP_CONNECTION_TYPE = 1 ] ; then
   #upnp.sh
   if [ "$MCONN" != "" ]; then
   if [ "$MCONN" = "mconnect" ]; then
     if [ -r "$MCONNECTFILE" ]; then
   	rm -f $MCONNECTFILE
    fi
    fi
    fi
   if [ $ENABLE_CONNECT = 1 ]; then
   ##setfirewall dns_hostname $WAN_DHCP 
   #sleep 5
   exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:WAN Dialup;note:Try to establish PPTP line;"
   echo $PPTP_WAN_IP_DYNAMIC > $PPTP_IPDYN	
   echo $PPTP_GATEWAY > $PPTP_GW
   if [ $PPTP_WAN_IP_DYNAMIC = 0 ]; then
    		if [ -r /var/eth1_gw ]; then
    			PPTP_GATEWAY=`cat /var/eth1_gw`
    			route add -net default gw $PPTP_GATEWAY dev eth1 2> /dev/null 
    		fi
    	else
    		route add -net default gw $PPTP_GATEWAY dev eth1 2> /dev/null 
    fi
   pppd call rpptp
   fi
fi


