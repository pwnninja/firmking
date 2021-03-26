#!/bin/sh
#
# script file to start bridge
#
# Usage: bridge.sh br_interface lan1_interface wlan_interface[1]..wlan_interface[N]
#

if [ $# -lt 3 ]; then echo "Usage: $0 br_interface lan1_interface wlan_interface lan2_interface...";  exit 1 ; fi

GETMIB="flash get"
BR_UTIL=brctl
SET_IP=fixedip.sh
START_DHCP_CLIENT=dhcpc.sh
IFCONFIG=ifconfig
WLAN_PREFIX=wlan
LAN_PREFIX=eth
MAX_WDS_NUM=8
INITFILE=/tmp/bridge_init
STP_ENABLED=1
if [ "$3" != "null" ]; then	
	# shutdown LAN interface (ethernt, wlan, WDS, bridge)
	for ARG in $* ; do
		INTERFACE=`echo $ARG | cut -b -4`
		if [ $INTERFACE = $WLAN_PREFIX ]; then	
			$IFCONFIG $ARG down						
			VXD=`echo $ARG | cut -b 7-`
			VAP=`echo $ARG | cut -b 7-8`
			if [ "$VXD" != "vxd" ] && [ "$VAP" != "va" ]; then
				num=0
				while [ $num -lt $MAX_WDS_NUM ]
				do
					$IFCONFIG $ARG-wds$num down
					num=`expr $num + 1`
					$BR_UTIL delif $1 $ARG-wds$num 2> /dev/null
				done			
			fi	
			if [ "$VAP" = "va" ]; then
				$BR_UTIL delif $1 $ARG 2> /dev/null
			fi
		else
			$IFCONFIG $ARG down	
			if [ $ARG != $1 ]; then
				$BR_UTIL delif $1 $ARG 2> /dev/null
			fi
		fi				
	done

	#delete wlan0 eth1 interface first always, wlan0 eth1 will be added later if mode is opmode = bridge and gw platform
	$BR_UTIL delif $1 eth1 2> /dev/null  
	$BR_UTIL delif $1 wlan0 2> /dev/null  	
	if [ ! -f $INITFILE ]; then
		$BR_UTIL delbr $1
	fi	

	# Enable LAN interface (Ethernet, wlan, WDS, bridge)
	echo 'Setup bridge...'
	if [ ! -f $INITFILE ]; then
		$BR_UTIL addbr $1
	fi

	#eval `$GETMIB STP_ENABLED`
	if [ "$STP_ENABLED" = '0' ]; then
		$BR_UTIL setfd $1 0
		$BR_UTIL stp $1 0
	else
		$BR_UTIL setfd $1 4
		$BR_UTIL stp $1 1
	fi

	#Add lan port to bridge interface
	
	## set guest & zone isolation ##	
	eval `$GETMIB OP_MODE`	
	eval `$GETMIB GUEST_ZONE_ENABLED`
	eval `$GETMIB GUEST_ZONE_PORTLIST`		
	
	if [ $OP_MODE != 0 ] || [ $OP_MODE = 0 -a $GUEST_ZONE_ENABLED != 0 -a $GUEST_ZONE_PORTLIST != 0 ] || [ $STP_ENABLED = 1 ]; then
		echo 1 > /proc/disable_l2_table	
	else
		echo 0 > /proc/disable_l2_table		
	fi
	
	$BR_UTIL setzoneisolate $1 0
	$BR_UTIL setguestisolate $1 0		
	$BR_UTIL setlockclient $1 000000000000
	
	ETH_GUEST=0
	if [ $GUEST_ZONE_ENABLED != 0 ]; then
		eval `$GETMIB GUEST_ROUTE_ZONE`
		if [ $GUEST_ROUTE_ZONE = 0 ]; then
			$BR_UTIL setzoneisolate $1 1
		fi		
		eval `$GETMIB GUEST_ZONE_ISOLATION`
		if [ $GUEST_ZONE_ISOLATION != 0 ]; then
			$BR_UTIL setguestisolate $1 1
		fi			
		
		eval `$GETMIB GUEST_ZONE_LOCK_CLIENTLIST`
		eval `$GETMIB LOCK_CLIENT_NUM`		
		if [ $GUEST_ZONE_LOCK_CLIENTLIST != 0 ] && [ $LOCK_CLIENT_NUM -gt 0 ]; then		
        	num=1  
        	while [ $num -le $LOCK_CLIENT_NUM ];
        	do            
            	str=`flash get LOCK_CLIENT_TBL | grep LOCK_CLIENT_TBL$num`            	
            	str=`echo $str | cut -f2 -d=`
				$BR_UTIL setlockclient $1 $str           
				num=`expr $num + 1`
			done
       	fi	      	
       	if [ $GUEST_ZONE_PORTLIST != 0 ]; then
       		ETH_GUEST=1
       	fi       	
	fi
				
	for ARG in $* ; do
		INTERFACE=`echo $ARG | cut -b -3`
		if [ $INTERFACE = $LAN_PREFIX ]; then	
			flash chk_guest_if $ARG
			TYPE=$?
			if [ $TYPE != 0 ] ; then								
				$BR_UTIL addif $1 $ARG 2> /dev/null
				if [ $ETH_GUEST = 0 ] ||  [ $ETH_GUEST != 0 -a $TYPE = 1 ]; then
					$SET_IP $ARG  0.0.0.0					
				fi
				if [ $TYPE = 2 ] ; then	
					if [ $ARG = eth0 ]; then
						$SET_IP $ARG  0.0.0.0
					fi
					$BR_UTIL setzone $1 $ARG 1									
				elif [ $TYPE = 1 ] ; then
					$BR_UTIL setzone $1 $ARG 0				
				fi				
			elif [ $STP_ENABLED = 1 ]; then
				if [ $ARG = eth2 -o $ARG = eth3 -o $ARG = eth4 ]; then
					$SET_IP $ARG 0.0.0.0
					$BR_UTIL addif $1 $ARG 2> /dev/null
				fi
			fi
		fi	
	done
	
	eval `$GETMIB SCHEDULE_ENABLED`
	START_WLAN=1
	if [ "$SCHEDULE_ENABLED" != 0 ]; then
#		eval `$GETMIB SCHEDULE_TBL_NUM`
#		if [ "$SCHEDULE_TBL_NUM" != 0 ]; then
#			eval `$GETMIB SCHEDULE_SELECT_IDX`
#			if [ "$SCHEDULE_SELECT_IDX" != 0 ] && [ "$SCHEDULE_SELECT_IDX" -lt "$SCHEDULE_TBL_NUM" ]; then
#				START_WLAN=0
#			fi	
#		fi
#		iwpriv wlan0 set_mib func_off=1
		iwpriv wlan0-va0 set_mib func_off=1
	fi
		
	for ARG in $* ; do
		INTERFACE=`echo $ARG | cut -b -4`
		if [ $INTERFACE = $WLAN_PREFIX ]; then
			VAP=`echo $ARG | cut -b 7-8`
			if [ "$VAP" = "va" ]; then
				ROOT_IF=`echo $ARG | cut -b -5`
				eval `$GETMIB $ROOT_IF WLAN_DISABLED`
				if [ "$WLAN_DISABLED" = 0 ]; then
					eval `$GETMIB $ROOT_IF MODE`
					if  [ "$MODE" != 0 ] && [ "$MODE" != 3 ]; then
						WLAN_DISABLED=1
					else
						eval `$GETMIB GUEST_ZONE_ENABLED`		
						eval `$GETMIB GUEST_ZONE_WLANENABLE`										
						if [ "$GUEST_ZONE_ENABLED" = 0 -o "$GUEST_ZONE_WLANENABLE" = 0 ]; then
							WLAN_DISABLED=1
						else
							WLAN_DISABLED=0
							iwpriv $ARG set_mib block_relay=$GUEST_ZONE_ISOLATION							
						fi						
					fi
				else
					WLAN_DISABLED=1
				fi
			else
				eval `$GETMIB $ARG WLAN_DISABLED`
			fi
			
			if [ "$WLAN_DISABLED" = 0 ]; then
				eval `$GETMIB WISP_WAN_ID`
				# if opmode is wireless isp, don't add wlan0 to bridge
				if [ "$VAP" = "va" ] || [ "$OP_MODE" != '2' ] || [ $ARG != "wlan$WISP_WAN_ID" ] ;then
					$BR_UTIL addif $1 $ARG 2> /dev/null
					if [ $START_WLAN != 0 ]; then
						$SET_IP $ARG 0.0.0.0
					fi
				else
					if [ $START_WLAN != 0 ]; then
						$IFCONFIG $ARG up
					fi
				fi		
				
				flash chk_guest_if $ARG				
				if [ $? = 2 ] ; then
					$BR_UTIL setzone $1 $ARG 1					
				else
					$BR_UTIL setzone $1 $ARG 0							
				fi								
							
				eval `$GETMIB $ARG WDS_ENABLED`
				eval `$GETMIB $ARG WDS_NUM`
				eval `$GETMIB $ARG MODE`
				if [ $WDS_ENABLED != 0 ] && [ $WDS_NUM != 0 ] && [ $MODE = 2 -o $MODE = 3 ]; then
					num=0
					while [ $num -lt $WDS_NUM ]
					do
						$BR_UTIL addif $1 $ARG-wds$num 2> /dev/null
						$SET_IP $ARG-wds$num 0.0.0.0		
						num=`expr $num + 1`
					done
				fi				
			fi
		fi	
	done	
	
	# Set Ethernet 0 MAC address to bridge
	#eval `$GETMIB STP_ENABLED`
#	if [ "$STP_ENABLED" = '0' ]; then
		eval `$GETMIB ELAN_MAC_ADDR`
		if [ "$ELAN_MAC_ADDR" = "000000000000" ]; then
			eval `$GETMIB HW_NIC0_ADDR`
			ELAN_MAC_ADDR=$HW_NIC0_ADDR
		fi
		ifconfig $1 hw ether $ELAN_MAC_ADDR
#	fi
	
	if [ ! -f $INITFILE ]; then
		$SET_IP $1 0.0.0.0
		echo 1 > $INITFILE 	
	fi
fi

# Set fixed IP or start DHCP client
eval `$GETMIB DHCP`
if [ "$DHCP" = '0' -o "$DHCP" = '2' -o "$DHCP" = '10' ]; then
	eval `$GETMIB IP_ADDR`
	eval `$GETMIB SUBNET_MASK`
	eval `$GETMIB DEFAULT_GATEWAY`
	$SET_IP $1 $IP_ADDR $SUBNET_MASK $DEFAULT_GATEWAY
elif [ "$DHCP" = '1' ]; then
  {
  	#eval `$GETMIB STP_ENABLED`
	#if [ "$STP_ENABLED" = '1' ]; then
	#	echo 'waiting for bridge initialization...'
	#	sleep 30
	#fi
	$START_DHCP_CLIENT $1 no
  }&
fi
