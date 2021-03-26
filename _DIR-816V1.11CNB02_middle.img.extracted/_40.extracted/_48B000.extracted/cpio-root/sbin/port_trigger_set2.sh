#!/bin/sh
#
#
#
#

. /sbin/global.sh

PORT_TRIGGER_NAT_CHAIN="port_trigger"
PORT_TRIGGER_CHAIN="port_trigger"

wan_if=$wan_ppp_if

port_trigger_en=`nvram_get 2860 PortTriggerEnable`
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

#Dialpad|1|7175,7175,1,51200,51201,1|7175,7175,1,51210,51210,1|;Quicktime|1|554,554,2,6970,6999,3|
#不需要单条规则使能（先保留）,使用全局使能

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
numField=`echo $s | sed 's/./&\n/g' | grep -c "|"`
num_a=`expr $numField - 1`
#enable=`echo $s | cut -d '|' -f 2`
#echo $enable

	#for(j=3; j<=$numField; j++)
	#for j in `seq $numField` 
	for j in 3 4 5 6 7 8 9 10  
	do   
		#if [ "$j" -gt "3" ];then
			str=`echo $s | cut -d '|' -f $j`
		if [ "$str" != "" ];then
			triports=`echo $str | cut -d ',' -f 1`
			triporte=`echo $str | cut -d ',' -f 2`
			triproto=`echo $str | cut -d ',' -f 3`
			openports=`echo $str | cut -d ',' -f 4`
			openporte=`echo $str | cut -d ',' -f 5`
			openproto=`echo $str | cut -d ',' -f 6`
			echo
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
			
			if [ "$triports" != "" ] && [ "$triporte" != "" ] && [ "$triproto" != "" ] && [ "$openports" != "" ] && [ "$openporte" != "" ] && [ "$openproto" != "" ];then
			#	iptables -t nat -D $PORT_TRIGGER_NAT_CHAIN -j TRIGGER
			#	iptables -t nat -A $PORT_TRIGGER_NAT_CHAIN -j TRIGGER --trigger-type dnat
				if [ "$triproto" != "3" ] && [ "$openproto" != "3" ];then
					iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto $triprotocol --trigger-match $triports-$triporte --trigger-rproto $forwardproto --trigger-relate $openports-$openporte
					iptables -t nat -A $PORT_TRIGGER_NAT_CHAIN -i $wan_if -p $forwardproto --dport $openports:$openporte -j TRIGGER --trigger-type dnat
				elif [ "$triproto" = "3" ] && [ "$openproto" = "3" ];then
					iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto tcp --trigger-match $triports-$triporte --trigger-rproto tcp --trigger-relate $openports-$openporte
					iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto tcp --trigger-match $triports-$triporte --trigger-rproto udp --trigger-relate $openports-$openporte
					iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto udp --trigger-match $triports-$triporte --trigger-rproto tcp --trigger-relate $openports-$openporte
					iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto udp --trigger-match $triports-$triporte --trigger-rproto udp --trigger-relate $openports-$openporte
					iptables -t nat -A $PORT_TRIGGER_NAT_CHAIN  -i $wan_if -p tcp --dport $openports:$openporte -j TRIGGER --trigger-type dnat
					iptables -t nat -A $PORT_TRIGGER_NAT_CHAIN  -i $wan_if -p udp --dport $openports:$openporte -j TRIGGER --trigger-type dnat
				elif [ "$triproto" = "3" ];then
					iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto tcp --trigger-match $triports-$triporte --trigger-rproto $forwardproto --trigger-relate $openports-$openporte
					iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto udp --trigger-match $triports-$triporte --trigger-rproto $forwardproto --trigger-relate $openports-$openporte
					iptables -t nat -A $PORT_TRIGGER_NAT_CHAIN -i $wan_if -p $forwardproto --dport $openports:$openporte -j TRIGGER --trigger-type dnat
				elif [ "$openproto" = "3" ];then
					iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto $triprotocol --trigger-match $triports-$triporte --trigger-rproto tcp --trigger-relate $openports-$openporte
					iptables -t filter -A $PORT_TRIGGER_CHAIN -o $wan_if -m iprange --src-range 0.0.0.0-255.255.255.255 -j TRIGGER --trigger-type out --trigger-mproto $triprotocol --trigger-match $triports-$triporte --trigger-rproto udp --trigger-relate $openports-$openporte
					iptables -t nat -A $PORT_TRIGGER_NAT_CHAIN -i $wan_if -p tcp --dport $openports:$openporte -j TRIGGER --trigger-type dnat
					iptables -t nat -A $PORT_TRIGGER_NAT_CHAIN -i $wan_if -p udp --dport $openports:$openporte -j TRIGGER --trigger-type dnat
				else
					echo "this rule open protocol error!!!"
				fi
			else
			#	if [ "$enable" = "0" ];then
			#	echo "this rule is seted stop!!!"
			#	else
				echo "this rule has some error,e.m port is seted 0!!!"
			#	fi
		fi
		
		fi			
		#fi	
		done	

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
if [ "$port_trigger_en" = "1" ];then
	port_trigger_chain_flush
	port_trigger_chain_run
else
	port_trigger_chain_flush
fi
;;
delete)
port_trigger_chain_delete
;;
esac
