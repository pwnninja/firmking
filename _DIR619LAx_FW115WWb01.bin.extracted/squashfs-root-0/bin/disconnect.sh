#!/bin/sh
CK_IGMP=$2
LINKFILE=/etc/ppp/link
DHCPPLUS_LINKFILE=/etc/dhcpplus/link
PPPFILE=/var/run/ppp0.pid
CONNECTFILE=/etc/ppp/connectfile
MCONNECTFILE=/var/ppp/mconnectfile
TMPFILE=/tmp/tmpfile
PLUTO_PID=/var/run/pluto.pid
FIRSTDDNS=/var/firstddns
PPTP_GW=/var/pptp_gw
PPTP_IPDYN="/var/pptp_dyn"
L2TP_GW=/var/l2tp_gw
L2TP_IPDYN="/var/l2tp_dyn"
SetWanPhy_Check=/var/setwan_check
START_STATIC_ROUTE=/bin/st_route.sh
STOP_STATIC_ROUTE=/bin/st_route_del.sh
DHC_RESOLV_CONF="/etc/udhcpc/resolv.conf"
ETC_RESOLV_CONF=/var/resolv.conf
SetDns_Hostname_Check=/var/setdns_hostname_check
DISABLE_HOSTNAME=1
NTP_PROCESS=/var/ntp_run
echo "enter" > /var/disc
eval `flash get WAN_DHCP`
eval `flash get L2TP_CONNECTION_TYPE`
eval `flash get PPTP_CONNECTION_TYPE`
#eval `flash get PPTP_RU_CONNECTION_TYPE`
eval `flash get PPP_CONNECT_TYPE`
#eval `flash get PPPOE_RU_CONNECT_TYPE`
eval `flash get L2TP_WAN_IP_DYNAMIC`
eval `flash get PPTP_WAN_IP_DYNAMIC`
#eval `flash get PPTP_RU_WANPHY_IP_DYNAMIC`
#eval `flash get PPTP_RU_WANPHY_GATEWAY`
#eval `flash get PPPOE_RU_WANPHY_GATEWAY`
eval `flash get PPTP_GATEWAY`
eval `flash get L2TP_GATEWAY`
#killall -9 miniigd 2> /dev/null
rm -f /var/ntp_run 2> /dev/null
killall -9 ntp.sh 2> /dev/null
killall -9 ntpclient 2> /dev/null
###########kill sleep that ntp.sh created###############
TMPFILEDDNS=/tmp/tmpfileddns
line=0
ps | grep "sleep 86400" > $TMPFILEDDNS
line=`cat $TMPFILEDDNS | wc -l`
num=1
while [ $num -le $line ];
do
	pat0=` head -n $num $TMPFILEDDNS | tail -n 1`
	pat1=`echo $pat0 | cut -f1 -dS`  
	pat2=`echo $pat1 | cut -f1 -d " "`  
	kill -9 $pat2 2> /dev/null

	num=`expr $num + 1`
done
line=0
ps | grep "sleep 300" > $TMPFILEDDNS
line=`cat $TMPFILEDDNS | wc -l`
num=1
while [ $num -le $line ];
do
        pat0=` head -n $num $TMPFILEDDNS | tail -n 1`
        pat1=`echo $pat0 | cut -f1 -dS`
        pat2=`echo $pat1 | cut -f1 -d " "`
        kill -9 $pat2 2> /dev/null

        num=`expr $num + 1`
done
###########################
rm -f /var/firstddns 2> /dev/null
rm -f /tmp/tmpfileddns 2> /dev/null
echo "0 0" > /proc/pptp_src_ip

if [ $PPP_CONNECT_TYPE = 2 ]; then
       	echo 0 > /var/ppp/demand_stats
fi
killall -9 ddns.sh 2> /dev/null
killall -15 routed 2> /dev/null
#kill igmpproxy before kill pppd
if [ -r /var/igmp_up ]; then
	IGMP_UP=`cat /var/igmp_up`
	if [ $IGMP_UP = 'ppp0' ]; then
killall -9 igmpproxy 2> /dev/null
	fi
else
killall -9 igmpproxy 2> /dev/null
fi
if [ $WAN_DHCP = 7 ] || [ $WAN_DHCP = 8 ]; then
	#if [ $1 = 'all' ] || [ $1 = 'manual' ]; then
	if [ $1 = 'all' ]; then
		PIDFILE=/var/run/dnrd.pid
		if [ -f $PIDFILE ] ; then
		killall -9 dnrd 2> /dev/null
		rm -f $PIDFILE
		fi
	else
		if [ -r "$LINKFILE" ] && [ ! -f $SetWanPhy_Check ]; then
			PIDFILE=/var/run/dnrd.pid
			if [ -f $PIDFILE ] ; then
				killall -9 dnrd 2> /dev/null
				rm -f $PIDFILE
			fi
		fi
	fi
else
	if [ $1 = 'all' ]; then
		PIDFILE=/var/run/dnrd.pid
		if [ -f $PIDFILE ] ; then
		killall -9 dnrd 2> /dev/null
		rm -f $PIDFILE
		fi
	else
	if [ -r "$LINKFILE" ] && [ ! -f $SetDns_Hostname_Check ]; then
		PIDFILE=/var/run/dnrd.pid
		if [ -f $PIDFILE ] ; then
			killall -9 dnrd 2> /dev/null
			rm -f $PIDFILE
		fi
	else
	if [ $1 = 'option' ]; then
	if [ $WAN_DHCP = 3 ]; then
		if [ $PPP_CONNECT_TYPE != 1 ]; then
			PIDFILE=/var/run/dnrd.pid
			if [ -f $PIDFILE ] ; then
			#echo "kill dnrd KeithKeithKeithKeithKeithKeith"
			killall -9 dnrd 2> /dev/null
			rm -f $PIDFILE
			fi
		fi
	fi 
	if [ $WAN_DHCP = 4 ]; then
		if [ $PPTP_CONNECTION_TYPE != 1 ]; then
			PIDFILE=/var/run/dnrd.pid
			if [ -f $PIDFILE ] ; then
			#echo "kill dnrd KeithKeithKeithKeithKeithKeith"
			killall -9 dnrd 2> /dev/null
			rm -f $PIDFILE
			fi
		fi
	fi
	if [ $WAN_DHCP = 6 ]; then 
		if [ $L2TP_CONNECTION_TYPE != 1 ]; then
			PIDFILE=/var/run/dnrd.pid
			if [ -f $PIDFILE ] ; then
			#echo "kill dnrd KeithKeithKeithKeithKeithKeith"
			killall -9 dnrd 2> /dev/null
			rm -f $PIDFILE
			fi
		fi
	fi

	fi
	fi	
	fi
fi
killall -9 updatedd 2> /dev/null
killall -9 ddns.sh 2> /dev/null
eval `flash get DDNS_TIMEOUT`
TIMEOUT=`expr $DDNS_TIMEOUT "*" 3600`
###########kill sleep that ddns.sh created###############
TMPFILEDDNS=/tmp/tmpfileddns
line=0
ps | grep "sleep $TIMEOUT" > $TMPFILEDDNS
line=`cat $TMPFILEDDNS | wc -l`
num=1
while [ $num -le $line ];
do
	pat0=` head -n $num $TMPFILEDDNS | tail -n 1`
	pat1=`echo $pat0 | cut -f1 -dS`  
	pat2=`echo $pat1 | cut -f1 -d " "`  
	kill -9 $pat2 2> /dev/null

	num=`expr $num + 1`
done
###########################
rm -f /var/firstddns 2> /dev/null
rm -f /tmp/tmpfileddns 2> /dev/null



if [ $WAN_DHCP = 6 ] && [ -r "$CONNECTFILE" ] && [ $1 = 'l2tp' ]; then
    exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:WAN Hangup;note:Disconnect L2TP line;"
fi
if [ $WAN_DHCP = 6 ] && [ $1 = 'option' ] && [ -r "$LINKFILE" ]; then
if [ $L2TP_CONNECTION_TYPE = 2 ]; then
	if [ ! -r /var/disc_l2tp ]; then
  	rm -f $CONNECTFILE
	echo "l2tpdisc" > /var/disc_l2tp
	echo "d client" > /var/run/l2tp-control
	exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:L2TP Idle Timeout!!;note:Disconnect L2TP line;"
	fi
else
    exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:WAN Hangup;note:Disconnect L2TP line;"
fi
fi
if [ ! -r /var/pppdkilled ]; then
echo kill > /var/pppdkilled 	
if [ $WAN_DHCP = 3 ] || [ $WAN_DHCP = 7 ] || [ $WAN_DHCP = 4 ] || [ $WAN_DHCP = 6 ]; then
   killall -15 pppd 2> /dev/null
else
   killall -9 pppd 2> /dev/null
fi
fi

killall -9 pppoe 2> /dev/null
killall -9 pptp 2> /dev/null

if [ -r "$PPPFILE" ]; then
  rm $PPPFILE
fi
if [ $WAN_DHCP = 4 ] && [ $1 = 'all' ] && [ -r "$LINKFILE" ]; then
 exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:WAN Hangup;note:Disconnect PPTP line;"
fi
#clean pptp_info in fastpptp
if [ $WAN_DHCP = 4 ] && [ $1 = 'option' ];  then
echo "1" > /proc/fast_pptp
fi
if [ $WAN_DHCP = 4 ] && [ $1 = 'manual' ]; then
exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:WAN Hangup;note:Disconnect PPTP line;"
fi

if [ $WAN_DHCP = 4 ] && [ $1 = 'option' ] && [ -r "$LINKFILE" ]; then
if [ $PPTP_CONNECTION_TYPE = 2 ]; then
exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:PPTP Idle Timeout!!;note:Disconnect PPTP line;"
else
exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:WAN Hangup;note:Disconnect PPTP line;"
fi
fi

if [ $WAN_DHCP = 8 ] && [ $1 = 'all' ] && [ -r "$LINKFILE" ]; then
 exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:WAN Hangup;note:Disconnect PPTP line;"
fi

if [ $WAN_DHCP = 8 ] && [ $1 = 'manual' ]; then
exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:WAN Hangup;note:Disconnect PPTP line;"
fi

if [ $WAN_DHCP = 8 ] && [ $1 = 'option' ] && [ -r "$LINKFILE" ]; then
if [ $PPTP_RU_CONNECTION_TYPE = 2 ]; then
exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:PPTP Idle Timeout!!;note:Disconnect PPTP line;"
else
exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:WAN Hangup;note:Disconnect PPTP line;"
fi
fi

if [ $WAN_DHCP = 6 ]; then
 if [ -r /var/l2tp_server ]; then
    	l2tp_serverIP=` head -n 1 /var/l2tp_server | tail -n 1`
    	if [ $L2TP_WAN_IP_DYNAMIC = 1 ]; then
    		route del -host $l2tp_serverIP gw $L2TP_GATEWAY 2> /dev/null
    	else
    		if [ -r /var/eth1_gw ]; then
    			l2tp_gateway=` head -n 1 /var/eth1_gw | tail -n 1`
    			route del -host $l2tp_serverIP gw $l2tp_gateway 2> /dev/null
    		fi
    	fi
  	rm -f $CONNECTFILE
    fi
fi

if [ $WAN_DHCP = 6 ]; then
	if [ $1 = 'option' ] && [ $L2TP_CONNECTION_TYPE != 1 ]; then
		if [ $L2TP_WAN_IP_DYNAMIC = 1 ]; then
			eval `flash get DNS1`
		    	if [ "$DNS1" != '0.0.0.0' ]; then
				echo nameserver $DNS1 > $ETC_RESOLV_CONF  
			else
				echo "nameserver $L2TP_GATEWAY" > $ETC_RESOLV_CONF      
		    	fi
		else
	    		if [ -r "$DHC_RESOLV_CONF" ]; then
				dhc_line_res=0
				cat $DHC_RESOLV_CONF | grep nameserver > /tmp/ppp_resolv 
				dhc_line_res=`cat /tmp/ppp_resolv | wc -l`
				dhc_num=1
				while [ $dhc_num -le $dhc_line_res ];
				do
				dhc_pat0=` head -n $dhc_num /tmp/ppp_resolv | tail -n 1`
				dhc_pat1=`echo $dhc_pat0 | cut -f2 -d " "`
				if [ $dhc_num = 1 ]; then
	      				echo nameserver $dhc_pat1 > $ETC_RESOLV_CONF
	      			else
	      				echo nameserver $dhc_pat1 >> $ETC_RESOLV_CONF
	      			fi
					dhc_num=`expr $dhc_num + 1`
				done
				    
			fi
			eval `flash get DNS1`
	    		if [ "$DNS1" != '0.0.0.0' ]; then
				echo nameserver $DNS1 >> $ETC_RESOLV_CONF  
			fi
		fi
	fi
fi

if [ $WAN_DHCP = 4 ]; then
 if [ -r /var/pptp_server ]; then
    	pptp_serverIP=` head -n 1 /var/pptp_server | tail -n 1`
    	if [ $PPTP_WAN_IP_DYNAMIC = 1 ]; then
    		route del -host $pptp_serverIP gw $PPTP_GATEWAY 2> /dev/null
    	else
    		if [ -r /var/eth1_gw ]; then
    			pptp_gateway=` head -n 1 /var/eth1_gw | tail -n 1`
    			route del -host $pptp_serverIP gw $pptp_gateway 2> /dev/null
    		fi
    	fi
    	if [ -n "$pptp_serverIP" ]; then
    		route del -host $pptp_serverIP gw $pptp_serverIP 2> /dev/null
    	fi
    fi
fi

if [ $WAN_DHCP = 4 ]; then
	if [ $1 = 'option' ] && [ $PPTP_CONNECTION_TYPE != 1 ]; then
		if [ $PPTP_WAN_IP_DYNAMIC = 1 ]; then
			eval `flash get DNS1`
		    	if [ "$DNS1" != '0.0.0.0' ]; then
				echo nameserver $DNS1 > $ETC_RESOLV_CONF  
			else
				echo "nameserver $PPTP_GATEWAY" > $ETC_RESOLV_CONF      
		    	fi
		else
	    		if [ -r "$DHC_RESOLV_CONF" ]; then
				dhc_line_res=0
				cat $DHC_RESOLV_CONF | grep nameserver > /tmp/ppp_resolv 
				dhc_line_res=`cat /tmp/ppp_resolv | wc -l`
				dhc_num=1
				while [ $dhc_num -le $dhc_line_res ];
				do
				dhc_pat0=` head -n $dhc_num /tmp/ppp_resolv | tail -n 1`
				dhc_pat1=`echo $dhc_pat0 | cut -f2 -d " "`
				if [ $dhc_num = 1 ]; then
	      				echo nameserver $dhc_pat1 > $ETC_RESOLV_CONF
	      			else
	      				echo nameserver $dhc_pat1 >> $ETC_RESOLV_CONF
	      			fi
					dhc_num=`expr $dhc_num + 1`
				done
				    
			fi
			eval `flash get DNS1`
	    		if [ "$DNS1" != '0.0.0.0' ]; then
				echo nameserver $DNS1 >> $ETC_RESOLV_CONF  
			fi
		fi
	fi
fi
if [ $WAN_DHCP = 8 ]; then
 if [ -r /var/pptp_server ]; then
    	pptp_serverIPru=` head -n 1 /var/pptp_server | tail -n 1`
    	if [ $PPTP_RU_WANPHY_IP_DYNAMIC = 1 ]; then
    		route del -host $pptp_serverIPru gw $PPTP_RU_WANPHY_GATEWAY 2> /dev/null
    	else
    		if [ -r /var/eth1_gw ]; then
    			pptp_gatewayru=` head -n 1 /var/eth1_gw | tail -n 1`
    			route del -host $pptp_serverIPru gw $pptp_gatewayru 2> /dev/null
    		fi
    	fi
    	if [ -n "$pptp_serverIPru" ]; then
    		route del -host $pptp_serverIPru gw $pptp_serverIPru 2> /dev/null
    	fi
    fi
fi
if [ -f $PLUTO_PID ];then
  ipsec setup stop
fi
 
if [ -r "$FIRSTDDNS" ]; then
  rm $FIRSTDDNS
fi
if [ $1 = 'option' ] && [ -r "$LINKFILE" ]; then
  rm -f /etc/ppp/first*
fi
if [ -r "$MCONNECTFILE" ]; then

		if [ $WAN_DHCP != 6 ]; then
		  rm -f $MCONNECTFILE
		fi
		if [ $WAN_DHCP = 6 ] && [ $1 = 'option' ] && [ -r "$LINKFILE" ]; then
		#exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:L2TP rm mconnectfile!!;note:XXXX--Disconnect L2TP line;"
		 rm -f $MCONNECTFILE
		fi

fi
if [ -r "$LINKFILE" ]; then
  rm -f $LINKFILE
fi
if [ -r "$DHCPPLUS_LINKFILE" ]; then
  rm -f $DHCPPLUS_LINKFILE
fi
if [ -r "$L2TP_GW" ]; then
  rm -f $L2TP_GW 2> /dev/null
fi
if [ -r "$L2TP_IPDYN" ]; then
  rm -f $L2TP_IPDYN 2> /dev/null
fi


#flush kernel fast-path table move to firewall.c 
#if [ $WAN_DHCP != 7 ] && [ $WAN_DHCP != 8 ]; then
#echo 2 > /proc/fast_nat
#fi

if [ $WAN_DHCP = 7 ] && [ $PPPOE_RU_CONNECT_TYPE != 2 ]; then
eval `flash get PPPOE_RU_WANPHY_IP_DYNAMIC`
	if [ $1 != 'all' ]; then
		if [ $1 = 'option' ]; then
		if [ ! -f $SetWanPhy_Check ]; then
				if [ $PPPOE_RU_WANPHY_IP_DYNAMIC = 1 ]; then
					eval `flash get DNS_MODE`
					if [ $DNS_MODE = 1 ]; then
		  				eval `flash get DNS1`
		  				if [ "$DNS1" != '0.0.0.0' ]; then
							echo nameserver $DNS1 > $ETC_RESOLV_CONF   
						fi
						eval `flash get DNS2`
						if [ "$DNS2" != '0.0.0.0' ]; then
							echo nameserver $DNS2 >> $ETC_RESOLV_CONF   
						fi	    
					else
						echo nameserver $PPPOE_RU_WANPHY_GATEWAY > $ETC_RESOLV_CONF    
	    				fi
		    		else
			    		if [ -r "$DHC_RESOLV_CONF" ]; then
						dhc_line_res=0
				    		cat $DHC_RESOLV_CONF | grep nameserver > /tmp/ppp_resolv 
				    		dhc_line_res=`cat /tmp/ppp_resolv | wc -l`
				    		dhc_num=1
				    		while [ $dhc_num -le $dhc_line_res ];
				    		do
				      		dhc_pat0=` head -n $dhc_num /tmp/ppp_resolv | tail -n 1`
				      		dhc_pat1=`echo $dhc_pat0 | cut -f2 -d " "`
						if [ $dhc_num = 1 ]; then
		      					echo nameserver $dhc_pat1 > $ETC_RESOLV_CONF
		      				else
		      					echo nameserver $dhc_pat1 >> $ETC_RESOLV_CONF
		      				fi
				      		dhc_num=`expr $dhc_num + 1`
				    		done
					fi
						eval `flash get DNS1`
			    			if [ "$DNS1" != '0.0.0.0' ]; then
							echo nameserver $DNS1 >> $ETC_RESOLV_CONF  
						fi
						eval `flash get DNS2`
			    			if [ "$DNS2" != '0.0.0.0' ]; then
							echo nameserver $DNS2 >> $ETC_RESOLV_CONF  
						fi
				fi
			fi
		fi
		if [ ! -f $SetWanPhy_Check ]; then
				#echo "Will RU-PPPOE restore wanphy setting"
				sleep 1
			setfirewall restore $WAN_DHCP $PPPOE_RU_WANPHY_IP_DYNAMIC
				#echo 'Set Static Route'
	  			$STOP_STATIC_ROUTE
	  			$START_STATIC_ROUTE eth1 ru
		fi
	fi
fi

if [ $WAN_DHCP = 8 ] && [ $PPTP_RU_CONNECTION_TYPE != 2 ]; then
	if [ $1 != 'all' ]; then
	if [ ! -f $SetWanPhy_Check ]; then
			#echo 'Set Static Route'
  			$STOP_STATIC_ROUTE
  			$START_STATIC_ROUTE eth1 ru
  	fi		
		if [ $1 = 'manual' ]; then
		if [ ! -f $SetWanPhy_Check ]; then
				#echo "Will restore wanphy setting PPTP"
				sleep 1
			setfirewall restore $WAN_DHCP $PPTP_RU_WANPHY_IP_DYNAMIC
		fi
	fi
		if [ $1 = 'option' ]; then
			if [ ! -f $SetWanPhy_Check ]; then
				if [ $PPTP_RU_WANPHY_IP_DYNAMIC = 1 ]; then
					eval `flash get DNS1`
	    				if [ "$DNS1" != '0.0.0.0' ]; then
						echo nameserver $DNS1 > $ETC_RESOLV_CONF  
					else
						echo "nameserver $PPTP_RU_WANPHY_GATEWAY" > $ETC_RESOLV_CONF      
	    				fi
	    			else
	    				if [ -r "$DHC_RESOLV_CONF" ]; then
						dhc_line_res=0
			    			cat $DHC_RESOLV_CONF | grep nameserver > /tmp/ppp_resolv 
			    			dhc_line_res=`cat /tmp/ppp_resolv | wc -l`
			    			dhc_num=1
			    			while [ $dhc_num -le $dhc_line_res ];
			    			do
			      			dhc_pat0=` head -n $dhc_num /tmp/ppp_resolv | tail -n 1`
			      			dhc_pat1=`echo $dhc_pat0 | cut -f2 -d " "`
				      		if [ $dhc_num = 1 ]; then
      							echo nameserver $dhc_pat1 > $ETC_RESOLV_CONF
      						else
      							echo nameserver $dhc_pat1 >> $ETC_RESOLV_CONF
      						fi
			      			dhc_num=`expr $dhc_num + 1`
			    			done
			    
					fi
					eval `flash get DNS1`
	    				if [ "$DNS1" != '0.0.0.0' ]; then
						echo nameserver $DNS1 >> $ETC_RESOLV_CONF  
					fi
				fi
			fi
		fi
	fi
fi
if [ $1 != 'all' ]; then
if [ $WAN_DHCP = 3 ] || [ $WAN_DHCP = 4 ] || [ $WAN_DHCP = 6 ]; then 
	if [ ! -f /var/set_refirewall ]; then
		#exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:WAN Hangup;note:Re-Set firewall rules;"
		setfirewall refirewall $WAN_DHCP
	fi
fi
fi
if [ $DISABLE_HOSTNAME = '0' ]; then
if [ $1 = 'option' ] || [ $1 = 'manual' ] || [ $1 = 'l2tp' ]; then   
 if [ $WAN_DHCP = 3 ]; then   
         if [ $PPP_CONNECT_TYPE = 1 ]; then   
                 killall pppoe.sh 2> /dev/null   
                 pppoe.sh all eth1   
         fi   
 fi   
 if [ $WAN_DHCP = 4 ]; then   
         if [ $PPTP_CONNECTION_TYPE = 1 ]; then   
                 killall pptp.sh 2> /dev/null   
                 pptp.sh eth1 &   
         fi   
 fi   
 if [ $WAN_DHCP = 6 ]; then   
         if [ $L2TP_CONNECTION_TYPE = 1 ]; then   
                 killall l2tp.sh 2> /dev/null   
                 l2tp.sh eth1 &   
         fi   
 fi   
 fi 
fi


if [ -r "$PPTP_GW" ]; then
  rm -f $PPTP_GW 2> /dev/null
fi
if [ -r "$PPTP_IPDYN" ]; then
  rm -f $PPTP_IPDYN 2> /dev/null
fi
 rm -f /var/pppdkilled 2> /dev/null
if [ $WAN_DHCP = 7 ]
	if [ -r /var/ck_oeru ]; then	
	CURR_OERU=`cat /var/ck_oeru`	
		if [ $CURR_OERU = 1 ]; then
			echo 0 > /var/ck_oeru
		fi
	fi
fi
#mark_test , in PPPOE mode do this in pppd , not here !!
if [ $WAN_DHCP != 3 -a $WAN_DHCP != 4 -a $WAN_DHCP != 6 ] || [ $1 != 'option' ]; then
if [ -r "$CONNECTFILE" ]; then
  rm -f $CONNECTFILE
fi
fi
rm -f /var/disc 2> /dev/null
rm -f /var/disc_l2tp 2> /dev/null

if [ $WAN_DHCP = 4 ] && [ $PPTP_CONNECTION_TYPE = 2 ]; then
echo "3" > /proc/pptp_conn_ck
else
echo "0" > /proc/pptp_conn_ck
fi


