#!/bin/sh
RU_WAN=$2
eval `flash get STATICROUTE_ENABLED`
eval `flash get STATICROUTE_TBL_NUM`
eval `flash get WAN_DHCP`
pat3="0.0.0.0"
###########get default route entry###############
TMPFILEROUTE=/var/route-test
line=0
route -n | grep "0.0.0.0" > $TMPFILEROUTE
line=`cat $TMPFILEROUTE | wc -l`
num=1
while [ $num -le $line ];
do
	pat0=` head -n $num $TMPFILEROUTE | tail -n 1`
	pat1=`echo $pat0 | cut -f1 -dS`  
	pat2=`echo $pat1 | cut -f1 -d " "`
	if [ $pat2 = '0.0.0.0' ]; then
		pat3=`echo $pat1 | cut -f2 -d " "`
	fi  
	num=`expr $num + 1`
done
rm -f $TMPFILEROUTE
###########################



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
    
    #route add -net $dstIp netmask $netmask gw $gateway metric $mr
    if [ "$RU_WAN" = "" ]; then
    if [ $1 = 'ppp0' ]; then
	    if [ $iface = '1' ]; then
	    	route add -net $dstIp netmask $netmask metric $mr dev $1
	    elif [ $iface = '2' ]; then
	    	if [ $WAN_DHCP = 7 ] || [ $WAN_DHCP = 8 ]; then
	    	route add -net $dstIp netmask $netmask gw $gateway metric $mr dev eth1
	    	fi
	    else
	    	route add -net $dstIp netmask $netmask gw $gateway metric $mr dev br0
	    fi
    else
		    if [ $iface = '0' ]; then
		     	route add -net $dstIp netmask $netmask gw $gateway metric $mr dev br0
		     elif [ $iface = '1' ]; then
		     	if [ $gateway != '0.0.0.0' ]; then
		    		route add -net $dstIp netmask $netmask gw $gateway metric $mr dev $1
		    	else
		    		if [ $pat3 != '0.0.0.0' ]; then
		    			route add -net $dstIp netmask $netmask gw $pat3 metric $mr dev $1
		    		fi
		    	fi
		    fi
	 fi
	    else
		    if [ $iface = '2' ]; then
			    route add -net $dstIp netmask $netmask gw $gateway metric $mr dev eth1
		    fi
		     if [ $iface = '0' ]; then
			    route add -net $dstIp netmask $netmask gw $gateway metric $mr dev br0
			 fi
    fi 
    fi
    num=`expr $num + 1`
  done
fi
