#!/bin/sh
#
# $Id: //WIFI_SOC/release/SDK_4_1_0_0/source/user/rt2880_app/scripts/ntp.sh#1 $
#
# usage: ntp.sh
#

srv=`nvram_get 2860 NTPServerIP`
sync=`nvram_get 2860 NTPSync`
tz=`nvram_get 2860 TZ`
ntpEnable=`nvram_get 2860 NTPEnable`


killall -q ntpclient
if [ "$ntpEnable" != "1" ]; then
	exit 0
fi

if [ "$srv" = "" ]; then
	exit 0
fi


#if [ "$sync" = "" ]; then
#	sync=1
#elif [ $sync -lt 300 -o $sync -le 0 ]; then
#	sync=1
#fi

sync=`expr $sync \* 3600`

if [ "$tz" = "" ]; then
	tz="UCT_000"
fi

#debug
#echo "serv=$srv"
#echo "sync=$sync"
#echo "tz=$tz"
# 2014-12-11 linsd add for support India timezone
if [ "$tz" = "UCT_00530" ]; then
	echo "GMT-5:30" > /etc/TZ
else	
	echo $tz > /etc/tmpTZ
	sed -e 's#.*_\(-*\)0*\(.*\)#GMT-\1\2#' /etc/tmpTZ > /etc/tmpTZ2
	sed -e 's#\(.*\)--\(.*\)#\1\2#' /etc/tmpTZ2 > /etc/TZ
	rm -rf /etc/tmpTZ
	rm -rf /etc/tmpTZ2
fi

ntpclient -s -c 0 -h $srv -i $sync &

