#!/bin/sh
. /sbin/config.sh
. /sbin/global.sh

case $1 in
init)

mode=`nvram_get 2860 OperationMode`
if [ "$mode" != "1" ];then
	exit 1
fi

#set tcp mss
iptables -t filter -D FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
iptables -t filter -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
iptables -t nat -N MINIUPNPD
iptables -t filter -N MINIUPNPD
#iptables -t nat -D PREROUTING -j MINIUPNPD
#iptables -t filter -D FORWARD -j MINIUPNPD
#iptables -t nat -A PREROUTING -j MINIUPNPD
#iptables -t filter -A FORWARD -j MINIUPNPD
iptables -t nat -D PREROUTING -i $wan_if -j MINIUPNPD
iptables -t nat -D PREROUTING -i $wan_ppp_if -j MINIUPNPD
iptables -t filter -D FORWARD -i $wan_if  -o !$wan_if -j MINIUPNPD 
iptables -t filter -D FORWARD -i $wan_ppp_if  -o !$wan_ppp_if -j MINIUPNPD 
iptables -t nat -A PREROUTING -i $wan_ppp_if -j MINIUPNPD
iptables -t filter -A FORWARD -i $wan_ppp_if -o !$wan_ppp_if -j MINIUPNPD
#spi_dos_anti_set.sh dos_init
#lan_web_filter.sh init
web_url_filter.sh init
#internet_control_set.sh init
#port_trigger_set.sh init
port_trigger_set2.sh init
#virtual_server_dmz_set.sh init
virtual_server_dmz_set2.sh init
#spi_dos_anti_set.sh spi_init
alg_vpn_set.sh init
acl_set.sh init
;;
delete)
mode=`nvram_get 2860 OperationMode`
if [ "$mode" != "1" ];then
	exit 1
fi
#spi_dos_anti_set.sh delete
virtual_server_dmz_set2.sh delete
port_trigger_set2.sh delete
#internet_control_set.sh delete
web_url_filter.sh delete
#lan_web_filter.sh delete
alg_vpn_set.sh delete
acl_set.sh delete
;;
esac
