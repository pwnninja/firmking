#!/bin/sh
#
# $Id: //WIFI_SOC/release/SDK_4_1_0_0/source/user/rt2880_app/scripts/config-pptp.sh#1 $
#
# usage: config-pptp.sh <mode> <mode_params> <server> <user> <password>
#

. /sbin/config.sh
. /sbin/global.sh

usage()
{
	echo "Usage:"
	echo "  $0 <mode> <mode_params> <server> <user> <password>"
	echo "Modes:"
	echo "  static - <mode_params> = <wan_if_name> <wan_ip> <wan_netmask> <gateway>"
	echo "  dhcp - <mode_params> = <wan_if_name>"
	echo "Example:"
	echo "  $0 static $wan_if 10.10.10.254 255.255.255.0 10.10.10.253 192.168.1.1 user pass"
	echo "  $0 dhcp $wan_if 192.168.1.1 user pass"
	exit 1
}

echo "[config-pptp.sh] [0]$0 [1]$1 [2]$2 [3]$3 [4]$4 [5]$5"

if [ "$1" = "static" ]; then
	ifconfig $2 $3 netmask $4
	echo $3 > /proc/alg_ip
	route del default
	if [ "$5" != "0.0.0.0" ]; then
		route add default gw $5
		echo $5 > /etc/route
	fi

	pd=`nvram_get 2860 wan_pptp_primary_dns`
	sd=`nvram_get 2860 wan_pptp_secondary_dns`
	config-dns.sh $pd $sd
	
	accel-pptp.sh $5
	pppd file /etc/options.pptp  &
	
elif [ "$1" = "dhcp" ]; then
	killall -q udhcpc
	udhcpc -i $2 -s /sbin/udhcpc.sh -p /var/run/udhcpc.pid -f &
	autodns=`nvram_get 2860 wan_pptp_autodns`
	if [ "$autodns" != "1" ]; then
		pd=`nvram_get 2860 wan_pptp_primary_dns`
		sd=`nvram_get 2860 wan_pptp_secondary_dns`
		config-dns.sh $pd $sd
	fi

else
	echo "$0: unknown connection mode: $1"
	usage $0
fi
