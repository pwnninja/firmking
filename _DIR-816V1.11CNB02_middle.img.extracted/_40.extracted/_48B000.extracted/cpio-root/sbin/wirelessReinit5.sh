#!/bin/sh
#
# name: wirelessReinit5.sh
# author: lanql 
# date: 2013-04-19

guestEnable=`nvram_get rtdev ssidenable1`
apCliEnable=`nvram_get rtdev ApCliEnable`
radioOff=`nvram_get rtdev RadioOff`
opmode=`nvram_get 2860 OperationMode`

ifRaixApcliixDown()
{	
	if [ "`brctl show | sed -n '/apclii0$/p'`" != "" ]; then
		brctl delif br0 apclii0
		ifconfig apclii0 down
	fi
	
	if [ "`brctl show | sed -n '/rai1$/p'`" != "" ]; then
		brctl delif br0 rai1
		ifconfig rai1 down
	fi
	
	brctl delif br0 rai0
	ifconfig rai0 down
}

ifRaixApcliixUp()
{
	if [ "$radioOff" = "0" ]; then
		ralink_init make_wireless_config rtdev
		
		ifconfig rai0 up
		brctl addif br0 rai0
		
		if [ "$guestEnable" = "1" ]; then
			ifconfig rai1 up
			brctl addif br0 rai1
		fi
		
		if [ "$apCliEnable" = "1" ]; then
			ifconfig apclii0 up
			brctl addif br0 apclii0
		fi
	fi
}

echo "====== wirelessReinit5.sh ======"
echo "radioOff=$radioOff"
echo "opmode=$opmode"
echo "guestEnable=$guestEnable"
echo "apCliEnable_5G=$apCliEnable"
echo "================================"
ifRaixApcliixDown
ifRaixApcliixUp
