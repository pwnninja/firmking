#!/bin/sh
# 2014-09-01 
# linsd add for config wan port link speed
# usage config-wanport.sh 
#
. /sbin/config.sh
. /sbin/global.sh

wan_speed=`nvram_get 2860 wan_speed`

# argv 1 is empty
#if [ "$1" = "" ]; then
#  usage
#fi



# argv 2 is empty
if [ "$wan_speed" = "" ]; then
  echo "wan_speed not set"
fi
echo "wan_speed  $wan_speed"
# 0-auto 1-10m 2-100m
if [ "$wan_speed" = "1" ]; then
		mii_mgr -s -p 0 -r 4 -v 0461
		mii_mgr -s -p 0 -r 0 -v 1240
		sleep 5
	elif [ "$wan_speed" = "2" ]; then
		mii_mgr -s -p 0 -r 4 -v 0581
		mii_mgr -s -p 0 -r 0 -v 1240
		sleep 5
	elif [ "$wan_speed" = "0" ]; then	
		mii_mgr -s -p 0 -r 4 -v 05e1
		mii_mgr -s -p 0 -r 0 -v 3300
		sleep 5
fi


