#!/bin/sh
#
#
#
#

. /sbin/global.sh

PORT_TRIGGER_NAT_CHAIN="port_trigger"
PORT_TRIGGER_CHAIN="port_trigger"

wan_if=$wan_ppp_if

rules=`nvram_get 2860 PortTriggerRules`
#端口触发链的创建
port_trigger_chain_init()
{

	iptables -t nat -N $PORT_TRIGGER_NAT_CHAIN 1>/dev/null 2>&1
	iptables -t nat -A PREROUTING -j $PORT_TRIGGER_NAT_CHAIN 1>/dev/null 2>&1

	iptables -t filter -N $PORT_TRIGGER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -A FORWARD -j $PORT_TRIGGER_CHAIN 1>/dev/null 2>&1
}

#端口触发链的清除
port_trigger_chain_delete()
{
	iptables -t filter -D FORWARD -j $PORT_TRIGGER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -F $PORT_TRIGGER_CHAIN
	iptables -t filter -X $PORT_TRIGGER_CHAIN 1>/dev/null 2>&1

	iptables -t nat -D PREROUTING -j $PORT_TRIGGER_NAT_CHAIN 1>/dev/null 2>&1
	iptables -t nat -F $PORT_TRIGGER_NAT_CHAIN
	iptables -t nat -X $PORT_TRIGGER_NAT_CHAIN 1>/dev/null 2>&1
}

#清空链中的规则
port_trigger_chain_flush()
{
	iptables -t nat -F $PORT_TRIGGER_NAT_CHAIN
	iptables -t filter -F $PORT_TRIGGER_CHAIN
#	iptables -t nat -F $PORT_TRIGGER_NAT_CHAIN
}

#端口触发规则添加---即在链中添加转发和过滤规则
port_trigger_chain_run()
{

if [ "$rules" = "" ];then
	echo "rule null!!!!"
	port_trigger_chain_flush
	return
fi

OLD_IFS="$IFS"
IFS=";"
arr=$rules
for s in $arr
do
enable=`echo $s | cut -d '|' -f 2`
str=`echo $s | cut -d '|' -f 3`
triports=`echo $str | cut -d ',' -f 1`
triporte=`echo $str | cut -d ',' -f 2`
triproto=`echo $str | cut -d ',' -f 3`
openports=`echo $str | cut -d ',' -f 4`
openporte=`echo $str | cut -d ',' -f 5`
openproto=`echo $str | cut -d ',' -f 6`
echo $enable
echo $str
echo "<<<<<<<<<<<<<<<<<<<<<<"
echo $triports
echo $triporte
echo $triproto
echo $openports
echo $openporte
echo $openproto

case $triproto in
1)
triprotocol="tcp"
;;
2)
triprotocol="udp"
;;
esac

case $openproto in
1)
forwardproto="tcp"
;;
2)
forwardproto="udp"
;;
esac

if [ "$enable" = "1" ] && [ "$triports" != "" ] && [ "$triporte" != "" ] && [ "$triproto" != "" ] && [ "$openports" != "" ] && [ "$openporte" != "" ] && [ "$openproto" != "" ];then
#	iptables -t nat -D $PORT_TRIGGER_NAT_CHAIN -j TRIGGER
#	iptables -t nat -A $PORT_TRIGGER_NAT_CHAIN -j TRIGGER --trigger-type dnat
	if [ "$triproto" != "3" ] && [ "$openproto" != "3" ];then
	iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto $triprotocol --trigger-match $triports-$triporte --trigger-rproto $forwardproto --trigger-relate $openports-$openporte
	iptables -t nat -A $PORT_TRIGGER_NAT_CHAIN -p $forwardproto --dport $openports:$openporte -j TRIGGER --trigger-type dnat
    	elif [ "$triproto" = "3" ] && [ "$openproto" = "3" ];then
	    iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto tcp --trigger-match $triports-$triporte --trigger-rproto tcp --trigger-relate $openports-$openporte
	    iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto tcp --trigger-match $triports-$triporte --trigger-rproto udp --trigger-relate $openports-$openporte
	    iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto udp --trigger-match $triports-$triporte --trigger-rproto tcp --trigger-relate $openports-$openporte
	    iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto udp --trigger-match $triports-$triporte --trigger-rproto udp --trigger-relate $openports-$openporte
	iptables -t nat -A $PORT_TRIGGER_NAT_CHAIN -p tcp --dport $openports:$openporte -j TRIGGER --trigger-type dnat
	iptables -t nat -A $PORT_TRIGGER_NAT_CHAIN -p udp --dport $openports:$openporte -j TRIGGER --trigger-type dnat
	elif [ "$triproto" = "3" ];then
	iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto tcp --trigger-match $triports-$triporte --trigger-rproto $forwardproto --trigger-relate $openports-$openporte
	iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto udp --trigger-match $triports-$triporte --trigger-rproto $forwardproto --trigger-relate $openports-$openporte
	iptables -t nat -A $PORT_TRIGGER_NAT_CHAIN -p $forwardproto --dport $openports:$openporte -j TRIGGER --trigger-type dnat
	elif [ "$openproto" = "3" ];then
	iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto $triprotocol --trigger-match $triports-$triporte --trigger-rproto tcp --trigger-relate $openports-$openporte
        iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto $triprotocol --trigger-match $triports-$triporte --trigger-rproto udp --trigger-relate $openports-$openporte
	iptables -t nat -A $PORT_TRIGGER_NAT_CHAIN -p tcp --dport $openports:$openporte -j TRIGGER --trigger-type dnat
	iptables -t nat -A $PORT_TRIGGER_NAT_CHAIN -p udp --dport $openports:$openporte -j TRIGGER --trigger-type dnat
	else
		echo "this rule open protocol error!!!"
	fi
else
	if [ "$enable" = "0" ];then
	echo "this rule is seted stop!!!"
	else
	echo "this rule has some error,e.m port is seted 0!!!"
	fi
fi
done
IFS="$OLD_IFS"
}

if [ "$1" = "" ];then
	if [ "$rules" = "" ];then
		exit 1
	else
		var=run
	fi
else
	var=$1
fi

case $var in 
init)
port_trigger_chain_init
port_trigger_chain_run
;;
run)
port_trigger_chain_flush
port_trigger_chain_run
;;
delete)
port_trigger_chain_delete
;;
esac
