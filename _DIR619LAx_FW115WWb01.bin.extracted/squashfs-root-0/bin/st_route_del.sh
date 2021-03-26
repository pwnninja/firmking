#!/bin/sh

eval `flash get STATICROUTE_ENABLED`
eval `flash get STATICROUTE_TBL_NUM`
eval `flash get WAN_DHCP`

if [ $STATICROUTE_TBL_NUM -gt 0 ] && [ $STATICROUTE_ENABLED -gt 0 ];
then
  num=1
  while [ $num -le $STATICROUTE_TBL_NUM ];
  do
    STATICROUTE_TBL=`flash get STATICROUTE_TBL | grep STATICROUTE_TBL$num=`
    tmp=`echo $STATICROUTE_TBL | cut -f2 -d=`

    enabled=`echo $tmp | cut -f1 -d,`
    dstIp=`echo $tmp | cut -f2 -d,`
    netmask=`echo $tmp | cut -f3 -d,`
    gateway=`echo $tmp | cut -f4 -d,`
    mr=`echo $tmp | cut -f5 -d,`
    iface=`echo $tmp | cut -f6 -d,`

if [ "$enabled" = "1" ]; then
    #route del -net $dstIp netmask 255.255.255.255 metric $mr
    if [ $WAN_DHCP = 0 ] || [ $WAN_DHCP = 1 ]; then
        #route del -net $dstIp netmask $netmask gw $gateway 2> /dev/null
        route del -net $dstIp netmask $netmask metric $mr dev eth1 2> /dev/null
    else
    	if [ $iface = '1' ]; then
	    route del -net $dstIp netmask $netmask metric $mr dev ppp0 2> /dev/null
    	else
	    route del -net $dstIp netmask $netmask gw $gateway 2> /dev/null
   	fi
    fi
fi   
    num=`expr $num + 1`
  done
fi

