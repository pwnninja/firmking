#!/bin/sh
#
# $Id: //WIFI_SOC/release/SDK_4_1_0_0/source/user/rt2880_app/scripts/ddns.sh#1 $
# linsd add for support dlinkddns and oray
# usage: ddns.sh
#
. /sbin/global.sh
PHLINUX_FILE=/etc/phlinux.conf
INADYNIP_FILE=/var/inadyn_ip.cache

en=`nvram_get 2860 DDNSEnable`
srv=`nvram_get 2860 DDNSProvider`
ddns=`nvram_get 2860 DDNS`
u=`nvram_get 2860 DDNSAccount`
pw=`nvram_get 2860 DDNSPassword`
#wanmode=`nvram_get 2860 wanConnectionMode`

killall -q inadyn
killall -q peanuthullc2

if [ "$en" = "0" ]; then
	echo "stop ddns!"
	exit 0
fi

if [ "$srv" = "" -o "$srv" = "none" ]; then
	exit 0
fi
if [ "$ddns" = "" -o "$u" = "" -o "$pw" = "" ]; then
	exit 0
fi

# debug
echo "srv=$srv"
echo "ddns=$ddns"
echo "u=$u"
echo "pw=$pw"

#linsd add for ddns status init
nvram_set 2860 DDNS_STATUS 0
#linsd add for disable updating when it's using DHCP client wan service
#if [ "$wanmode" = "DHCP" ]; then
#	exit 0
#fi
wan_ip=`ifconfig $wan_ppp_if | grep "inet addr:" | cut -d ':' -f 2 | cut -d ' ' -f 1`
echo "$wan_ip" > $INADYNIP_FILE

if [ "$srv" = "dyndns.org" ]; then
	inadyn -u $u -p $pw -a $ddns --dyndns_system dyndns@$srv &
elif [ "$srv" = "freedns.afraid.org" ]; then
	inadyn -u $u -p $pw -a $ddns --dyndns_system default@$srv &
elif [ "$srv" = "zoneedit.com" ]; then
	inadyn -u $u -p $pw -a $ddns --dyndns_system default@$srv &
elif [ "$srv" = "no-ip.com" ]; then
	inadyn -u $u -p $pw -a $ddns --dyndns_system default@$srv &
elif [ "$srv" = "dlinkddns.com" ]; then
	inadyn -u $u -p $pw -a $ddns --dyndns_system default@$srv &
elif [ "$srv" = "dlinkddns.cn" ]; then
	inadyn -u $u -p $pw -a $ddns --dyndns_system default@$srv &
elif [ "$srv" = "oray.cn" ]; then
	echo "[settings]" > $PHLINUX_FILE
	echo "szHost = phlinux3.oray.net" >> $PHLINUX_FILE
	echo "szUserID = $u" >> $PHLINUX_FILE
	echo "szUserPWD = $pw" >> $PHLINUX_FILE
	echo "nicName = $wan_ppp_if" >> $PHLINUX_FILE
	echo "szLog = /var/log/phddns.log" >> $PHLINUX_FILE
	peanuthullc2 -c $PHLINUX_FILE -d
else
	echo "$0: unknown DDNS provider: $srv"
	exit 1
fi

