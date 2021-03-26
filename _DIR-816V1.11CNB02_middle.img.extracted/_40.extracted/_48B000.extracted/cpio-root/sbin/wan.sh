#!/bin/sh
#
# $Id: //WIFI_SOC/release/SDK_4_1_0_0/source/user/rt2880_app/scripts/wan.sh#1 $
#
# usage: wan.sh
#

echo "[wan.sh]: info"
. /sbin/global.sh

# stop all
#killall -q syslogd

killall -q udhcpc
killall -q pppd
killall -q l2tpd
killall -q openl2tpd
killall -q dhcpplus


#linsd add for internet led 
gpio l 40 0 4000 1 1 4000
opmode=`nvram_get 2860 OperationMode`
if [ "$opmode" = "1" -o "$opmode" = "2" ]; then
	nat.sh
fi

#set hw_nat
hw_nat.sh

echo "[wan.sh]:$1"

#clean setting
rm /etc/resolv.conf -rf
rm /etc/options.pptp -rf
rm /etc/options.pppoe -rf
rm /etc/options.pppoed -rf
rm /etc/openl2tpd.conf -rf

if [ "$wanmode" = "PPPOE" -o "$wanmode" = "L2TP" -o "$wanmode" = "PPTP" ]; then
	ifconfig eth2.2 mtu 1500
	ifconfig eth2.2 0.0.0.0
	sleep 5
	i=5;
else
	i=0
fi

while [ "`ps | grep "pppd"|grep -v "grep"|cut -b 27-30`" = "pppd" ]
do
	i=`expr $i + 1` 
	if [ $i -eq 10 ]  ; then
		break
	fi
	sleep 1
done
echo "[wan.sh]wait for pppd $i second."

clone_en=`nvram_get 2860 macCloneEnabled`
clone_mac=`nvram_get 2860 macCloneMac`
#MAC Clone: bridge mode doesn't support MAC Clone
if [ "$opmode" != "0" -a "$opmode" != "3" -a "$clone_en" != "0" ]; then
	ifconfig $wan_if down
	if [ "$opmode" = "2" -a "$CONFIG_RT2860V2_STA" == "m" ]; then
		rmmod rt2860v2_sta_net
		rmmod rt2860v2_sta
		rmmod rt2860v2_sta_util

		insmod -q rt2860v2_sta_util
		insmod -q rt2860v2_sta mac=$clone_mac
		insmod -q rt2860v2_sta_net
	else
		ifconfig $wan_if hw ether $clone_mac
	fi
	ifconfig $wan_if up
fi

if [ "$wanmode" = "STATIC" -o "$opmode" = "0" -o "$opmode" = "3" ]; then
	#always treat bridge mode having static wan connection
	ip=`nvram_get 2860 wan_ipaddr`
	nm=`nvram_get 2860 wan_netmask`
	gw=`nvram_get 2860 wan_gateway`
	pd=`nvram_get 2860 wan_primary_dns`
	sd=`nvram_get 2860 wan_secondary_dns`
	#dns relay
    dnsRelay=`nvram_get 2860 dnsRelayEN`
	
	#lan and wan ip should not be the same except in bridge mode
	if [ "$opmode" != "0" -a "$opmode" != "3" ]; then
		lan_ip=`nvram_get 2860 lan_ipaddr`
		if [ "$ip" = "$lan_ip" ]; then
			echo "wan.sh: warning: WAN's IP address is set identical to LAN"
			exit 0
		fi
	else
		#use lan's ip address instead
		ip=`nvram_get 2860 lan_ipaddr`
		nm=`nvram_get 2860 lan_netmask`
	fi
	ifconfig $wan_if $ip netmask $nm
	route del default
	if [ "$gw" != "" ]; then
	route add $gw dev $wan_if
	route add default gw $gw
	fi

	wan_link=`cat /proc/mt7620/port_status |grep Port0 | cut -d ' ' -f 2`
	if [ "$wan_link" = "LinkUp" ]; then
		gpio l 40 4000 0 1 1 4000
	fi
	
	mtu=`nvram_get 2860 wan_mtu`
	# mtu
	if [ "$mtu" != "" ]; then
	ifconfig $wan_if mtu $mtu
	fi
	config-dns.sh $pd $sd
	
	 #set dns relay
	if [ "$dnsRelay" = "1" ]; then
  	  ./sbin/lan.sh
	fi
elif [ "$wanmode" = "DHCP" ]; then
	mtu=`nvram_get 2860 wan_mtu`
	# mtu
	if [ "$mtu" != "" ]; then
	ifconfig $wan_if mtu $mtu
	fi
	hn=`nvram_get 2860 wan_dhcp_hn`
	if [ "$hn" != "" ]; then
		udhcpc -i $wan_if -h $hn -s /sbin/udhcpc.sh -p /var/run/udhcpc.pid -f &
	else
		udhcpc -i $wan_if -s /sbin/udhcpc.sh -p /var/run/udhcpc.pid -f &
	fi
	autodns=`nvram_get 2860 wan_dhcp_autodns`
	pd=`nvram_get 2860 wan_dhcp_primary_dns`
	sd=`nvram_get 2860 wan_dhcp_secondary_dns`
	if [ "$autodns" != "1" ]; then
		config-dns.sh $pd $sd
	fi
elif [ "$wanmode" = "PPPOE" ]; then
	u=`nvram_get 2860 wan_pppoe_user`
	pw=`nvram_get 2860 wan_pppoe_pass`
	pppoe_opmode=`nvram_get 2860 wan_pppoe_opmode`
	netsniper_en=`nvram_get 2860 wan_netsniper_enable`
	if [ "$pppoe_opmode" = "" ]; then
		echo "pppoecd $wan_if -u $u -p $pw"
		pppoecd $wan_if -u "$u" -p "$pw"
	else
		pppoe_optime=`nvram_get 2860 wan_pppoe_optime`
		config-pppoe.sh $u $pw $wan_if $pppoe_opmode $pppoe_optime
	fi
	if [ "$netsniper_en" = "1" ];then
		echo wan 3 >  /proc/ipport_netspy
#		iptables -t mangle -A POSTROUTING -o ppp0 -j TTL --ttl-set 128
	else
		echo wan 0 >  /proc/ipport_netspy
#		iptables -t mangle -D POSTROUTING -o ppp0 -j TTL --ttl-set 128
	fi
	autodns=`nvram_get 2860 wan_pppoe_autodns`
	pd=`nvram_get 2860 wan_pppoe_primary_dns`
	sd=`nvram_get 2860 wan_pppoe_secondary_dns`
	if [ "$autodns" != "1" ]; then
		config-dns.sh $pd $sd
	fi
elif [ "$wanmode" = "RUPPPOE" ]; then
	type=`nvram_get 2860 wan_secondwan_type`
	if [ "$type" = "0" ]; then
		ip=`nvram_get 2860 wan_secondwan_ip`
		nm=`nvram_get 2860 wan_secondwan_netmask`
		ifconfig $wan_if $ip netmask $nm
	else
		udhcpc -i $wan_if -s /sbin/udhcpc.sh -p /var/run/udhcpc.pid -f &
	fi
	u=`nvram_get 2860 wan_pppoe_user`
	pw=`nvram_get 2860 wan_pppoe_pass`
	pppoe_opmode=`nvram_get 2860 wan_pppoe_opmode`
	netsniper_en=`nvram_get 2860 wan_netsniper_enable`
	if [ "$pppoe_opmode" = "" ]; then
		echo "pppoecd $wan_if -u $u -p $pw"
		pppoecd $wan_if -u "$u" -p "$pw"
	else
		pppoe_optime=`nvram_get 2860 wan_pppoe_optime`
		config-pppoe.sh $u $pw $wan_if $pppoe_opmode $pppoe_optime
	fi
	if [ "$netsniper_en" = "1" ];then
		echo wan 3 >  /proc/ipport_netspy
#		iptables -t mangle -A POSTROUTING -o ppp0 -j TTL --ttl-set 128
	else
		echo wan 0 >  /proc/ipport_netspy
#		iptables -t mangle -D POSTROUTING -o ppp0 -j TTL --ttl-set 128
	fi
	autodns=`nvram_get 2860 wan_pppoe_autodns`
	pd=`nvram_get 2860 wan_pppoe_primary_dns`
	sd=`nvram_get 2860 wan_pppoe_secondary_dns`
	if [ "$autodns" != "1" ]; then
		config-dns.sh $pd $sd
	fi	
elif [ "$wanmode" = "L2TP" ]; then
	mode=`nvram_get 2860 wan_l2tp_mode`
	if [ "$mode" = "0" ]; then
		ip=`nvram_get 2860 wan_l2tp_ip`
		nm=`nvram_get 2860 wan_l2tp_netmask`
		gw=`nvram_get 2860 wan_l2tp_gateway`
		if [ "$gw" = "" ]; then
			gw="0.0.0.0"
		fi
		config-l2tp.sh static $wan_if $ip $nm $gw
	else
		config-l2tp.sh dhcp $wan_if 
	fi
elif [ "$wanmode" = "PPTP" ]; then
	mode=`nvram_get 2860 wan_pptp_mode`
	if [ "$mode" = "0" ]; then
		ip=`nvram_get 2860 wan_pptp_ip`
		nm=`nvram_get 2860 wan_pptp_netmask`
		gw=`nvram_get 2860 wan_pptp_gateway`
		if [ "$gw" = "" ]; then
			gw="0.0.0.0"
		fi
		config-pptp.sh static $wan_if $ip $nm $gw
	else
		config-pptp.sh dhcp $wan_if
	fi
elif [ "$wanmode" = "DHCPPLUS" ]; then
	u=`nvram_get 2860 dhcpplususer`
	pw=`nvram_get 2860 dhcppluspass`
	mtu=`nvram_get 2860 wan_mtu`
	sIp=`nvram_get 2860 dhcpplus_server`
	linSty=`nvram_get 2860 dhcplinkSty`
	# mtu
	if [ "$mtu" != "" ]; then
	ifconfig $wan_if mtu $mtu
	fi
	#if [ "$linSty" = "2" ]; then
	dhcpplus $u $pw $sIp &
	#fi
elif [ "$wanmode" = "3G" ]; then
	autoconn3G.sh connect &
else
	echo "wan.sh: unknown wan connection type: $wanmode"
	exit 1
fi


#setting firewall
#firewall_init.sh delete
#firewall_init.sh init
