#!/bin/sh
#
# script file to start network
#
# Usage: init.sh {gw | ap} {all | bridge | wan}{618 | 615}
#

if [ $# -lt 3 ]; then echo "Usage: $0 {gw | ap} {all | bridge | wan}{618 | 615 | 615sky | euro}"; exit 1 ; fi

if [ -f "/proc/nat_l2tp" ]; then
	echo 0 > /proc/nat_l2tp;
fi

TOOL=flash
GETMIB="$TOOL get"
LOADDEF="$TOOL default"
LOADDEFSW="$TOOL default-sw"
LOADDS="$TOOL reset"
SET_IP=fixedip.sh
START_DHCP_SERVER=dhcpd.sh
START_DHCP_CLIENT=dhcpc.sh
START_DHCPPLUS_CLIENT=dhcpplus.sh
START_BRIDGE=bridge.sh
START_WLAN=wlan.sh
START_PPPOE=pppoe.sh
START_PPPOE_RU=pppoe_ru.sh
START_FIREWALL=firewall.sh
START_WLAN_APP=wlanapp.sh
START_PPTP=pptp.sh
START_PPTP_RU=pptp_ru.sh
START_L2TP=l2tp.sh
START_NTP=ntp.sh
START_DDNS=ddns.sh
START_IP_QOS=ip_qos.sh

START_STATIC_ROUTE=/bin/st_route.sh
STOP_STATIC_ROUTE=/bin/st_route_del.sh
DOMAIN_FILTER=domain_filter.sh
URL_FILTER=url_filter.sh
WLAN_PREFIX=wlan
BR_LAN5_INTERFACE=eth5
PLUTO_PID=/var/run/pluto.pid
WLAN_INTERFACE=wlan0
VIRTUAL_NUM=0
VIRTUAL_NUM_INTERFACE=0
NUM_INTERFACE=1
RESOLV_CONF="/etc/resolv.conf"
DNRDPIDFILE=/var/run/dnrd.pid
WEBPIDFILE=/var/run/webs.pid
SET_TIME=/var/set_time
NTP_PROCESS=/var/ntp_run
# Query number of wlan interface
NUM=0

echo "Start service ->: [$2]"
VIRTUAL_WLAN_PREFIX="$WLAN_PREFIX$NUM-va"
V_DATA=`ifconfig -a | grep $VIRTUAL_WLAN_PREFIX`
V_LINE=`echo $V_DATA | grep $VIRTUAL_WLAN_PREFIX$VIRTUAL_NUM`
V_NAME=`echo $V_LINE | cut -b -9`
eval `$GETMIB WAN_DHCP`
if [ $2 = 'all' ]; then
#mount web-lang for cmd: flash get-LangCode
mount -t squashfs /dev/mtdblock2 /web-lang
mount -t squashfs /dev/mtdblock3 /mydlink
fi
while [ -n "$V_NAME" ] 
do
	VIRTUAL_WLAN_INTERFACE="$VIRTUAL_WLAN_INTERFACE $VIRTUAL_WLAN_PREFIX$VIRTUAL_NUM"
	VIRTUAL_NUM=`expr $VIRTUAL_NUM + 1`
	V_LINE=`echo $V_DATA | grep $VIRTUAL_WLAN_PREFIX$VIRTUAL_NUM`
	V_NAME=`echo $V_LINE | cut -b -9`
done

flash pocketAP_bootup
echo 'init start config check'
	
if [ $2 = 'all' ]; then	
# See if flash data is valid
$TOOL test-hwconf
if [ $? != 0 ]; then
	echo 'HW configuration invalid, reset default!'
	$LOADDEF
fi

eval `$GETMIB WSC_CONFIGURED`

# do not edit next line
CONFIG_NET_QOS=y

$TOOL test-dsconf
if [ $? != 0 ]; then
	echo 'Default configuration invalid, reset default!'
	$LOADDEFSW
fi

$TOOL test-csconf
if [ $? != 0 ]; then
	echo 'Current configuration invalid, reset to default configuration!'
	$LOADDS
fi
if [ ! -r "$SET_TIME" ]; then
	flash settime
fi

fi

echo 'init get mode'

eval `$GETMIB OP_MODE`
eval `$GETMIB WISP_WAN_ID`
eval `$GETMIB IGMP_PROXY_DISABLED`
eval `$GETMIB VPN_PASSTHRU_IPV6`
if [ $1 = 'ap' ]; then
### bridge (eth0+wlan0) confiuration #########
	GATEWAY='false'
	BR_INTERFACE=br0
	BR_LAN1_INTERFACE=eth0	
	VLAN_INTERFACE='eth2 eth3 eth4'	
	if [ "$OP_MODE" = '1' ];then
		BR_LAN2_INTERFACE=eth1
	fi	
##############################################
fi

# do not edit next line
echo 0 > /proc/wan_port

if [ $1 = 'gw' ]; then
### gateway (eth0+eth1+wlan0) configuration ##
	GATEWAY='true'
	if [ "$OP_MODE" = '2' ];then
		WAN_INTERFACE=wlan$WISP_WAN_ID
	else
		WAN_INTERFACE=eth1
	fi
	BR_INTERFACE=br0	
	BR_LAN1_INTERFACE=eth0
	VLAN_INTERFACE='eth2 eth3 eth4'		
	if [ "$OP_MODE" = '1' ] || [ "$OP_MODE" = '2' ]; then
		BR_LAN2_INTERFACE=eth1	
	fi
	if [ "$OP_MODE" = '1' ]; then
		GATEWAY='false'
	fi	
	echo "4" > /proc/wan_port	
##############################################
fi
if [ $2 = 'all' ]; then
	ENABLE_WAN=1
	ENABLE_BR=1
	ENABLE_WAN_BR=1
elif [ $2 = 'wan' ]; then
	ENABLE_WAN=1
	ENABLE_BR=0
	ENABLE_WAN_BR=0
elif [ $2 = 'bridge' ]; then
	# if WISP mode , restart wan  for pppoe  ,pptp
	if [ "$OP_MODE" = '2' ]; then 
		ENABLE_WAN=1
	else
		ENABLE_WAN=0
	fi
	ENABLE_BR=1
	ENABLE_WAN_BR=0
elif [ $2 = 'wlan_app' ]; then
	$START_WLAN_APP start $WLAN_INTERFACE $BR_INTERFACE
	exit 0	
else
	echo "Usage: $0 {all | bridge | wan}"; exit 1
fi

# Execute log script
echo 'exec log script'
log_util.sh

#system reinit, clear log files
echo 'system reinit'
if [ $ENABLE_BR = 1 ]; then
rm /tmp/wscd_status 2> /dev/null
rm /tmp/wscd_countdown 2> /dev/null
fi
if [ $ENABLE_WAN = 1 ]; then
rm -f  /var/wanip_fail 2> /dev/null
rm -f /var/isp_dhcp.conf 2> /dev/null
rm /tmp/auto_smtp_mail 2> /dev/null
rm /tmp/smtp_mail 2> /dev/null
fi
if [ $ENABLE_WAN_BR = 1 ]; then
rm -f /var/ntp_run 2> /dev/null
rm /tmp/log_web 2> /dev/null
fi
echo "$OP_MODE" > /var/sys_op
RESOLV=/var/resolv.conf
if [ -f $RESOLV ] && [ $ENABLE_WAN = 1 ] ; then
       	rm -f $RESOLV
fi
# start log daemon
killall netfilter_log  2> /dev/null
eval `$GETMIB SCRLOG_ENABLED`
if [ "$SCRLOG_ENABLED" != 0 ]; then
	netfilter_log&
fi

# start log dnsquery
eval `$GETMIB MYDLINK_DNSQUERY`
if [ "$MYDLINK_DNSQUERY" != 0 ]; then
	echo 0 > /etc/dnrd/event
else
	rm -f /etc/dnrd/event 2> /dev/null
fi

# start log opt
eval `$GETMIB MYDLINK_LOG_ENABLE`
eval `$GETMIB MYDLINK_LOG_USER_INFO`
eval `$GETMIB MYDLINK_LOG_FWUP`
eval `$GETMIB MYDLINK_WIRELESS_WARM`
if [ "$MYDLINK_LOG_ENABLE" != 0 ]; then
if [ "$MYDLINK_LOG_USER_INFO" != 0 ]; then
	echo > /var/tmp/log_user
else
	rm -f /var/tmp/log_user 2> /dev/null
fi
if [ "$MYDLINK_LOG_FWUP" != 0 ]; then
	echo > /var/tmp/log_fwup
else
	rm -f /var/tmp/log_fwup 2> /dev/null
fi
if [ "$MYDLINK_WIRELESS_WARM" != 0 ]; then
	echo > /var/tmp/log_wire
else
	rm -f /var/tmp/log_wire 2> /dev/null
fi	
fi

# start trigger event
eval `$GETMIB MYDLINK_TRIGGEDEVENT_HISTORY`
if [ "$MYDLINK_TRIGGEDEVENT_HISTORY" != 0 ]; then
	echo > /var/tmp/trig_event
else
	rm -f /var/tmp/trig_event 2> /dev/null
fi


if [ $ENABLE_WAN_BR = 1 ]; then
# Generate WPS PIN number
	eval `$GETMIB HW_WSC_PIN`
	if [ "$HW_WSC_PIN" = "" ]; then
		$TOOL gen-pin
	fi
fi

# Copy WPS PIN from hw to ds/cs when empty
#eval `$GETMIB WSC_PIN`
#if [ "$WSC_PIN" = "" ]; then
#	eval `$GETMIB HW_WSC_PIN`
#	if [ "$HW_WSC_PIN" != "" ]; then
#	$TOOL set DEF_WSC_PIN $HW_WSC_PIN
#	$TOOL set WSC_PIN $HW_WSC_PIN	
#fi
#fi

if [ $ENABLE_BR = 1 ]; then
# Set Ethernet 0 MAC address
eval `$GETMIB ELAN_MAC_ADDR`
if [ "$ELAN_MAC_ADDR" = "000000000000" ]; then
	eval `$GETMIB HW_NIC0_ADDR`
	ELAN_MAC_ADDR=$HW_NIC0_ADDR
	fi
	ifconfig $BR_LAN1_INTERFACE hw ether $ELAN_MAC_ADDR
fi

if [ $ENABLE_WAN_BR = 1 ]; then
# Set Ethernet 1 MAC Address for bridge mode and WISP
eval `$GETMIB ELAN_MAC_ADDR`
if [ "$OP_MODE" = '1' ]  || [ "$OP_MODE" = '2' ]; then
	if [ "$ELAN_MAC_ADDR" = "000000000000" ]; then
		eval `$GETMIB HW_NIC1_ADDR`
		ELAN_MAC_ADDR=$HW_NIC1_ADDR
		fi
		ifconfig $BR_LAN2_INTERFACE hw ether $ELAN_MAC_ADDR
	fi
fi

# Set WAN MAC address
#if [ "$OP_MODE" = '0' ]; then
#	eval `$GETMIB WAN_MAC_ADDR`
#	if [ "$WAN_MAC_ADDR" = "000000000000" ]; then
#		eval `$GETMIB HW_NIC1_ADDR`
#		flash set WAN_MAC_ADDR $HW_NIC1_ADDR	
#		WAN_MAC_ADDR=$HW_NIC1_ADDR	
#	fi
#	ifconfig $WAN_INTERFACE hw ether $WAN_MAC_ADDR
#fi

# Disable DELAY_RX in Ethernet driver when do WIFI test
#eval `$GETMIB WIFI_SPECIFIC`
#if [  "$WIFI_SPECIFIC" != 0 ]; then
#	echo 1 > /proc/eth_flag
#else
#	echo 512 > /proc/rx_pkt_thres
#fi	

if [ $ENABLE_WAN = 1 ] || [ $ENABLE_WAN_BR = 1 ]; then	
#don't setup WAN in bridge mode
if [ "$GATEWAY" = 'true' ] && [ "$OP_MODE" != '1' ] ; then 
	eval `$GETMIB WAN_MAC_ADDR`
		if [ "$WAN_MAC_ADDR" = "000000000000" ]; then
			if [ "$OP_MODE" = '2' ]; then  #wireless ISP, use the WLAN mac address
				eval `$GETMIB wlan$WISP_WAN_ID HW_WLAN_ADDR`
				WAN_MAC_ADDR=$HW_WLAN_ADDR		
			else
				eval `$GETMIB HW_NIC1_ADDR`
				WAN_MAC_ADDR=$HW_NIC1_ADDR
			fi
		fi
		ifconfig $WAN_INTERFACE hw ether $WAN_MAC_ADDR
	fi
fi

if [ $ENABLE_WAN = 1 -a "$GATEWAY" = 'true' ]; then  
#disconnect all wan  for vpn and wisp
	# stop vpn if enabled
	if [ -f $PLUTO_PID ];then
		ipsec setup stop
	fi	
	killall -9 pptp.sh 2> /dev/null
	killall -9 pppoe.sh 2> /dev/null
	killall -9 l2tp.sh 2> /dev/null
	rm -f /etc/ppp/first*
	disconnect.sh all	
	killall sleep 2> /dev/null	
fi

if [ $ENABLE_BR = 1 ]; then
# Start WLAN interface
NUM=0
while [ $NUM -lt $NUM_INTERFACE -a $ENABLE_BR = 1  ]
do
	echo 'Initialize '$WLAN_PREFIX$NUM' interface'
	$TOOL set_mib $WLAN_PREFIX$NUM
	if [ $? != 0 ] ; then
		echo 'Using wlan script...'
		$START_WLAN $WLAN_PREFIX$NUM
	fi
	
	# Start VIRTUAL WLAN interface
	VIRTUAL_NUM_INTERFACE=1
	VIRTUAL_NUM=0
	while [ $VIRTUAL_NUM -lt $VIRTUAL_NUM_INTERFACE -a $ENABLE_BR = 1  ]
	do
		echo 'Initialize '$WLAN_PREFIX$NUM-va$VIRTUAL_NUM' interface'
		$TOOL set_mib $WLAN_PREFIX$NUM-va$VIRTUAL_NUM
		if [ $? != 0 ] ; then
			echo 'Using wlan script...'
			iwpriv $WLAN_PREFIX$NUM-va$VIRTUAL_NUM copy_mib			
			$START_WLAN $WLAN_PREFIX$NUM-va$VIRTUAL_NUM
		fi
		VIRTUAL_NUM=`expr $VIRTUAL_NUM + 1`
	done
	
	NUM=`expr $NUM + 1`
done		

V_WLAN_APP_ENABLE=1
eval `$GETMIB wlan0 MODE`
if  [ "$MODE" != 0 ] && [ "$MODE" != 3 ]; then
	V_WLAN_APP_ENABLE=0
	fi
fi

# add for check hw igmp snoop table reset

#ifconfig eth1 down

if [ "$GATEWAY" = 'true' ]; then
	if [ $ENABLE_BR = 1 ]; then
		echo 'Setup BRIDGE interface'
		ifconfig eth0 down		
		PIDFILE=/etc/udhcpc/udhcpc-$BR_INTERFACE.pid
		if [ -f $PIDFILE ] ; then
			PID=`cat $PIDFILE`
			if [ $PID != 0 ]; then
				kill -9 $PID 2>/dev/null
			fi
			rm -f $PIDFILE
		fi
		
		#Initialize bridge interface
		#$START_BRIDGE $BR_INTERFACE $BR_LAN1_INTERFACE $VLAN_INTERFACE $WLAN_INTERFACE $BR_LAN2_INTERFACE $VIRTUAL_WLAN_INTERFACE
		# add ipv6
                if [ "$VPN_PASSTHRU_IPV6" = '1' ] ; then
                        $START_BRIDGE $BR_INTERFACE $BR_LAN1_INTERFACE $VLAN_INTERFACE $WLAN_INTERFACE $BR_LAN2_INTERFACE $BR_LAN5_INTERFACE $VIRTUAL_WLAN_INTERFACE
                else
                        $START_BRIDGE $BR_INTERFACE $BR_LAN1_INTERFACE $VLAN_INTERFACE $WLAN_INTERFACE $BR_LAN2_INTERFACE $VIRTUAL_WLAN_INTERFACE
                fi

		
		# Set fixed IP or start DHCP server
		PIDFILE=/var/run/udhcpd.pid
		if [ -f $PIDFILE ] ; then
			PID=`cat $PIDFILE`
			if [ $PID != 0 ]; then
				kill -16 $PID
				sleep 1
				kill -9 $PID 2>/dev/null
	        	fi
        		rm -f $PIDFILE
		fi
		
		eval `$GETMIB DHCP`
		eval `$GETMIB IP_ADDR`
		echo "$IP_ADDR" > /tmp/routerip
		if [ "$DHCP" = '0' ]; then
			eval `$GETMIB SUBNET_MASK`
			eval `$GETMIB DEFAULT_GATEWAY`			
			$SET_IP $BR_INTERFACE $IP_ADDR $SUBNET_MASK $DEFAULT_GATEWAY
#			sleep 4
			$START_WLAN_APP start $WLAN_INTERFACE $BR_INTERFACE		

		elif [ "$DHCP" = '2' ] || [ "$DHCP" = '10' ]; then		
			# caculate wait time
			NUM=0
			WAIT_TIME=0
			while [ $NUM -lt $NUM_INTERFACE  ]
			do				
#				eval `$GETMIB $WLAN_PREFIX$NUM WDS_ENABLED`				
				WDS_ENABLED=0
				if [ "$WDS_ENABLED" != 0 ]; then
					WAIT_TIME=`expr $WAIT_TIME + 5`
				else				
					WAIT_TIME=`expr $WAIT_TIME + 1`
				fi				
				NUM=`expr $NUM + 1`
			done		
			sleep $WAIT_TIME
			
			$START_DHCP_SERVER $BR_INTERFACE gw
#			sleep 4
			if [ "$V_WLAN_APP_ENABLE" = '1' ]; then
				$START_WLAN_APP start $WLAN_INTERFACE $VIRTUAL_WLAN_INTERFACE $BR_INTERFACE
			else
				$START_WLAN_APP start $WLAN_INTERFACE $BR_INTERFACE
			fi
		fi
		eval `$GETMIB HOST_NAME`
		if [ "$HOST_NAME" != ""  ]; then	
				flash get HOST_NAME > /var/hostname
			##eval `$GETMIB IP_ADDR`
			##echo $IP_ADDR'\\'$HOST_NAME > /etc/hosts
		fi		
	fi
	
	if [ $ENABLE_WAN_BR = 1 ]; then
##	$DOMAIN_FILTER
		$URL_FILTER	
	fi
	
	
#start dnrd for check dns query with hostname
##	eval `$GETMIB IP_ADDR`
##	eval `$GETMIB LAN_NETBIOS_NAME`
##	eval `$GETMIB DOMAIN_NAME`	
	
	#echo "127.0.0.1 localhost.localdomain localhost" > /etc/hosts
##	if [ -z "$DOMAIN_NAME" ]; then 
##		if [ -n "$LAN_NETBIOS_NAME" ]; then 
##                  echo $IP_ADDR'\\'$LAN_NETBIOS_NAME >> /etc/hosts #In order to accept empty character within hostname. Keith                  
##             fi
##	else
##                  echo $IP_ADDR'\\'$LAN_NETBIOS_NAME'\\'$LAN_NETBIOS_NAME.$DOMAIN_NAME'\\' >> /etc/hosts #In order to accept empty character within hostname. Keith
##	fi	
##	dnrd --cache=off
#write the domain filter and url filter config file for dnrd before start wan interface
	if [ $ENABLE_WAN = 1 ]; then		
		if [ "$OP_MODE" != '1' ];then
			echo 'Setup WAN interface'
		fi		

		RESOLV=/etc/ppp/resolv.conf
		if [ -f $RESOLV ] ; then
        	rm -f $RESOLV
		fi

		RESOLV=/var/resolv.conf
		if [ -f $RESOLV ] ; then
        	rm -f $RESOLV
		fi

		# Initialize WAN interface
		# Clear/init bpalogin status first
#		echo "0" > /var/bpalogin
		# Delete DHCP client process
		DHCPC_WAN="$WLAN_INTERFACE eth1"
		for INTF in $DHCPC_WAN ; do
			PIDFILE=/etc/udhcpc/udhcpc-$INTF.pid
			if [ -f $PIDFILE ] ; then
				PID=`cat $PIDFILE`
				if [ $PID != 0 ]; then
					kill -9 $PID 2>/dev/null
				fi
				rm -f $PIDFILE
			fi
		done
		
#		killall -9 bpalogin 2> /dev/null
		rm -f /var/eth1_gw 2> /dev/null
		rm -f /var/pptp_server 2> /dev/null
		rm -f /var/l2tp_server 2> /dev/null
		rm -f /var/check_wan 2> /dev/null
		rm -f /var/ck_oeru 2> /dev/null
		rm -f /var/set_refirewall 2> /dev/null
		rm -f  /var/eth1_ip 2> /dev/null
		echo "0 0" > /proc/pptp_src_ip
		#eval `$GETMIB RIP_ENABLED`
		eval `$GETMIB NAT_ENABLED`
		setfirewall refirewall $WAN_DHCP
		if [ "$OP_MODE" != '1' ];then  # not bridge mode

################################################################		
# When WISP mode and WPA/WPA2 enabled, set keep_rsnie mib before 
# reinit wlan interface
			if [ "$OP_MODE" = '2' ];then		
				eval `$GETMIB ENCRYPT`
				if [ "$ENCRYPT" != "0" ]; then
					iwpriv $WAN_INTERFACE set_mib keep_rsnie=1
				fi
			fi
##################################################### 12-18-2006

			ifconfig $WAN_INTERFACE down
			ifconfig eth0 down
			ifconfig $WAN_INTERFACE up
			ifconfig eth0 up
						
			# Enable Realtek nat-shortcut when DHCP and fixed ip
			if [ $WAN_DHCP = 0 ] || [ $WAN_DHCP = 1 ]; then			
				echo "5" > /proc/fast_nat			
			else
				echo "4" > /proc/fast_nat
			fi
			
			# Enable Realtek fast-pptp		
			if [ $WAN_DHCP = 4 ] || [ $WAN_DHCP = 8 ]; then
				echo "1" > /proc/fast_pptp
				eval `$GETMIB PPTP_CONNECTION_TYPE`
				if [ $WAN_DHCP = 4 ] && [ $PPTP_CONNECTION_TYPE = 2 ]; then
					echo "3" > /proc/pptp_conn_ck
				else
					echo "0" > /proc/pptp_conn_ck
				fi
			else
				echo "0" > /proc/fast_pptp
			fi						
			
			# Enable Realtek fast-l2tp
			if [ $WAN_DHCP = 6 ]; then
				echo "1" > /proc/fast_l2tp
			else
				echo "0" > /proc/fast_l2tp
			fi				
						
			if [ "$WAN_DHCP" = '0' ]; then
				eval `$GETMIB WAN_IP_ADDR`
				eval `$GETMIB WAN_SUBNET_MASK`
				eval `$GETMIB WAN_DEFAULT_GATEWAY`
				eval `$GETMIB FIXED_IP_MTU_SIZE`				
				$SET_IP $WAN_INTERFACE $WAN_IP_ADDR $WAN_SUBNET_MASK $WAN_DEFAULT_GATEWAY
				ifconfig $WAN_INTERFACE mtu $FIXED_IP_MTU_SIZE					

				# start DNS relay
				eval `$GETMIB DNS1`
				DNS="--cache=off"
				if [ "$DNS1" != '0.0.0.0' ]; then
					DNS="$DNS -s $DNS1"
					echo nameserver $DNS1 >> $RESOLV_CONF
				fi
				eval `$GETMIB DNS2`
				if [ "$DNS2" != '0.0.0.0' ]; then
					DNS="$DNS -s $DNS2"
					echo nameserver $DNS2 >> $RESOLV_CONF
				fi
				eval `$GETMIB DNS3`
				if [ "$DNS3" != '0.0.0.0' ]; then
					DNS="$DNS -s $DNS3"
					echo nameserver $DNS3 >> $RESOLV_CONF
				fi
				echo start DNS Relay Daemon
				if [ -f $DNRDPIDFILE ]; then
      					DNRDPID=`cat $DNRDPIDFILE`
      					kill -9 $DNRDPID 
     					rm -f $DNRDPIDFILE
				fi
				
				eval `flash get DNSRELAY_ENABLED`
				if [ $DNSRELAY_ENABLED = '1' ]; then
				dnrd $DNS
				fi
				
				# for miniigd patch	
				upnp.sh init
				
				$STOP_STATIC_ROUTE 
				$START_STATIC_ROUTE eth1
				
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
				pat0=`head -n $num $TMPFILEDDNS | tail -n 1`
				pat1=`echo $pat0 | cut -f1 -dS`  
				pat2=`echo $pat1 | cut -f1 -d " "`  
				kill -9 $pat2 2> /dev/null
				num=`expr $num + 1`
				done
				rm -f /var/firstddns 2> /dev/null
				rm -f /tmp/tmpfileddns 2> /dev/null
				###########################
				ddns.sh option
				
			elif [ "$WAN_DHCP" = '1' ] || [ "$WAN_DHCP" = '9' ]; then				
				eval `$GETMIB DHCP_MTU_SIZE`
				ifconfig $WAN_INTERFACE mtu $DHCP_MTU_SIZE
				if [ "$WAN_DHCP" = '1' ]; then
					$START_DHCP_CLIENT $WAN_INTERFACE wait&				
				else
					$START_DHCPPLUS_CLIENT $WAN_INTERFACE wait&				
				fi
				# for miniigd patch	
				upnp.sh init
			elif [ "$WAN_DHCP" = '3' ]; then
				echo 'start PPPoE daemon'
				$START_PPPOE all $WAN_INTERFACE
				
				# for miniigd patch	
				upnp.sh init
			elif [ "$WAN_DHCP" = '4' ]; then
				echo 'start PPTP daemon'
				eval `$GETMIB PPTP_WAN_IP_DYNAMIC`
                             if [ $PPTP_WAN_IP_DYNAMIC = 0 ]; then
				  	eval `$GETMIB DHCP_MTU_SIZE`
				  	ifconfig $WAN_INTERFACE mtu $DHCP_MTU_SIZE
				  	$START_DHCP_CLIENT $WAN_INTERFACE wait&
				else
  					rm -f /etc/udhcpc/resolv.conf 2> /dev/null
  					eval `$GETMIB PPTP_IP_ADDR`
				  	eval `$GETMIB PPTP_SUBNET_MASK`
				  	eval `$GETMIB PPTP_GATEWAY`
				  	eval `$GETMIB PPTP_CONNECTION_TYPE`
  					ifconfig $WAN_INTERFACE addr $PPTP_IP_ADDR  netmask $PPTP_SUBNET_MASK
  					ifconfig $WAN_INTERFACE mtu 1500
  					#if [ $PPTP_CONNECTION_TYPE != 2 ]; then
  						route add -net default gw $PPTP_GATEWAY dev eth1
  					#fi
				  	if [ -r /etc/ppp/connectfile ]; then
						rm -f /etc/ppp/connectfile 2> /dev/null
					fi
					DNS="--cache=off"
  					eval `flash get DNS1`
  					 if [ "$DNS1" != '0.0.0.0' ]; then
      						DNS="$DNS -s $DNS1"
						echo nameserver $DNS1 > $RESOLV_CONF       
					else
						DNS="$DNS -s $PPTP_GATEWAY"
						echo nameserver $PPTP_GATEWAY > $RESOLV_CONF    
    					fi
    				#echo 'Set Static Route'
					$STOP_STATIC_ROUTE
					$START_STATIC_ROUTE eth1 ru	
					killall pptp.sh 2> /dev/null
					$START_PPTP $WAN_INTERFACE &
				fi
				
				# for miniigd patch	
				upnp.sh init
			elif [ "$WAN_DHCP" = '5' ]; then				
				echo 'start BigPond daemon'
				eval `$GETMIB DHCP_MTU_SIZE`
				ifconfig $WAN_INTERFACE mtu $DHCP_MTU_SIZE
				$START_DHCP_CLIENT $WAN_INTERFACE wait&	
                                bpalogin.sh &			
                                
				# for miniigd patch	
				upnp.sh init
			elif [ "$WAN_DHCP" = '6' ]; then
				echo 'start L2TP daemon'
				eval `$GETMIB L2TP_WAN_IP_DYNAMIC`
                             if [ $L2TP_WAN_IP_DYNAMIC = 0 ]; then
				  eval `$GETMIB DHCP_MTU_SIZE`
				  ifconfig $WAN_INTERFACE mtu $DHCP_MTU_SIZE
				  	$START_DHCP_CLIENT $WAN_INTERFACE wait&
				else
				  	rm -f /etc/udhcpc/resolv.conf 2> /dev/null
				  	eval `flash get L2TP_IP_ADDR`
					eval `flash get L2TP_SUBNET_MASK`
					eval `flash get L2TP_GATEWAY`
					eval `flash get L2TP_CONNECTION_TYPE`
  					ifconfig $WAN_INTERFACE addr $L2TP_IP_ADDR  netmask $L2TP_SUBNET_MASK
  					ifconfig $WAN_INTERFACE mtu 1500
  					#if [ $L2TP_CONNECTION_TYPE != 2 ]; then
  						route add -net default gw $L2TP_GATEWAY dev eth1
  					#fi
					if [ -r /etc/ppp/connectfile ]; then
						rm -f /etc/ppp/connectfile 2> /dev/null
					fi
					DNS="--cache=off"
  					eval `flash get DNS1`
  					 if [ "$DNS1" != '0.0.0.0' ]; then
      						DNS="$DNS -s $DNS1"
						echo nameserver $DNS1 > $RESOLV_CONF       
					else
						DNS="$DNS -s $L2TP_GATEWAY"
						echo nameserver $L2TP_GATEWAY > $RESOLV_CONF    
    					fi
    				#echo 'Set Static Route'
					$STOP_STATIC_ROUTE
					$START_STATIC_ROUTE eth1 ru		
					
					killall l2tp.sh 2> /dev/null
					$START_L2TP $WAN_INTERFACE &
				fi
				
				# for miniigd patch	
				upnp.sh init
			elif [ "$WAN_DHCP" = '7' ]; then
				echo 'start PPPoE daemon for Ru'
				echo 0 > /var/ck_oeru
				eval `$GETMIB PPPOE_RU_WANPHY_IP_DYNAMIC`
                                if [ $PPPOE_RU_WANPHY_IP_DYNAMIC = 0 ]; then
				  	eval `$GETMIB DHCP_MTU_SIZE`
				  	ifconfig $WAN_INTERFACE mtu 1500
				  	$START_DHCP_CLIENT $WAN_INTERFACE wait&
				  else
				  	eval `$GETMIB PPPOE_RU_WANPHY_IP`
				  	eval `$GETMIB PPPOE_RU_WANPHY_MASK`
				  	eval `$GETMIB PPPOE_RU_WANPHY_GATEWAY`
				  	eval `$GETMIB PPPOE_RU_CONNECT_TYPE`
				  	ifconfig $WAN_INTERFACE addr $PPPOE_RU_WANPHY_IP  netmask $PPPOE_RU_WANPHY_MASK
				  	ifconfig $WAN_INTERFACE mtu 1500
				  	echo $PPPOE_RU_WANPHY_GATEWAY > /var/pptp_gw
				  	#if [ $PPPOE_RU_CONNECT_TYPE != 2 ]; then
				  	route add -net default gw $PPPOE_RU_WANPHY_GATEWAY dev eth1
				  	#fi	
				  	if [ -r /etc/ppp/connectfile ]; then
						rm -f /etc/ppp/connectfile 2> /dev/null
					fi
					eval `flash get DNS_MODE`
					DNS="--cache=off"
					if [ $DNS_MODE = 1 ]; then
	  					eval `flash get DNS1`
	  					 if [ "$DNS1" != '0.0.0.0' ]; then
	      						DNS="$DNS -s $DNS1"
							echo nameserver $DNS1 > $RESOLV_CONF   
						fi
						eval `flash get DNS2`
						if [ "$DNS2" != '0.0.0.0' ]; then
							DNS="$DNS -s $DNS2"
							echo nameserver $DNS2 >> $RESOLV_CONF   
						fi	    
					else
						DNS="$DNS -s $PPPOE_RU_WANPHY_GATEWAY"
						echo nameserver $PPPOE_RU_WANPHY_GATEWAY > $RESOLV_CONF    
    					fi
				  	setfirewall wanphy
				  	#echo 'Set Static Route'
					$STOP_STATIC_ROUTE
					$START_STATIC_ROUTE eth1 ru
					killall -9 igmpproxy 2> /dev/null
					if [ $IGMP_PROXY_DISABLED = 0 ]; then
						igmpproxy eth1 br0 &
					fi	
				fi
				$START_PPPOE_RU all $WAN_INTERFACE 
				# for miniigd patch	
				upnp.sh init
				
			elif [ "$WAN_DHCP" = '8' ]; then
				echo 'start PPTP daemon Ru'
				eval `$GETMIB PPTP_RU_WANPHY_IP_DYNAMIC`
                             if [ $PPTP_RU_WANPHY_IP_DYNAMIC = 0 ]; then
				  eval `$GETMIB DHCP_MTU_SIZE`
				  ifconfig $WAN_INTERFACE mtu 1500
				  	$START_DHCP_CLIENT $WAN_INTERFACE wait&
				 else
				 	rm -f /etc/udhcpc/resolv.conf 2> /dev/null
				 	eval `$GETMIB PPTP_RU_WANPHY_IP`
				  	eval `$GETMIB PPTP_RU_WANPHY_MASK`
				  	eval `$GETMIB PPTP_RU_WANPHY_GATEWAY`
				  	eval `$GETMIB PPTP_RU_CONNECTION_TYPE`
					ifconfig $WAN_INTERFACE addr $PPTP_RU_WANPHY_IP  netmask $PPTP_RU_WANPHY_MASK
  					ifconfig $WAN_INTERFACE mtu 1500
  					#if [ $PPTP_RU_CONNECTION_TYPE != 2 ]; then
  						route add -net default gw $PPTP_RU_WANPHY_GATEWAY dev eth1
  					#fi
  					if [ -r /etc/ppp/connectfile ]; then
						rm -f /etc/ppp/connectfile 2> /dev/null
				fi
  					DNS="--cache=off"
  					eval `flash get DNS1`
  					 if [ "$DNS1" != '0.0.0.0' ]; then
      						DNS="$DNS -s $DNS1"
						echo nameserver $DNS1 > $RESOLV_CONF       
					else
						DNS="$DNS -s $PPTP_RU_WANPHY_GATEWAY"
						echo nameserver $PPTP_RU_WANPHY_GATEWAY > $RESOLV_CONF    
    					fi
    					#dnrd $DNS
  					setfirewall wanphy
  					#echo 'Set Static Route'
  					$STOP_STATIC_ROUTE
  					$START_STATIC_ROUTE eth1 ru
  					killall -9 igmpproxy 2> /dev/null
  					if [ $IGMP_PROXY_DISABLED = 0 ]; then
						igmpproxy eth1 br0 &
  					fi	
					killall pptp_ru.sh 2> /dev/null
					echo done > /var/setwan_check
				$START_PPTP_RU $WAN_INTERFACE &
				fi
				
				
				# for miniigd patch	
				upnp.sh init
			else
				echo 'Invalid DHCP MIB value for WAN interface!'
			fi
		fi
		# enable firewall when static ip
		if [ "$WAN_DHCP" = '0' ] || [ "$OP_MODE" = '1' ]; then
			echo 'Setup Firewall'
			$START_FIREWALL 
		fi
		# static ip 	
		if [ -f /bin/vpn.sh ] && [ "$WAN_DHCP" != '4' ] && [ "$OP_MODE" != '1' ] &&  [ "$WAN_DHCP" = '0' ] ; then 
			echo 'Setup VPN'
			vpn.sh all
		fi

		# enable the traffic control settings when OP_MODE is not equal to the bridge mode
		# move to firewall.c
		#if [ "$OP_MODE" != '1' ]; then
		#	#  if [ "$CONFIG_NET_QOS" = "y" ]; then		
		#		$START_IP_QOS
		#	# fi
		#fi
		
		#enable ntp daemon , not brige mode
##		if [ "$OP_MODE" != '1' ]; then		
##			$START_NTP
##		fi		
##################################################
		if [ "$OP_MODE" != '1' ] && [ "$WAN_DHCP" = 0 ]; then
			rm -f $NTP_PROCESS 2> /dev/null
			killall -9 $START_NTP 2> /dev/null
			$START_NTP
		fi		

##################################################		
		
		
		
		#if [ "$NAT_ENABLED" = '1' ]; then 
     		#if [ "$RIP_ENABLED" = '1' ]; then
        	#	dyn_route.sh
     		#fi	
		#fi
	fi

else
	# Delete DHCP server/client process
	PIDFILE=/etc/udhcpc/udhcpc-$BR_INTERFACE.pid
	if [ -f $PIDFILE ] ; then
		PID=`cat $PIDFILE`
		if [ $PID != 0 ]; then
			kill -9 $PID 2> /dev/null
	       	fi
      		rm -f $PIDFILE
	fi

	PIDFILE=/var/run/udhcpd.pid
	if [ -f $PIDFILE ] ; then
		PID=`cat $PIDFILE`
		if [ $PID != 0 ]; then
			kill -9 $PID 2> /dev/null
       		fi
      		rm -f $PIDFILE
	fi

	if [ "$OP_MODE" = '1' ];then
		$START_BRIDGE $BR_INTERFACE $BR_LAN1_INTERFACE $VLAN_INTERFACE $WLAN_INTERFACE $BR_LAN2_INTERFACE $VIRTUAL_WLAN_INTERFACE
	else		
		$START_BRIDGE $BR_INTERFACE $BR_LAN1_INTERFACE $VLAN_INTERFACE $WLAN_INTERFACE $VIRTUAL_WLAN_INTERFACE
	fi
		echo 'after bridge 2'

	eval `$GETMIB DHCP`
	#gold stop dhcp server in haier in ap and ap client mode-->
	HAIER=`head /web/language.js | grep Haier_DAP1332`
	if [ "$HAIER" != "" -a "$OP_MODE" = "1" ];then
		echo "msg: bridge mode and disable dhcp server"
		AP_DHCP=0
	else
		eval `$GETMIB AP_DHCP`
	fi
	#eval `$GETMIB AP_DHCP`
	#<-- gold
	if [ "$AP_DHCP" != '0' ] ; then
		sleep 1
		$START_DHCP_SERVER $BR_INTERFACE ap
	fi
	$START_WLAN_APP start $WLAN_INTERFACE $BR_INTERFACE
fi

if [ $ENABLE_WAN_BR = 1 ]; then
if [ "$VPN_PASSTHRU_IPV6" = '1' ] ; then
        echo "$WAN_INTERFACE " > /proc/wan_if
else
        echo "" > /proc/wan_if
	fi
fi

if [ $ENABLE_BR = 1 ]; then
#netbios
killall netbios
killall llmnresp
eval `$GETMIB NETBIOS_ANNOUNCE`
eval `$GETMIB NETBOIS_SCOPE`
eval `$GETMIB HOST_NAME`
eval `$GETMIB NETBIOS_SOURCE`
eval `$GETMIB LAN_NETBIOS_NAME`	
if [ "$LAN_NETBIOS_NAME" != "" ]; then
	NETBIOS_NAME_ALL="$LAN_NETBIOS_NAME"
	llmnresp -r "$LAN_NETBIOS_NAME" &
fi
if [ "$NETBIOS_ANNOUNCE" = "1" ]; then
	if [ "$NETBIOS_SOURCE" = "1" ]; then
		NETBIOS_NAME_ALL="$NETBIOS_NAME_ALL $HOST_NAME"
	else
		if [ "$NETBOIS_SCOPE" = "" ] ; then
			NETBIOS_NAME_ALL="$NETBIOS_NAME_ALL $HOST_NAME"
		else
			NETBIOS_NAME_ALL="$NETBIOS_NAME_ALL $NETBOIS_SCOPE"
		fi
	fi
fi
if [ "$NETBIOS_NAME_ALL" != "" ]; then
	netbios $NETBIOS_NAME_ALL &
	fi
fi
# start mini_upnpd shared daemon
killall -9 mini_upnpd 2> /dev/null


_CMD=
if [ $WSC_DISABLE = 0 ]; then
        _CMD="$_CMD -wsc /tmp/wscd_config"
fi

if [ "$GATEWAY" = 'true' ] && [ "$OP_MODE" != '1' ]; then
        eval `$GETMIB UPNP_ENABLED`
        if [ $UPNP_ENABLED != 0 ]; then
                _CMD="$_CMD -igd /tmp/igd_config -wsc /tmp/wscd_config -deamon"
        fi
fi

if [ "$_CMD" != "" ]; then
        mini_upnpd $_CMD &
fi

if [ $ENABLE_WAN_BR = 1 ]; then
#put the system started msg to log
exlog /tmp/log_web.lck /tmp/log_web "tag:SYSACT;log_num:13;msg:System started;"

# hnapd related file
echo "1" > /tmp/hnapd_wait_reinit
fi

# enable IGMP proxy daemon
# not include igmpsnoop in TR	

if [ $ENABLE_WAN = 1 ]; then
if [ "$WAN_DHCP" = '0' ]; then	
	killall -9 igmpproxy 2> /dev/null
	if [ "$IGMP_PROXY_DISABLED" = 0 ]; then
			igmpproxy $WAN_INTERFACE br0 &
	fi	
	if [ $DNSRELAY_ENABLED = 0 ]; then
		#inform DHCPD for DNS setting
		PIDFILE_DHCPD=/var/run/udhcpd.pid
		if [ -f $PIDFILE_DHCPD ]; then
		PID_DHCPD=`cat $PIDFILE_DHCPD`
		if [ $PID_DHCPD != 0 ]; then
			echo "update_conf_dns" > /tmp/dhcpd_action
			sleep 1
			kill -17 $PID_DHCPD 2> /dev/null
		fi
		fi
	fi	
	fi
fi

echo $WAN_DHCP > /var/wantype
# SNMP daemon
#if [ -f /bin/snmpd ]; then
#	snmpd.sh restart
#fi
if [ $ENABLE_WAN = 1 ]; then
eval `flash get EMAIL_NOTIFICATION`
if [ $EMAIL_NOTIFICATION = 1 ]; then
	if [ -f $WEBPIDFILE ] ; then
		PID=`cat $WEBPIDFILE`
		if [ $PID != 0 ]; then
			kill -17 $PID 2>/dev/null
			fi
		fi
	fi
	# set WAN port speed
	eval `$GETMIB WAN_FORCE_SPEED`
	echo "$WAN_FORCE_SPEED 4" > /proc/port_speed
fi

if [ $ENABLE_BR = 1 ]; then
if [ -f /bin/nbtscan ]; then
    eval `$GETMIB DHCP_CLIENT_START`
    eval `$GETMIB DHCP_CLIENT_END`
    nbtscan $DHCP_CLIENT_START:$DHCP_CLIENT_END -t 2000 > /tmp/nbios &
fi

if [ "$GATEWAY" = 'true' ]; then
	if [ -f /bin/lld2d ]; then
		# for LLTD
		killall -9 lld2d 2>/dev/null
		rm /var/run/lld2d-br0.pid 2>/dev/null
		lld2d br0
	fi	
	fi
fi

echo A > /proc/ps_led
echo 1 > /proc/ps_led
if [ $ENABLE_WAN_BR = 1 ]; then
# start reload
killall -9 reload 2> /dev/null

eval `$GETMIB SCHEDULE_ENABLED`
if [ "$SCHEDULE_ENABLED" != 0 ]; then
	wlan0_sch=0
	wlan0_va0_sch=0
	eth_sch=0
	eval `$GETMIB WLAN_DISABLED`
	if [ "$WLAN_DISABLED" = 0 ]; then
		eval `$GETMIB SCHEDULE_TBL_NUM`
		if [ "$SCHEDULE_TBL_NUM" != 0 ]; then
			eval `$GETMIB SCHEDULE_SELECT_IDX`
			if [ "$SCHEDULE_SELECT_IDX" -lt "$SCHEDULE_TBL_NUM" ]; then
				SCHEDULE_SELECT_IDX=`expr $SCHEDULE_SELECT_IDX + 1`			
				SCH_TBL=`$GETMIB SCHEDULE_TBL | grep SCHEDULE_TBL$SCHEDULE_SELECT_IDX`
				tbl_comment=`echo $SCH_TBL | cut -f2 -d=`
				wlan_sch=1
				fi
			fi
		fi

	eval `$GETMIB GUEST_ZONE_ENABLED`
	if [ "$GUEST_ZONE_ENABLED" = 1 ]; then
		eval `$GETMIB GUEST_ZONE_WLANENABLE`
		if [ "$GUEST_ZONE_WLANENABLE" = 1 ]; then
			eval `$GETMIB SCHEDULE_TBL_NUM`
			if [ "$SCHEDULE_TBL_NUM" != 0 ]; then
				eval `$GETMIB GUEST_SCHEDULE_SELECT_IDX`
				if [ "$GUEST_SCHEDULE_SELECT_IDX" -lt "$SCHEDULE_TBL_NUM" ]; then
					GUEST_SCHEDULE_SELECT_IDX=`expr $GUEST_SCHEDULE_SELECT_IDX + 1`			
					SCH_TBL=`$GETMIB SCHEDULE_TBL | grep SCHEDULE_TBL$GUEST_SCHEDULE_SELECT_IDX`
					tbl_comment_va0=`echo $SCH_TBL | cut -f2 -d=`
					wlan_va0_sch=1
					fi
				fi
			fi
		fi

	eval `$GETMIB GUEST_ZONE_PORTLIST`		
	if [ "$GUEST_ZONE_ENABLED" != 0 ] && [ "$GUEST_ZONE_PORTLIST" != 0 ]; then
		eval `$GETMIB SCHEDULE_TBL_NUM`
		if [ "$SCHEDULE_TBL_NUM" != 0 ]; then
			eval `$GETMIB GUEST_SCHEDULE_SELECT_IDX`
			if [ "$GUEST_SCHEDULE_SELECT_IDX" -lt "$SCHEDULE_TBL_NUM" ]; then
				GUEST_SCHEDULE_SELECT_IDX=`expr $GUEST_SCHEDULE_SELECT_IDX + 1`			
				SCH_TBL=`$GETMIB SCHEDULE_TBL | grep SCHEDULE_TBL$GUEST_SCHEDULE_SELECT_IDX`
				tbl_comment_tmp=`echo $SCH_TBL | cut -f2 -d=`
				tbl_comment_eth="$tbl_comment_tmp -p $GUEST_ZONE_PORTLIST"	
				eth_sch=1
			fi
		fi			
	fi

	_CMD=
	if [ "$wlan_sch" = 1 ]; then
		_CMD="-e $tbl_comment"
	fi
	if [ "$wlan_va0_sch" = 1 ]; then
		_CMD="$_CMD -f $tbl_comment_va0"
	fi		
	if [ "$eth_sch" = 1 ]; then
		_CMD="$_CMD -g $tbl_comment_eth"
	fi		
	reload $_CMD &

#	if [ "$wlan_sch" = 1 ] && [ "$wlan_va0_sch" = 1 ]; then
#		reload -e $tbl_comment -f $tbl_comment_va0 &
#	elif [ "$wlan_sch" = 1 ]; then
#		reload -e $tbl_comment &
#	elif [ "$wlan_va0_sch" = 1 ]; then
#		reload -f $tbl_comment_va0 &
#	else
#		reload &
#	fi
else
	reload &
	fi
fi

