#!/bin/sh

# place the commands to run after the pppd dial up successfully.
echo "[ip-up]"
echo "[ip-up.sh] [0]$0 [1]$1 [2]$2 [3]$3 [4]$4 [5]$5 [6]$6"

wanmode=`nvram_get 2860 wanConnectionMode`
lan_ip=`nvram_get 2860 lan_ipaddr`
nat_en=`nvram_get 2860 natEnabled`
#wan_sd_tmp=`nvram_get 2860 wan_session_ppp`
pppoe_mode=`nvram_get 2860 wan_pppoe_opmode`

if [ "$wanmode" == "L2TP" -o "$wanmode" == "PPTP" ]; then	
	if [ "$5" != "" ]; then
		route del default
		route add default gw $5
	fi	
	if [ "$wanmode" == "L2TP" ]; then
		autodns=`nvram_get 2860 wan_l2tp_autodns`
		if [ "$autodns" != "1" ]; then
			pd=`nvram_get 2860 wan_l2tp_primary_dns`
			sd=`nvram_get 2860 wan_l2tp_secondary_dns`
			config-dns.sh $pd $sd
		fi
	fi

	#解决pptp 切换 ruppoe时不能上网,把session id写到内存
elif [ "$wanmode" = "PPPOE" -o "$wanmode" = "RUPPPOE" ]; then
	#wan_sd=`cat /tmp/ppp_session_id`
	#if [ "$wan_sd" != "$wan_sd_tmp" ]; then
		#nvram_set 2860 wan_session_ppp $wan_sd
	#fi
	#nvram_set 2860 statuscheckpppoeuser 14
	echo "14" > /tmp/statuscheckpppoeuser
	#记录PPPOE按需拨号
	if [ "$pppoe_mode" != "KeepAlive" ]; then
	    #nvram_set 2860 ppoe_demand_status 1
		echo "1" > /tmp/ppoe_demand_status
	fi
	
fi

if [ -x /bin/qos_run ]; then
	echo "/bin/qos_run"
	/bin/qos_run
fi

if [ -x /sbin/ddns.sh ]; then
	echo "/sbin/ddns.sh"
	/sbin/ddns.sh
fi

#if [ -x /sbin/config-udhcpd.sh ]; then
#	echo "/sbin/config-udhcpd.sh $DNS1 $DNS2"
#	/sbin/config-udhcpd.sh -k
#	/sbin/config-udhcpd.sh -d $DNS1 $DNS2
#	/sbin/config-udhcpd.sh -r 10
#fi
./sbin/miniupnpd.sh init
./sbin/ntp.sh
#./sbin/portal_manage.sh flush
# notify goahead that WAN IP has been acquired/updated.
killall -SIGTSTP goahead
