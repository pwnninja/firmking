#!/bin/sh
#
# usage: wan.sh
#

echo "[hw_nat.sh]: info"

opmode=`nvram_get 2860 OperationMode`
wanmode=`nvram_get 2860 wanConnectionMode`
HWNAT=`nvram_get 2860 hwnatEnabled`
QOSENABLE=`nvram_get ip_ctl_en`

#set hw_nat
rmmod hw_nat
if [ "$HWNAT" = "1" ]; then
	if [ "$opmode" = "1" -o "$opmode" = "2" ]; then
		if [ "$wanmode" != "L2TP" -a "$wanmode" != "PPTP" ]; then
			if [ "$QOSENABLE" = "0" -o "$QOSENABLE" = "" ]; then
				#insmod -q hw_nat
				insmod /lib/modules/2.6.36/kernel/net/nat/hw_nat/hw_nat.ko
			fi
		fi
	fi
fi
