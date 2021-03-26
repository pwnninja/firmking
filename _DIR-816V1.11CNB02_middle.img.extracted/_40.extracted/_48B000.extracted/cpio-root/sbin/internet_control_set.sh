#!/bin/sh
#
#
#

IPPORT_FILTER_CHAIN="macipport_filter"

mac_ip_port_filter_init()
{
	iptables -t filter -N $IPPORT_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -A FORWARD -j $IPPORT_FILTER_CHAIN 1>/dev/null 2>&1
}

mac_ip_port_filter_delete()
{
	iptables -t filter -D FORWARD -j $IPPORT_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -F $IPPORT_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -X $IPPORT_FILTER_CHAIN 1>/dev/null 2>&1
}

mac_ip_port_filter_flush()
{
	iptables -F $IPPORT_FILTER_CHAIN 1>/dev/null 2>&1
}

mac_ip_port_filter_run()
{
	FILE_NAME="/var/iptables_filter_rules.sh"

	if [ -x "/var/iptables_filter_rules.sh" ];then
        	$FILE_NAME
	else
        	echo $FILE_NAME is not exist or not exec ablity!!!
	fi
}

case $1 in
init)
mac_ip_port_filter_init
mac_ip_port_filter_run
;;
run)
mac_ip_port_filter_flush
mac_ip_port_filter_run
;;
delete)
mac_ip_port_filter_delete
;;
esac
