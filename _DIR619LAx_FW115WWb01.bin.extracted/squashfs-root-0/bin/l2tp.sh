#!/bin/sh
#WAN=eth1
WAN=$1
MCONN=$2
L2TPCONF=/etc/ppp/l2tpd.conf
OPTIONS=/etc/ppp/options
RPPTP=/etc/ppp/peers/rpptp
PAPFILE=/etc/ppp/pap-secrets
CHAPFILE=/etc/ppp/chap-secrets
RESOLV=/etc/ppp/resolv.conf
PPPFILE=/var/run/ppp
FIRSTFILE=/etc/ppp/firstl2tp
FIRSTDEMAND=/etc/ppp/firstl2tp_demand
CONNECTFILE=/etc/ppp/connectfile
MCONNECTFILE=/var/ppp/mconnectfile
CONNECTLINKFILE=/etc/ppp/link
L2TP_IPDYN=/var/l2tp_dyn
L2TP_GW=/var/l2tp_gw
DNRDPIDFILE=/var/run/dnrd.pid
LINKFILE=/etc/ppp/link
eval `flash get L2TP_USER_NAME`
eval `flash get L2TP_PASSWORD`
eval `flash get L2TP_IP_ADDR`
eval `flash get L2TP_SUBNET_MASK`
eval `flash get L2TP_GATEWAY`
eval `flash get L2TP_SERVER_IP_ADDR`
eval `flash get L2TP_MTU_SIZE`
eval `flash get L2TP_IDLE_TIME`
eval `flash get DNS_MODE`
eval `flash get DNS1`
eval `flash get DNS2`
eval `flash get DNS3`
eval `flash get WAN_DHCP`
eval `flash get L2TP_CONNECTION_TYPE`
eval `flash get L2TP_WAN_IP_DYNAMIC`
eval `flash get DNSRELAY_ENABLED`
eval `flash get OP_MODE`
#MSS=`expr $L2TP_MTU_SIZE - 8`
rm -f /etc/ppp/ppp_class 2> /dev/null
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
RESOLV_CONF="/etc/resolv.conf"
DNS="--cache=off"

eval `flash get MYDLINK_REGISTER_ST`
if [ $MYDLINK_REGISTER_ST = 1 ]; then
	if [ $L2TP_CONNECTION_TYPE = 2 ]; then 
       		L2TP_CONNECTION_TYPE=0
	fi
fi

if [ $DNS_MODE = 1 ]; then
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
	if [ $L2TP_WAN_IP_DYNAMIC = 1 ]; then
		if [ ! -r $RESOLV_CONF ]; then 
    		echo "nameserver $L2TP_GATEWAY" > $RESOLV_CONF 
    		fi
    	if [ $DNSRELAY_ENABLED = 1 ]; then
    		dnrd -s $L2TP_GATEWAY --cache=off
    	fi
    	else
    		if [ -r /var/eth1_gw ]; then
    			L2TP_GATEWAY=`cat /var/eth1_gw`
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
    			echo "nameserver $L2TP_GATEWAY" > $RESOLV_CONF 
	    			if [ $DNSRELAY_ENABLED = 1 ]; then
				dnrd -s $L2TP_GATEWAY --cache=off
    			fi
    		fi
fi
fi
fi
if [ $L2TP_CONNECTION_TYPE = 2 ]; then
if [ $L2TP_WAN_IP_DYNAMIC = 0 ]; then
	if [ -r /var/eth1_gw ]; then
		L2TP_WANPHY_GATEWAY=`cat /var/eth1_gw`
	fi
else
		L2TP_WANPHY_GATEWAY=$L2TP_GATEWAY
fi
	killall -9 igmpproxy 2> /dev/null
    	killall -9 dnrd 2> /dev/null 
	killall -9 pppd 2> /dev/null
	setfirewall serverip $WAN_DHCP $L2TP_IP_ADDR $L2TP_SUBNET_MASK $L2TP_SERVER_IP_ADDR $L2TP_WANPHY_GATEWAY
	if [ -r /var/l2tp_server ]; then
		L2TP_SERVER_IP_ADDR=`cat /var/l2tp_server`
	fi
#route del  default dev $WAN
fi
echo "" > $OPTIONS
#generate options file even the user name is null
#if [ -n "$L2TP_USER_NAME" ] ; then
  echo "user \"$L2TP_USER_NAME\"" > $OPTIONS
  echo "#################################################" > $PAPFILE  
  echo "\"$L2TP_USER_NAME\"	*	\"$L2TP_PASSWORD\"" >> $PAPFILE
  echo "#################################################" > $CHAPFILE
  echo "\"$L2TP_USER_NAME\"	*	\"$L2TP_PASSWORD\"" >> $CHAPFILE
#fi

echo "lock" >> $OPTIONS  
echo "noauth" >> $OPTIONS  
echo "defaultroute" >> $OPTIONS  
echo "usepeerdns" >> $OPTIONS  
echo "lcp-echo-interval 0" >> $OPTIONS
#echo "mtu $MSS" >> $OPTIONS
echo "mtu $L2TP_MTU_SIZE" >> $OPTIONS
echo "wantype $WAN_DHCP" >> $OPTIONS
echo "name $L2TP_USER_NAME" >> $OPTIONS
echo "noauth" >>$OPTIONS
echo "nodeflate" >>$OPTIONS
echo "nobsdcomp" >>$OPTIONS
echo "nodetach" >>$OPTIONS
echo "default-asyncmap" >>$OPTIONS
echo "nopcomp" >>$OPTIONS
echo "noaccomp" >>$OPTIONS
echo "noccp" >>$OPTIONS
echo "novj" >>$OPTIONS
echo "nobsdcomp" >> $OPTIONS  

echo "[global]" > $L2TPCONF
echo "port = 1701" >> $L2TPCONF
echo "auth file = /etc/ppp/chap-secrets" >> $L2TPCONF
echo "[lac client]" >> $L2TPCONF
echo "lns=$L2TP_SERVER_IP_ADDR" >> $L2TPCONF
echo "require chap = yes" >> $L2TPCONF
echo "name = $L2TP_USER_NAME" >> $L2TPCONF
echo "pppoptfile = /etc/ppp/options" >> $L2TPCONF

l2tpd -m $L2TP_CONNECTION_TYPE


###############################add check schedule
inDisConnect=0
StartDial=0
isMConnect=0
if [ $L2TP_CONNECTION_TYPE = 0 ]; then
eval `flash get L2TP_DIAL_SCHEDULE`
#eval `flash get NTP_ENABLED`
#eval `flash get NTP_TIMEZONE`
#TZ1=`echo $NTP_TIMEZONE | cut -d" " -f1`
#TZ2=`echo $NTP_TIMEZONE | cut -d" " -f2`
eval `flash get SCHEDULE_ENABLED`

if [ "$L2TP_DIAL_SCHEDULE" != 'Always' ]; then
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
		   			if [ "$p5" = "$L2TP_DIAL_SCHEDULE" ]; then
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



if [ $L2TP_CONNECTION_TYPE = 1 ] && [ $ENABLE_CONNECT = 1 ]; then

if [ "$MCONN" != "" ]; then
   if [ "$MCONN" = "mconnect" ]; then
     if [ -r "$MCONNECTFILE" ]; then
   	rm -f $MCONNECTFILE
    fi
    fi
    fi
exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:WAN Dialup;note:Try to establish L2TP line;"
    echo $L2TP_WAN_IP_DYNAMIC > $L2TP_IPDYN	
    echo $L2TP_GATEWAY > $L2TP_GW
    	if [ $L2TP_WAN_IP_DYNAMIC = 0 ]; then
    		if [ -r /var/eth1_gw ]; then
    			L2TP_GATEWAY=`cat /var/eth1_gw`
    			route add -net default gw $L2TP_GATEWAY dev eth1 2> /dev/null 
    		fi
    	else
    		route add -net default gw $L2TP_GATEWAY dev eth1 2> /dev/null 
    	fi
    ##setfirewall dns_hostname $WAN_DHCP 	
    echo "c client" > /var/run/l2tp-control
    exit    
fi

if [ $L2TP_CONNECTION_TYPE = 0 ] ; then
  {
  while [ true ]; do


  if [ $WAN_DHCP != 6 ] || [ $L2TP_CONNECTION_TYPE != 0 ]; then
    echo "d client" > /var/run/l2tp-control &
    break
  fi
  	
  	if [ $ENABLE_CONNECT = 1 ]; then #manual connect
		StartDial=1
	else
		if [ "$L2TP_DIAL_SCHEDULE" != 'Always' ]; then
	  		time_ck -e $SCH_ARGS
	  		StartDial=$? 
	  	else
		  	StartDial=1
	  	fi
	fi

	if [ ! -f "$CONNECTLINKFILE" ] && [ -f "$CONNECTFILE" ]; then
		rm -f $CONNECTFILE
	fi
  	
	if [ $StartDial = 1 ]; then
		inDisConnect=0
  		if [ ! -r "$CONNECTFILE" ]  && [ $L2TP_CONNECTION_TYPE = 0 ] && [ ! -r /var/disc ]; then
    			echo "pass" > $CONNECTFILE
    			echo $L2TP_WAN_IP_DYNAMIC > $L2TP_IPDYN	
    			echo $L2TP_GATEWAY > $L2TP_GW
    		if [ $L2TP_WAN_IP_DYNAMIC = 0 ]; then
    			if [ -r /var/eth1_gw ]; then
    				L2TP_GATEWAY=`cat /var/eth1_gw`
    				route add -net default gw $L2TP_GATEWAY dev eth1 2> /dev/null 
    			fi
    		else
    			route add -net default gw $L2TP_GATEWAY dev eth1 2> /dev/null 
    		fi
    		if [ ! -f $FIRSTFILE ]; then
      			echo "pass" > $FIRSTFILE
    		fi
		exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:WAN Dialup;note:Try to establish L2TP line;"
    		##if [ ! -f /var/setdns_hostname_check ]; then
        	##	setfirewall dns_hostname $WAN_DHCP 
    		##fi
    		echo "c client" > /var/run/l2tp-control &
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

if [ $L2TP_CONNECTION_TYPE = 2 ] ; then
  {
  echo "connect /etc/ppp/true" >> $OPTIONS
  echo "demand" >> $OPTIONS
  echo "idle $L2TP_IDLE_TIME" >> $OPTIONS  
  while [ true ]; do
#  eval `flash get L2TP_CONNECTION_TYPE`
#  eval `flash get WAN_DHCP`

  if [ $WAN_DHCP != 6 ] || [ $L2TP_CONNECTION_TYPE != 2 ]; then
    echo "d client" > /var/run/l2tp-control &
    break
  fi
  if [ ! -r "$CONNECTFILE" ]  && [ $L2TP_CONNECTION_TYPE = 2 ] && [ ! -r /var/disc ]; then
    echo "pass" > $CONNECTFILE
    
    echo $L2TP_WAN_IP_DYNAMIC > $L2TP_IPDYN	
    echo $L2TP_GATEWAY > $L2TP_GW
    
	killall -9 igmpproxy 2> /dev/null
	killall -9 dnrd 2> /dev/null 
	killall -9 pppd 2> /dev/null
    	#setfirewall refirewall $WAN_DHCP
    	#sleep 1
    if [ "$MCONN" != "" ]; then
    if [ "$MCONN" = "mconnect" ]; then 
    if [ -r "$MCONNECTFILE" ]; then
    	#echo "can read $MCONNECTFILE"
	echo "mconnect " >> $OPTIONS
	else
	#echo "l2tp.sh can not read $MCONNECTFILE"
	rm -f $CONNECTFILE
	killall l2tpd 2> /dev/null
	if [ $OP_MODE = 0 ]; then
		l2tp.sh eth1
	fi
	if [ $OP_MODE = 2 ]; then
		l2tp.sh wlan0
	fi
	exit
    fi
    fi
    fi
    
    if [ ! -f $FIRSTFILE ]; then
      echo "pass" > $FIRSTFILE
      #upnp.sh
    fi
exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:WAN Dialup;note:Try to establish L2TP line;"
    echo "c client" > /var/run/l2tp-control &
    setfirewall restore1 6
  fi
  sleep 5
  done
  rm -f $FIRSTFILE
  } &
fi

