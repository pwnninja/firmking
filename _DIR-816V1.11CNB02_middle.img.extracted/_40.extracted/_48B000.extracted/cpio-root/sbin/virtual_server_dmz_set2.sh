#!/bin/sh
#
#
# usage: virtual_server_dmz.sh init|delete
#

. /sbin/config.sh
. /sbin/global.sh

s_wan_if=$wan_ppp_if
s_lan_if=$lan_if

PORT_FORWARD_CHAIN="port_forward"
PORT_FORWARD_FILTER_CHAIN="port_forward_filter"
PORT_FORWARD_POSTROUTING_CHAIN="port_forward_postrouting"

DMZ_CHAIN="DMZ"
DMZ_FILTER_CHAIN="DMZ_FILTER"
DMZ_POSTROUTING_CHAIN="DMZ_POSTROUTING"

vir_sv_en=`nvram_get 2860 PortForwardEnable`
vir_sv_rules=`nvram_get 2860 PortForwardRules`
dmz_enable=`nvram_get 2860 DMZEnable`

dmz_rules_init()
{
	iptables -t nat -N $DMZ_CHAIN 1>/dev/null 2>&1	
	iptables -t nat -A PREROUTING  -j $DMZ_CHAIN 1>/dev/null 2>&1

	iptables -t filter -N $DMZ_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -A FORWARD -j $DMZ_FILTER_CHAIN 1>/dev/null 2>&1
	
	iptables -t nat -N $DMZ_POSTROUTING_CHAIN 1>/dev/null 2>&1
	iptables -t nat -A POSTROUTING  -j $DMZ_POSTROUTING_CHAIN 1>/dev/null 2>&1
	
}

dmz_rules_delete()
{
	iptables -t filter -D FORWARD -j $DMZ_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -F $DMZ_FILTER_CHAIN
	iptables -t filter -X $DMZ_FILTER_CHAIN 1>/dev/null 2>&1

	iptables -t nat -D PREROUTING  -j $DMZ_CHAIN 1>/dev/null 2>&1
	iptables -t nat -F $DMZ_CHAIN
	iptables -t nat -X $DMZ_CHAIN 1>/dev/null 2>&1

	iptables -t nat -D POSTROUTING  -j $DMZ_POSTROUTING_CHAIN 1>/dev/null 2>&1
	iptables -t nat -F $DMZ_POSTROUTING_CHAIN
	iptables -t nat -X $DMZ_POSTROUTING_CHAIN 1>/dev/null 2>&1
	
}

dmz_rules_Flush()
{
	iptables -F $DMZ_FILTER_CHAIN
	iptables -t nat -F $DMZ_CHAIN
	iptables -t nat -F $DMZ_POSTROUTING_CHAIN

}

virtual_server_rules_init()
{
	echo "virtual server init!!!"
	iptables -t nat -N $PORT_FORWARD_CHAIN 1>/dev/null 2>&1
	iptables -t nat -A PREROUTING  -j $PORT_FORWARD_CHAIN 1>/dev/null 2>&1

	iptables -t nat -N $PORT_FORWARD_POSTROUTING_CHAIN 1>/dev/null 2>&1
	iptables -t nat -A POSTROUTING  -j $PORT_FORWARD_POSTROUTING_CHAIN 1>/dev/null 2>&1

	iptables -t filter -N $PORT_FORWARD_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -A FORWARD -j $PORT_FORWARD_FILTER_CHAIN 1>/dev/null 2>&1
}

virtual_server_rules_delete()
{
	iptables -t filter -D FORWARD -j $PORT_FORWARD_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -F $PORT_FORWARD_FILTER_CHAIN
	iptables -t filter -X $PORT_FORWARD_FILTER_CHAIN 1>/dev/null 2>&1

	iptables -t nat -D PREROUTING  -j $PORT_FORWARD_CHAIN 1>/dev/null 2>&1
	iptables -t nat -F $PORT_FORWARD_CHAIN
	iptables -t nat -X $PORT_FORWARD_CHAIN 1>/dev/null 2>&1

	iptables -t nat -D POSTROUTING  -j $PORT_FORWARD_POSTROUTING_CHAIN 1>/dev/null 2>&1
	iptables -t nat -F $PORT_FORWARD_POSTROUTING_CHAIN
	iptables -t nat -X $PORT_FORWARD_POSTROUTING_CHAIN 1>/dev/null 2>&1
	
}

virtual_server_rules_Flush()
{
	iptables -t filter -F $PORT_FORWARD_FILTER_CHAIN
	iptables -t nat -F $PORT_FORWARD_CHAIN
	iptables -t nat -F $PORT_FORWARD_POSTROUTING_CHAIN

}

#auth,192.168.0.31,1000,3000,1000,3000,3,0;192.168.0.3,50,95,2,1
#保留之前配置，补充字段加在末尾
#192.168.0.31,1000,3000,3,0,1000,3000,auth;192.168.0.3,50,95,2,1,
virtual_server_run()
{
	if [ "vir_sv_ruls" != "" ];then
	wan_ip=`ifconfig $s_wan_if | grep "inet addr:" | cut -d ':' -f 2 | cut -d ' ' -f 1`
	lan_ip=`nvram_get 2860 lan_ipaddr`
	lan_netmask=`nvram_get 2860 lan_netmask`
	OLD_IFS="$IFS"
	IFS=";"
	arr=$vir_sv_rules
	for s in $arr
	do
		ip=`echo $s | cut -d ',' -f 1`
		echo $ip
		port_f=`echo $s | cut -d ',' -f 2`
		echo $port_f
		port_to=`echo $s | cut -d ',' -f 3`
		echo $port_to
		protocol=`echo $s | cut -d ',' -f 4`
		echo $protocol
		enable=`echo $s | cut -d ',' -f 5`
		echo $enable
		wan_port_f=`echo $s | cut -d ',' -f 6`
		echo $wan_port_f
		wan_port_to=`echo $s | cut -d ',' -f 7`
		echo $wan_port_to
		if [ "$ip" != "" ] && [ "$port_f" != "" ] && [ "$port_to" != "" ] && [ "$wan_port_f" != "" ] && [ "$wan_port_to" != "" ] && [ "$protocol" != "" ] && [ "$enable" != "0" ];then
			case $protocol in 
			1)
			echo "TCP!!!"
			iptables -t nat -A $PORT_FORWARD_CHAIN -j DNAT -i $s_wan_if -p tcp --dport $wan_port_f:$wan_port_to --to $ip:$port_f-$port_to
			iptables -t filter -A $PORT_FORWARD_FILTER_CHAIN -p tcp --dport $port_f:$port_to -d $ip -j ACCEPT
			if [ "$wan_ip" != "" ];then
				iptables -t nat -A $PORT_FORWARD_CHAIN  -j DNAT -i $s_lan_if -d $wan_ip -p tcp --dport $wan_port_f:$wan_port_to --to $ip:$port_f-$port_to
				iptables -t nat -I $PORT_FORWARD_POSTROUTING_CHAIN -s $lan_ip/$lan_netmask -d $ip -p tcp --dport $port_f:$port_to -j SNAT --to $lan_ip
				#$wan_port_f:$wan_port_to 待确认
			fi
			;;
			2)
			echo "UDP!!!"
			iptables -t nat -A $PORT_FORWARD_CHAIN -j DNAT -i $s_wan_if -p udp --dport $wan_port_f:$wan_port_to --to $ip:$port_f-$port_to
			iptables -t filter -A $PORT_FORWARD_FILTER_CHAIN -p udp --dport $port_f:$port_to -d $ip -j ACCEPT
			if [ "$wan_ip" != "" ];then
				iptables -t nat -A $PORT_FORWARD_CHAIN  -j DNAT -i $s_lan_if -d $wan_ip -p udp --dport $wan_port_f:$wan_port_to --to $ip:$port_f-$port_to
				iptables -t nat -I $PORT_FORWARD_POSTROUTING_CHAIN -s $lan_ip/$lan_netmask -d $ip -p udp --dport $port_f:$port_to -j SNAT --to $lan_ip
				#$wan_port_f:$wan_port_to 待确认
			fi

			;;
			3)
			echo "TCP&UDP!!!"
			iptables -t nat -A $PORT_FORWARD_CHAIN -j DNAT -i $s_wan_if -p tcp --dport $wan_port_f:$wan_port_to --to $ip:$port_f-$port_to
			iptables -t nat -A $PORT_FORWARD_CHAIN -j DNAT -i $s_wan_if -p udp --dport $wan_port_f:$wan_port_to --to $ip:$port_f-$port_to
			iptables -t filter -A $PORT_FORWARD_FILTER_CHAIN -p tcp --dport $port_f:$port_to -d $ip -j ACCEPT
			iptables -t filter -A $PORT_FORWARD_FILTER_CHAIN -p udp --dport $port_f:$port_to -d $ip -j ACCEPT
			if [ "$wan_ip" != "" ];then
				iptables -t nat -A $PORT_FORWARD_CHAIN  -j DNAT -i $s_lan_if -d $wan_ip -p tcp --dport $wan_port_f:$wan_port_to --to $ip:$port_f-$port_to
				iptables -t nat -I $PORT_FORWARD_POSTROUTING_CHAIN -s $lan_ip/$lan_netmask -d $ip -p tcp --dport $port_f:$port_to -j SNAT --to $lan_ip
				iptables -t nat -A $PORT_FORWARD_CHAIN  -j DNAT -i $s_lan_if -d $wan_ip -p udp --dport $wan_port_f:$wan_port_to --to $ip:$port_f-$port_to
				iptables -t nat -I $PORT_FORWARD_POSTROUTING_CHAIN -s $lan_ip/$lan_netmask -d $ip -p udp --dport $port_f:$port_to -j SNAT --to $lan_ip
				#$wan_port_f:$wan_port_to 待确认
			fi

			;;
			esac
		else
			echo "ip port portocol has null or not enable!!!"
		fi
	done
	IFS="$OLD_IFS"	
	else
		echo "virtual server rule is null!!!"	
		return
	fi
}

dmz_run()
{
#	tcpport80=`nvram_get 2860 DMZAvoidTCPPort80`
	dmz_ip=`nvram_get 2860 DMZIPAddress`
	lan_ip=`nvram_get 2860 lan_ipaddr`
	lan_netmask=`nvram_get 2860 lan_netmask`
	pc_remote_en=`nvram_get 2860 RemoteManagement`
	pc_remote_port=`nvram_get 2860 AllowPort`
	wan_mode=`nvram_get 2860 wanConnectionMode`
	ip=`nvram_get 2860 wan_ipaddr`
	#获取wan口IP地址，cut后面带的-d 表示已什么符号分割，-f表示显示第几段
	wan_ip=`ifconfig $s_wan_if | grep "inet addr:" | cut -d ':' -f 2 | cut -d ' ' -f 1`
	
	#防止l2tp,pptp报文透传到DMZ主机
	iptables -t nat -A $DMZ_CHAIN -i $s_wan_if -p udp --sport 67:68 -j ACCEPT 
	iptables -t nat -A $DMZ_CHAIN -i $s_wan_if -p 47 -j ACCEPT 
	iptables -t nat -A $DMZ_CHAIN -i $s_wan_if -p udp --sport 1701 -j ACCEPT 
	iptables -t nat -A $DMZ_CHAIN -i $s_wan_if -p tcp --sport 1723 -j ACCEPT

	iptables -t nat -A $DMZ_CHAIN -i $s_wan_if -p tcp -j DNAT  --to $dmz_ip
	iptables -t nat -A $DMZ_CHAIN -i $s_wan_if -p udp -j DNAT  --to $dmz_ip
	iptables -t filter -A $DMZ_FILTER_CHAIN -i $s_wan_if -d $dmz_ip -j ACCEPT

	if [ "$wan_ip" != "" ];then
		iptables -t nat -A $DMZ_CHAIN  -j DNAT -i $s_lan_if -d $wan_ip -p tcp  --to $dmz_ip
		iptables -t nat -I $DMZ_POSTROUTING_CHAIN -s $lan_ip/$lan_netmask -d $dmz_ip -p tcp -j SNAT --to $lan_ip
		iptables -t nat -A $DMZ_CHAIN  -j DNAT -i $s_lan_if -d $wan_ip -p udp  --to $dmz_ip
		iptables -t nat -I $DMZ_POSTROUTING_CHAIN -s $lan_ip/$lan_netmask -d $dmz_ip -p udp -j SNAT --to $lan_ip
	else
	     if [ "$wan_mode" = "STATIC" ]; then
		    iptables -t nat -A $DMZ_CHAIN  -j DNAT -i $s_lan_if -d $ip -p tcp  --to $dmz_ip
		    iptables -t nat -I $DMZ_POSTROUTING_CHAIN -s $lan_ip/$lan_netmask -d $dmz_ip -p tcp -j SNAT --to $lan_ip
		    iptables -t nat -A $DMZ_CHAIN  -j DNAT -i $s_lan_if -d $ip -p udp  --to $dmz_ip
		    iptables -t nat -I $DMZ_POSTROUTING_CHAIN -s $lan_ip/$lan_netmask -d $dmz_ip -p udp -j SNAT --to $lan_ip
	     fi
	fi

	
}

echo "<<<<<<<<<<<<<<<< VIRTUAL SERVER ADN DMZ SET  >>>>>>>>>>>>>>>>>>>>"

if [ "$1" = "" ];then
	if [ "$dmz_enable" != "1" ] && [ "$vir_sv_en" != "1" ];then
		exit 1
	else
		var=run
	fi 
else
	var=$1
fi

case $var in
init)
virtual_server_rules_init
dmz_rules_init
if [ "$dmz_enable" = "1" ];then
        dmz_rules_Flush
        dmz_run
fi
if [ "$vir_sv_en" = "1" ];then
        virtual_server_rules_Flush
        virtual_server_run
fi
;;
run)
if [ "$dmz_enable" = "1" ];then
	dmz_rules_Flush
	dmz_run
else
    dmz_rules_Flush
fi
if [ "$vir_sv_en" = "1" ];then
	virtual_server_rules_Flush
	virtual_server_run
else
	virtual_server_rules_Flush
fi
;;
delete)
dmz_rules_delete
virtual_server_rules_delete
;;
esac
