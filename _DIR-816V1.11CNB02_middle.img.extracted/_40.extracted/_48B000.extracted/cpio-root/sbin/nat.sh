#!/bin/sh
#
# $Id: //WIFI_SOC/release/SDK_4_1_0_0/source/user/rt2880_app/scripts/nat.sh#1 $
#
# usage: nat.sh
#

echo "[nat.sh]: info"

. /sbin/config.sh
. /sbin/global.sh


lan_ip=`nvram_get 2860 lan_ipaddr`
nat_en=`nvram_get 2860 natEnabled`
tcp_timeout=`nvram_get 2860 TcpTimeout`
udp_timeout=`nvram_get 2860 UdpTimeout`
lan_mask=`nvram_get 2860 lan_netmask`
           
iptables -t nat -F POSTROUTING

getMaskBit()
{
  #lan_mask="255.255.254.0"
  maskbit=0;
  mask0=`echo $lan_mask | cut -f1 -d'.'`
  mask1=`echo $lan_mask | cut -f2 -d'.'`
  mask2=`echo $lan_mask | cut -f3 -d'.'`
  mask3=`echo $lan_mask | cut -f4 -d'.'`
  


 for i in 0 1 2 3  ;  do 
     
	if [ $i = 0 ] ;then
	   varMask=$mask0
	fi
	if [ $i = 1 ] ;then
	   varMask=$mask1
	fi
	if [ $i = 2 ] ;then
	   varMask=$mask2
	fi
	if [ $i = 3 ] ;then
	   varMask=$mask3
	fi
	#echo "var=$varMask"
    case "$varMask" in
	"0")
		maskbit=`expr $maskbit + 0`
		;;
	"128")
		maskbit=`expr $maskbit + 1`
		;;
	"192")
		maskbit=`expr $maskbit + 2`
		;;
	"224")
		maskbit=`expr $maskbit + 3`
		;;
	"240")
		maskbit=`expr $maskbit + 4`
		;;
	"248")
		maskbit=`expr $maskbit + 5`
		;;
	"252")
		maskbit=`expr $maskbit + 6`
		;;
	"254")
		maskbit=`expr $maskbit + 7`
		;;
	"255")
	    maskbit=`expr $maskbit + 8`
		;;
	esac
         
   done
   
   #echo "maskbit=$maskbit"
}



if [ "$nat_en" = "1" ]; then
	if [ "$CONFIG_NF_CONNTRACK_SUPPORT" = "1" ]; then
		if [ "$udp_timeout" = "" ]; then
			echo 180 > /proc/sys/net/netfilter/nf_conntrack_udp_timeout
		else	
			echo "$udp_timeout" > /proc/sys/net/netfilter/nf_conntrack_udp_timeout
		fi

		if [ "$tcp_timeout" = "" ]; then
			echo 180 >  /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_established
		else
			echo "$tcp_timeout" >  /proc/sys/net/netfilter/nf_conntrack_tcp_timeout_established
		fi
	else
		if [ "$udp_timeout" = "" ]; then
			echo 180 > /proc/sys/net/ipv4/netfilter/ip_conntrack_udp_timeout
		else	
			echo "$udp_timeout" > /proc/sys/net/ipv4/netfilter/ip_conntrack_udp_timeout
		fi

		if [ "$tcp_timeout" = "" ]; then
			echo 180 > /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_timeout_established
		else
			echo "$tcp_timeout" > /proc/sys/net/ipv4/netfilter/ip_conntrack_tcp_timeout_established
		fi
	fi
	if [ "$wanmode" = "RUPPPOE" -o "$wanmode" = "PPPOE" -o "$wanmode" = "L2TP" -o "$wanmode" = "PPTP" -o "$wanmode" = "3G" ]; then
		wan_if="ppp0"
	fi
	
	#获取mask的比特位数
	getMaskBit
	
    if [ "$maskbit" = "0" ]; then
	     maskbit=`expr $maskbit + 24`
		 #echo "113 maskbit=$maskbit"
	fi
	
	#echo "maskbit=$maskbit"
	
	iptables -t nat -A POSTROUTING -s $lan_ip/$maskbit -o $wan_if -j MASQUERADE
	#修改原来即使pptp/l2tp账号错误也能上网问题
	#if [ "$wanmode" = "L2TP" -o "$wanmode" = "PPTP" -o "$wanmode" = "RUPPPOE"  ]; then
	if [ "$wanmode" = "RUPPPOE"  ]; then
		iptables -t nat -A POSTROUTING -s $lan_ip/$maskbit -o eth2.2 -j MASQUERADE
	fi
fi

