#!/bin/sh
eval `flash get DNS_MODE`
eval `flash get WAN_DHCP`
eval `flash get PPP_MTU_SIZE`
#eval `flash get PPPOE_RU_MTU_SIZE`
#eval `flash get PPTP_RU_MTU_SIZE` 
eval `flash get PPTP_MTU_SIZE`
eval `flash get PPTP_CONNECTION_TYPE`
NTP_PROCESS=/var/ntp_run
RESOLV=/etc/ppp/resolv.conf
DHC_RESOLV_CONF="/etc/udhcpc/resolv.conf"
ETC_RESOLV_CONF=/var/resolv.conf
PIDFILE=/var/run/dnrd.pid
CONNECTFILE=/etc/ppp/connectfile
START_STATIC_ROUTE=/bin/st_route.sh
STOP_STATIC_ROUTE=/bin/st_route_del.sh
SetWanPhy_Check=/var/setwan_check
SetDns_Hostname_Check=/var/setdns_hostname_check
MAX_DNS=0
echo "pass" > $CONNECTFILE
rm -f  /var/wanip_fail 2> /dev/null
if [ $WAN_DHCP = 7 ] || [ $WAN_DHCP = 8 ];then
	route del default dev eth1 2> /dev/null
	rm -f $SetWanPhy_Check 2> /dev/null
fi
if [ $WAN_DHCP = 4 ] || [ $WAN_DHCP = 6 ];then
	route del default dev eth1 2> /dev/null
fi
if [ $WAN_DHCP = 4 ] && [ $PPTP_CONNECTION_TYPE = 2 ]; then
echo "5" > /proc/pptp_conn_ck
else
echo "0" > /proc/pptp_conn_ck
fi

if [ $WAN_DHCP = 4 ] || [ $WAN_DHCP = 8 ]; then
  ptpgw0=`ifconfig ppp0 | grep -i "P-t-P:"`
  ptpgw1=`echo $ptpgw0 | cut -f3 -d:`
  ptpgw=`echo $ptpgw1 | cut -f1 -d " "`
  route add -net default gw $ptpgw dev ppp0  
fi

if [ $WAN_DHCP != 7 ] && [ $WAN_DHCP != 8 ]; then
rm -f $ETC_RESOLV_CONF
rm -f $SetDns_Hostname_Check 2> /dev/null

if [ $WAN_DHCP = 3 ]; then
eval `flash get PPPOE_DNS_MODE`
DNS_MODE="$PPPOE_DNS_MODE"
fi
if [ $DNS_MODE != 1 ]; then
DNS="--cache=off"
  if [ -r "$RESOLV" ] ; then
    if [ -f $PIDFILE ]; then
      PID=`cat $PIDFILE`
      kill -9 $PID 
      rm -f $PIDFILE
    fi
    line=0
    cat $RESOLV | grep nameserver > /tmp/ddfile 
    line=`cat /tmp/ddfile | wc -l`
    num=1
    while [ $num -le $line ];
    do
      pat0=` head -n $num /tmp/ddfile | tail -n 1`
      pat1=`echo $pat0 | cut -f2 -d " "`
       		if [ $MAX_DNS -le 5 ]; then
      DNS="$DNS -s $pat1"
      			MAX_DNS=`expr $MAX_DNS + 1` 
      		fi
      		echo nameserver $pat1 >> $ETC_RESOLV_CONF
      num=`expr $num + 1`
    done
  	fi
else
	if [ $WAN_DHCP = 4 ] || [ $WAN_DHCP = 6 ]; then
		#retrieve dhcp dns server ip  
		if [ -r "$DHC_RESOLV_CONF" ]; then
		dhc_line_res=0
	    	cat $DHC_RESOLV_CONF | grep nameserver > /tmp/ppp_resolv 
	    	dhc_line_res=`cat /tmp/ppp_resolv | wc -l`
	    	dhc_num=1
	    	while [ $dhc_num -le $dhc_line_res ];
	    	do
	      	dhc_pat0=` head -n $dhc_num /tmp/ppp_resolv | tail -n 1`
	      	dhc_pat1=`echo $dhc_pat0 | cut -f2 -d " "`
	      	if [ $MAX_DNS -le 5 ]; then
		      	DNS="$DNS -s $dhc_pat1"
		      	MAX_DNS=`expr $MAX_DNS + 1` 
		fi
	      	echo nameserver $dhc_pat1 >> $ETC_RESOLV_CONF
	      	dhc_num=`expr $dhc_num + 1`
	    	done
		fi
	fi
    	eval `flash get DNS1`
	if [ "$DNS1" != '0.0.0.0' ]; then
		if [ $MAX_DNS -le 5 ]; then
			DNS="$DNS -s $DNS1"
			MAX_DNS=`expr $MAX_DNS + 1` 
		fi
		echo nameserver $DNS1 >> $ETC_RESOLV_CONF
	fi
	
		eval `flash get DNS2`
		if [ "$DNS2" != '0.0.0.0' ]; then
			if [ $MAX_DNS -le 5 ]; then
				DNS="$DNS -s $DNS2"
				MAX_DNS=`expr $MAX_DNS + 1` 
			fi
			echo nameserver $DNS2 >> $ETC_RESOLV_CONF
		fi
	
	rm -f /tmp/ppp_resolv 2> /dev/null
	rm -f /tmp/ddfile  2> /dev/null
  	
fi
	#dnrd $DNS
	#setfirewall dns_resort
	eval `flash get DNSRELAY_ENABLED`
	if [ $DNSRELAY_ENABLED = 1 ]; then
		dnrd $DNS
		#inform DHCPD for WINS setting
		PIDFILE_DHCPD=/var/run/udhcpd.pid
		if [ -f $PIDFILE_DHCPD ]; then
		PID_DHCPD=`cat $PIDFILE_DHCPD`
		if [ $PID_DHCPD != 0 ]; then
			eval `flash get NETBIOS_ANNOUNCE`
			eval `flash get NETBIOS_SOURCE`
			if [ $NETBIOS_ANNOUNCE = 1 -a $NETBIOS_SOURCE = 1 ] ; then
				echo "update_conf_isp" > /tmp/dhcpd_action
			fi
			sleep 1
			kill -17 $PID_DHCPD 2> /dev/null
		fi
		fi
	else
	#inform DHCPD for DNS and WINS setting
	PIDFILE_DHCPD=/var/run/udhcpd.pid
	if [ -f $PIDFILE_DHCPD ]; then
	PID_DHCPD=`cat $PIDFILE_DHCPD`
	if [ $PID_DHCPD != 0 ]; then
		eval `flash get NETBIOS_ANNOUNCE`
		eval `flash get NETBIOS_SOURCE`
		if [ $NETBIOS_ANNOUNCE = 1 -a $NETBIOS_SOURCE = 1 ] ; then
			echo "update_conf_isp" > /tmp/dhcpd_action
		else
			echo "update_conf_dns" > /tmp/dhcpd_action
		fi
	sleep 1
	kill -17 $PID_DHCPD 2> /dev/null
	fi
	fi
	fi
fi

if [ $WAN_DHCP = 7 ]; then
#if [ $DNS_MODE != 1 ]; then
DNS="--cache=off"
if [ -r /var/ck_oeru ]; then	
	CURR_OERU=`cat /var/ck_oeru`	
	if [ $CURR_OERU != 1 ]; then
	#echo "PPPoE Connect up===>$CURR_OERU"
		echo 2 > /var/ck_oeru
		rm -f $ETC_RESOLV_CONF
		#retrieve ppp dns server ip
		if [ -r "$RESOLV" ]; then
		    ppp_line=0
		    cat $RESOLV | grep nameserver > /tmp/ddfile 
		    ppp_line=`cat /tmp/ddfile | wc -l`
		    ppp_num=1
		    while [ $ppp_num -le $ppp_line ];
    do
		      ppp_pat0=` head -n $ppp_num /tmp/ddfile | tail -n 1`
		      ppp_pat1=`echo $ppp_pat0 | cut -f2 -d " "`
		      if [ $MAX_DNS -le 5 ]; then
		      		DNS="$DNS -s $ppp_pat1"
		      		MAX_DNS=`expr $MAX_DNS + 1` 
		      fi
		      if [ $ppp_num = 1 ]; then
		      	echo nameserver $ppp_pat1 > $ETC_RESOLV_CONF
      else
		      	echo nameserver $ppp_pat1 >> $ETC_RESOLV_CONF
		      	fi
		      ppp_num=`expr $ppp_num + 1`
		    done
		  fi
        sleep 1
		#retrieve dhcp dns server ip  
		eval `flash get PPPOE_RU_WANPHY_IP_DYNAMIC`
		if [ $PPPOE_RU_WANPHY_IP_DYNAMIC = 0 ]; then
			if [ -r "$DHC_RESOLV_CONF" ]; then
			dhc_line_res=0
			    cat $DHC_RESOLV_CONF | grep nameserver > /tmp/ppp_resolv 
			    dhc_line_res=`cat /tmp/ppp_resolv | wc -l`
			    dhc_num=1
			    while [ $dhc_num -le $dhc_line_res ];
			    do
			      dhc_pat0=` head -n $dhc_num /tmp/ppp_resolv | tail -n 1`
			      dhc_pat1=`echo $dhc_pat0 | cut -f2 -d " "`
			      if [ $MAX_DNS -le 5 ]; then
			      	DNS="$DNS -s $dhc_pat1"
			      	MAX_DNS=`expr $MAX_DNS + 1` 
      fi
			      echo nameserver $dhc_pat1 >> $ETC_RESOLV_CONF
			      dhc_num=`expr $dhc_num + 1`
    done
    
  fi
    	fi
		#else
			#DNS="--cache=off"
		#retrieve static dns server ip	
    	eval `flash get DNS1`
	if [ "$DNS1" != '0.0.0.0' ]; then
				if [ $MAX_DNS -le 5 ]; then
		DNS="$DNS -s $DNS1"
					MAX_DNS=`expr $MAX_DNS + 1` 
				fi
				echo nameserver $DNS1 >> $ETC_RESOLV_CONF
	fi
			if [ $WAN_DHCP = 7 ]; then
	eval `flash get DNS2`
	if [ "$DNS2" != '0.0.0.0' ]; then
					if [ $MAX_DNS -le 5 ]; then
		DNS="$DNS -s $DNS2"
						MAX_DNS=`expr $MAX_DNS + 1` 
	fi
					echo nameserver $DNS2 >> $ETC_RESOLV_CONF
	fi  
fi
				
			#fi
			
			rm -f /tmp/ppp_resolv 2> /dev/null
			rm -f /tmp/ddfile  2> /dev/null
			if [ -f $PIDFILE ]; then
		     	 	PID=`cat $PIDFILE`
		      		kill -9 $PID 
		      		rm -f $PIDFILE
fi

			#echo "$DNS"
			#dnrd $DNS
			setfirewall dns_resort
		fi
	fi
fi
if [ $WAN_DHCP = 8 ]; then
#if [ $DNS_MODE != 1 ]; then
DNS="--cache=off"
rm -f $ETC_RESOLV_CONF
#retrieve ppp dns server ip
if [ -r "$RESOLV" ]; then
    ppp_line=0
    cat $RESOLV | grep nameserver > /tmp/ddfile 
    ppp_line=`cat /tmp/ddfile | wc -l`
    ppp_num=1
    while [ $ppp_num -le $ppp_line ];
    do
      ppp_pat0=` head -n $ppp_num /tmp/ddfile | tail -n 1`
      ppp_pat1=`echo $ppp_pat0 | cut -f2 -d " "`
      if [ $MAX_DNS -le 5 ]; then
      		DNS="$DNS -s $ppp_pat1"
      		MAX_DNS=`expr $MAX_DNS + 1` 
      fi
      if [ $ppp_num = 1 ]; then
      	echo nameserver $ppp_pat1 > $ETC_RESOLV_CONF
      	else
      	echo nameserver $ppp_pat1 >> $ETC_RESOLV_CONF
      	fi
      ppp_num=`expr $ppp_num + 1`
    done
  fi
#retrieve dhcp dns server ip  
if [ -r "$DHC_RESOLV_CONF" ]; then
dhc_line_res=0
    cat $DHC_RESOLV_CONF | grep nameserver > /tmp/ppp_resolv 
    dhc_line_res=`cat /tmp/ppp_resolv | wc -l`
    dhc_num=1
    while [ $dhc_num -le $dhc_line_res ];
    do
      dhc_pat0=` head -n $dhc_num /tmp/ppp_resolv | tail -n 1`
      dhc_pat1=`echo $dhc_pat0 | cut -f2 -d " "`
      if [ $MAX_DNS -le 5 ]; then
      DNS="$DNS -s $dhc_pat1"
      	MAX_DNS=`expr $MAX_DNS + 1` 
      	fi
      echo nameserver $dhc_pat1 >> $ETC_RESOLV_CONF
      dhc_num=`expr $dhc_num + 1`
    done
    
fi
#else
	#DNS="--cache=off"
#retrieve static dns server ip	
    	eval `flash get DNS1`
	if [ "$DNS1" != '0.0.0.0' ]; then
		if [ $MAX_DNS -le 5 ]; then
		DNS="$DNS -s $DNS1"
			MAX_DNS=`expr $MAX_DNS + 1` 
		fi
		echo nameserver $DNS1 >> $ETC_RESOLV_CONF
	fi
	if [ $WAN_DHCP = 7 ]; then
	eval `flash get DNS2`
	if [ "$DNS2" != '0.0.0.0' ]; then
			if [ $MAX_DNS -le 5 ]; then
		DNS="$DNS -s $DNS2"
				MAX_DNS=`expr $MAX_DNS + 1` 
			fi
		echo nameserver $DNS2 >> $ETC_RESOLV_CONF
	fi
	fi
		
	#fi
	
	rm -f /tmp/ppp_resolv 2> /dev/null
	rm -f /tmp/ddfile  2> /dev/null
	if [ -f $PIDFILE ]; then
     	 	PID=`cat $PIDFILE`
      		kill -9 $PID 
      		rm -f $PIDFILE
    	fi

	#echo "$DNS"
	#dnrd $DNS
	setfirewall dns_resort
fi





if [ $WAN_DHCP = 4 ]; then
  eval `flash get PPTP_MTU_SIZE`
  #MTU=`expr $PPTP_MTU_SIZE - 8`
  ifconfig ppp0 mtu $PPTP_MTU_SIZE txqueuelen 25
elif [ $WAN_DHCP = 8 ]; then
  eval `flash get PPTP_RU_MTU_SIZE` 
  #MTU=`expr $PPTP_RU_MTU_SIZE - 8`
  ifconfig ppp0 mtu $PPTP_RU_MTU_SIZE txqueuelen 25  
elif [ $WAN_DHCP = 6 ]; then
  eval `flash get L2TP_MTU_SIZE`
  #MTU=`expr $L2TP_MTU_SIZE - 8`
  ifconfig ppp0 mtu $L2TP_MTU_SIZE txqueuelen 25
elif [ $WAN_DHCP = 7 ]; then
  eval `flash get PPPOE_RU_MTU_SIZE`
  #MTU=`expr $PPPOE_RU_MTU_SIZE - 8`
  ifconfig ppp0 mtu $PPPOE_RU_MTU_SIZE txqueuelen 25
elif [ $WAN_DHCP = 3 ]; then
  eval `flash get PPP_MTU_SIZE`
  #MTU=`expr $PPP_MTU_SIZE - 8`
  ifconfig ppp0 mtu $PPP_MTU_SIZE txqueuelen 25
fi
#upnp.sh
if [ -f /bin/vpn.sh ]; then
      echo 'Setup VPN'
      vpn.sh all
fi
if [ $WAN_DHCP = 4 ] || [ $WAN_DHCP = 8 ]; then
 exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:PPTP line connected;"
fi
if [ $WAN_DHCP = 6 ]; then
 exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:L2TP line connected;"
fi

#echo "Re-Start DDNS"
ddns.sh option

#echo 'Set Static Route'
$STOP_STATIC_ROUTE
$START_STATIC_ROUTE ppp0
#eval `flash get NAT_ENABLED`
#eval `flash get RIP_ENABLED`
#if [ "$NAT_ENABLED" = '0' ]; then
#if [ "$RIP_ENABLED" = '1' ]; then
#	dyn_route.sh
#fi
#fi
#restart igmpproxy
# not include igmpsnoop in TR	
eval `flash get IGMP_PROXY_DISABLED`
killall -9 igmpproxy 2> /dev/null
if [ $IGMP_PROXY_DISABLED = 0 ]; then
	if [ $WAN_DHCP = 7 ] || [ $WAN_DHCP = 8 ]; then
		igmpproxy eth1 br0 &
	else
	igmpproxy ppp0 br0 &
	fi
	#br_igmpsnoop need not depend on br_igmpproxy ; plus mark 2009-0218 
	#echo 1 > /proc/br_igmpsnoop
	#else
	#echo 0 > /proc/br_igmpsnoop
fi	


eval `flash get NTP_ENABLED`
if [ $NTP_ENABLED = 1 ]; then
if [ ! -f $NTP_PROCESS ]; then
  ntp.sh &
fi
fi

