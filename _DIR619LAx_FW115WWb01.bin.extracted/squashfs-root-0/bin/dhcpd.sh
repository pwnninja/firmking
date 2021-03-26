#!/bin/sh
#
# script file to start udhcpd daemon (udhcp server)
#

if [ $# -lt 2 ]; then echo "Usage: $0 interface {gw | ap} ";  exit 1 ; fi

GETMIB="flash get"
CONF_FILE=/var/udhcpd.conf
LEASE_FILE=/var/lib/misc/udhcpd.leases
USE_CUSTOM_DOMAIN=0
# See if DHCP server is on
eval `flash get DNSRELAY_ENABLED`
eval `$GETMIB DHCP`
if [ "$DHCP" != '2' ] && [ "$DHCP" != '10' ]; then
	exit 0
fi

echo "interface $1" > $CONF_FILE

eval `$GETMIB DHCP_CLIENT_START`
echo "start $DHCP_CLIENT_START" >> $CONF_FILE

eval `$GETMIB DHCP_CLIENT_END`
echo "end $DHCP_CLIENT_END" >> $CONF_FILE

eval `$GETMIB GUEST_ZONE_ENABLED`
echo "guestmac_check $GUEST_ZONE_ENABLED" >> $CONF_FILE

eval `$GETMIB SUBNET_MASK`
echo "opt subnet $SUBNET_MASK" >> $CONF_FILE

eval `$GETMIB DHCP_LEASE_TIME` 
echo "opt lease $DHCP_LEASE_TIME" >> $CONF_FILE

if [ $2 = "ap" ]; then
	eval `$GETMIB DEFAULT_GATEWAY`
	if [ "$DEFAULT_GATEWAY" != "0.0.0.0" ]; then
	echo "opt router $DEFAULT_GATEWAY"  >> $CONF_FILE
	fi
	eval `$GETMIB DNS1`
	if [ "$DNS1" != "0.0.0.0" ]; then
		echo "opt dns $DNS1" >> $CONF_FILE
	fi
	eval `$GETMIB DNS2`
	if [ "$DNS2" != "0.0.0.0" ]; then
		echo "opt dns $DNS2" >> $CONF_FILE
	fi
	eval `$GETMIB DNS3`
	if [ "$DNS3" != "0.0.0.0" ]; then
		echo "opt dns $DNS3" >> $CONF_FILE
	fi
	# set default
	if [ "`cat $CONF_FILE | grep dns`" = "" ]; then
		echo "opt dns $DEFAULT_GATEWAY"  >> $CONF_FILE
	fi
	
	eval `$GETMIB DOMAIN_NAME`	
	if [ "$DOMAIN_NAME" != "" ]; then
		echo "opt domain $DOMAIN_NAME" >> $CONF_FILE
	fi
	echo "updatecfg_dns 0" >> $CONF_FILE
	eval `$GETMIB DHCPD_BROADCAST`	
	echo "res_br $DHCPD_BROADCAST" >> $CONF_FILE
	echo "updatecfg_isp 0" >> $CONF_FILE
	eval `$GETMIB NETBIOS_ANNOUNCE`	
	if [ $NETBIOS_ANNOUNCE = 1 ]; then
			eval `$GETMIB NETBOIS_SCOPE`	
			echo "opt nbscope $NETBOIS_SCOPE"  >> $CONF_FILE
			eval `$GETMIB NETBIOS_NODE_TYPE`	
			echo "opt nbntype $NETBIOS_NODE_TYPE"  >> $CONF_FILE
			if [ $NETBIOS_NODE_TYPE != 1 ]; then
			eval `$GETMIB PRI_WINS_IP`	
			echo "opt wins $PRI_WINS_IP"  >> $CONF_FILE
			eval `$GETMIB SEC_WINS_IP`	
			echo "opt wins $SEC_WINS_IP"  >> $CONF_FILE
			fi
	fi	
else
	eval `$GETMIB IP_ADDR`
	echo "opt router $IP_ADDR"  >> $CONF_FILE

	if [ $DNSRELAY_ENABLED = 0 ]; then
	#	eval `$GETMIB DNS_MODE`
	
	#if [ "$DNS_MODE" = '0' ]; then
	#	echo "opt dns $IP_ADDR" >> $CONF_FILE
	#else
		
	#	if [ "$DNS_MODE" = '1' ]; the
	#		eval `$GETMIB DNS1`
	#		if [ "$DNS1" != "0.0.0.0" ]; then
	#			echo "opt dns $DNS1" >> $CONF_FILE
	#		fi
	#		eval `$GETMIB DNS2`
	#		if [ "$DNS2" != "0.0.0.0" ]; then
	#			echo "opt dns $DNS2" >> $CONF_FILE
	#		fi
	#	fi
		
	#	eval `$GETMIB DNS3`
	#	if [ "$DNS3" != "0.0.0.0" ]; then
	#		echo "opt dns $DNS3" >> $CONF_FILE
	#	fi
	#fi
	
	echo "updatecfg_dns 1" >> $CONF_FILE
		
	else
		echo "opt dns $IP_ADDR"  >> $CONF_FILE
		echo "updatecfg_dns 0" >> $CONF_FILE
		# set default
		#if [ "`cat $CONF_FILE | grep dns`" = "" ]; then
		#	echo "opt dns $IP_ADDR"  >> $CONF_FILE
		#fi
	fi
	eval `$GETMIB DHCPD_BROADCAST`	
	echo "res_br $DHCPD_BROADCAST" >> $CONF_FILE
	
	eval `$GETMIB DOMAIN_NAME`	
	if [ "$DOMAIN_NAME" != "" ]; then
		echo "opt domain $DOMAIN_NAME" >> $CONF_FILE
	fi	
	eval `$GETMIB NETBIOS_ANNOUNCE`	
	eval `$GETMIB NETBIOS_SOURCE`	
		if [ $NETBIOS_ANNOUNCE = 1 ]; then
			if [ $NETBIOS_SOURCE = 1 ]; then
					echo "updatecfg_isp $NETBIOS_SOURCE" >> $CONF_FILE
			else
					echo "updatecfg_isp $NETBIOS_SOURCE" >> $CONF_FILE
					eval `$GETMIB NETBOIS_SCOPE`	
					echo "opt nbscope $NETBOIS_SCOPE"  >> $CONF_FILE
					eval `$GETMIB NETBIOS_NODE_TYPE`	
					echo "opt nbntype $NETBIOS_NODE_TYPE"  >> $CONF_FILE
					if [ $NETBIOS_NODE_TYPE != 1 ]; then
					eval `$GETMIB PRI_WINS_IP`	
					echo "opt wins $PRI_WINS_IP"  >> $CONF_FILE
					eval `$GETMIB SEC_WINS_IP`	
					echo "opt wins $SEC_WINS_IP"  >> $CONF_FILE
					fi
			fi
		fi	
fi

eval `$GETMIB DHCPRSVDIP_ENABLED`
if [ $DHCPRSVDIP_ENABLED != 0 ]; then
	eval `$GETMIB DHCPRSVDIP_TBL_NUM`
	if [ $DHCPRSVDIP_TBL_NUM -gt 0 ]; then
		num=1
  		while [ $num -le $DHCPRSVDIP_TBL_NUM ];
  		do
    		DHCPRSVDIP_ENT=`$GETMIB DHCPRSVDIP_TBL | grep DHCPRSVDIP_TBL$num=`
    		tmp=`echo $DHCPRSVDIP_ENT | cut -f2 -d=`    		
    		MAC=`echo $tmp | cut -f1 -d,`
    		IP=`echo $tmp | cut -f2 -d,`
    		NAME=`echo $tmp | cut -f3 -d,`
    		ENABLE=`echo $tmp | cut -f4 -d,`
#			echo "static_lease $MAC $IP $NAME" >> $CONF_FILE 
			if [ $ENABLE = 1 ]; then
				echo "static_lease $MAC $IP" >> $CONF_FILE 
			fi
  			num=`expr $num + 1`
  		done
	fi
fi
#gold remove
#if [ -f "$LEASE_FILE" ]; then
#	rm -f $LEASE_FILE
#fi
#echo "" > $LEASE_FILE

eval `$GETMIB IP_ADDR`
fixedip.sh $1 $IP_ADDR $SUBNET_MASK 0.0.0.0

udhcpd $CONF_FILE






