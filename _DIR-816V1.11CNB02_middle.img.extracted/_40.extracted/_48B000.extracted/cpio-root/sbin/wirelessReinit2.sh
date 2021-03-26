#!/bin/sh
#
# name: wirelessReinit2.sh
# author: lanql 
# date: 2013-04-19

guestEnable=`nvram_get 2860 ssidenable1`
apCliEnable=`nvram_get 2860 ApCliEnable`
radioOff=`nvram_get 2860 RadioOff`
opmode=`nvram_get 2860 OperationMode`

ifRaxWdsxApclixDown()
{
	if [ "`brctl show | sed -n '/apcli0$/p'`" != "" ]; then
		brctl delif br0 apcli0
		ifconfig apcli0 down
	fi

	if [ "`brctl show | sed -n '/ra1$/p'`" != "" ]; then
		brctl delif br0 ra1
		ifconfig ra1 down
	fi
	
	brctl delif br0 ra0
	ifconfig ra0 down
}

ifRaxWdsxApclixUp()
{
	if [ "$radioOff" = "0" ]; then
		ralink_init make_wireless_config rt2860
		
		ifconfig ra0 up
		brctl addif br0 ra0
		
		if [ "$guestEnable" = "1" ]; then
			ifconfig ra1 up
			brctl addif br0 ra1
		fi
		
		if [ "$apCliEnable" = "1" ]; then
			ifconfig apcli0 up
			brctl addif br0 apcli0
		fi
	fi
}

echo "====== wirelessReinit2.4.sh ======"
echo "radioOff=$radioOff"
echo "opmode=$opmode"
echo "guestEnable=$guestEnable"
echo "apCliEnable_2.4G=$apCliEnable"
echo "================================"
ifRaxWdsxApclixDown
ifRaxWdsxApclixUp
