#! /bin/sh
#
#
# usage: portal_manage.sh init|add|flush|delete
#

. /sbin/config.sh
. /sbin/global.sh

s_lan_if=$lan_if

NAT_PORTAL_M_PRE="PORTAL_M_PRE"
PORTAL_IPADDR_FILE="/var/tmp/portal_ipaddr"

lan_ip=`nvram_get 2860 lan_ipaddr`
redirect_ip=`nvram_get 2860 portal_addr`
wan_conn_mode=`nvram_get 2860 wanConnectionMode`
lan_netmask=`nvram_get 2860 lan_netmask`
portal_manage_enable=`nvram_get 2860 portal_manage_enable`

portal_m_init()
{
	iptables -t nat -N $NAT_PORTAL_M_PRE
	iptables -t nat -A PREROUTING -j $NAT_PORTAL_M_PRE
	#ifconfig br0:0 $redirect_ip netmask $lan_netmask up
}

portal_m_delete()
{
	iptables -t nat -F $NAT_PORTAL_M_PRE
	iptables -t nat -D PREROUTING -j $NAT_PORTAL_M_PRE
	iptables -t nat -X $NAT_PORTAL_M_PRE
	#ifconfig br0:0 down
}

portal_m_addrule()
{
	iptables -t nat -A $NAT_PORTAL_M_PRE -i $s_lan_if ! -d $lan_ip -p tcp --dport 80 -j DNAT --to $lan_ip:80
	iptables -t nat -A $NAT_PORTAL_M_PRE -i $s_lan_if ! -d $lan_ip -p udp --dport 53 -j DNAT --to $lan_ip:53
	echo on > /proc/pm_devurl
	echo PC_url=$lan_ip/redirect.asp > /proc/pm_devurl
	echo LAN_ip=$lan_ip > /proc/pm_devurl
	echo $redirect_ip > $PORTAL_IPADDR_FILE
	killall -SIGUSR1 dnsmasq
}

portal_m_flushrule()
{
	iptables -t nat -F $NAT_PORTAL_M_PRE
	echo PC_url= > /proc/pm_devurl
	echo off > /proc/pm_devurl
	rm -rf $PORTAL_IPADDR_FILE
	killall -SIGUSR2 dnsmasq
}

echo "<<<<<<<<<<<<<<<< PORTAL MANAGER  >>>>>>>>>>>>>>>>>>>>"
if [ "$portal_manage_enable" != "1" ];then
	echo "not enable portal manage!!!"
	exit 1
fi

if [ "$1" = "" ];then
	echo "portal_manage.sh init|add|flush|delete"
else
        var=$1
fi
if [ "$wan_conn_mode" != "STATIC" ];then
	case $var in
	init)
		portal_m_init
		;;
	add)
		portal_m_addrule
		;;
	flush)
		portal_m_flushrule
		;;
	delete)
		portal_m_delete
		;;
	esac
else
	portal_m_flushrule
	#ifconfig br0:0 down
fi
