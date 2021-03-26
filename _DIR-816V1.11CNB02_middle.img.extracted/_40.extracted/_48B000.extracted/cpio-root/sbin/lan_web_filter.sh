#!/bin/sh
#
#usage: lan_web_filter.sh init 
#		lan_web_filter.sh lan
#		lan_web_filter.sh wan
#		lan_web_filter.sh delete
#

. /sbin/config.sh
. /sbin/global.sh

LAN_WEB_FILTER_CHAIN="lan_web_filter"
REMOTE_MANAGE_PREROUT_CHAIN="remote_mangle_prerout"
REMOTE_MANAGE_INPUT_CHAIN="remote_mangle_input"

pc_lan_web_en=`nvram_get 2860 LanWebEn`

iptablesLanWebFilterInit()
{
	iptables -t filter -N $LAN_WEB_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -A INPUT -j $LAN_WEB_FILTER_CHAIN 1>/dev/null 2>&1
}

iptablesLanWebFilterClear()
{
	iptables -D INPUT -j $LAN_WEB_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -F $LAN_WEB_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -X $LAN_WEB_FILTER_CHAIN 1>/dev/null 2>&1
}

iptablesLanWebFilterFlush()
{
	iptables -F $LAN_WEB_FILTER_CHAIN 1>/dev/null 2>&1
}

iptablesRemoteManageInit()
{
	iptables -t nat -N $REMOTE_MANAGE_PREROUT_CHAIN 1>/dev/null 2>&1
	iptables -t nat -A PREROUTING  -j $REMOTE_MANAGE_PREROUT_CHAIN 1>/dev/null 2>&1
	iptables -t filter -N $REMOTE_MANAGE_INPUT_CHAIN 1>/dev/null 2>&1
	iptables -t filter -A INPUT  -j $REMOTE_MANAGE_INPUT_CHAIN 1>/dev/null 2>&1
}

iptablesRemoteManageClear()
{
	iptables -t filter -D INPUT -j $REMOTE_MANAGE_INPUT_CHAIN 1>/dev/null 2>&1
	iptables -t filter -F $REMOTE_MANAGE_INPUT_CHAIN 1>/dev/null 2>&1
	iptables -t filter -X $REMOTE_MANAGE_INPUT_CHAIN 1>/dev/null 2>&1	
	
	iptables -t nat -D PREROUTING -j $REMOTE_MANAGE_PREROUT_CHAIN 1>/dev/null 2>&1
	iptables -t nat -F $REMOTE_MANAGE_PREROUT_CHAIN 1>/dev/null 2>&1
	iptables -t nat -X $REMOTE_MANAGE_PREROUT_CHAIN 1>/dev/null 2>&1
}

iptablesRemoteManageFlush()
{
	iptables -t filter -F $REMOTE_MANAGE_INPUT_CHAIN 1>/dev/null 2>&1
	iptables -t nat -F $REMOTE_MANAGE_PREROUT_CHAIN 1>/dev/null 2>&1
}

iptablesLanWebFilterRun()
{
	
	pc_lan_mac0=`nvram_get 2860 LanWebMac0`
	pc_lan_mac1=`nvram_get 2860 LanWebMac1`
	pc_lan_mac2=`nvram_get 2860 LanWebMac2`
	pc_lan_mac3=`nvram_get 2860 LanWebMac3`

	iptables -F $LAN_WEB_FILTER_CHAIN
	
	if [ "$pc_lan_web_en" = "1" ];then
		
		if [ "${#pc_lan_mac0}" -eq 17 ];then
			iptables -A $LAN_WEB_FILTER_CHAIN -i br0 -m mac --mac-source $pc_lan_mac0 -p tcp --dport 80 -j ACCEPT
		fi
		
		if [ "${#pc_lan_mac1}" -eq 17 ];then
			iptables -A $LAN_WEB_FILTER_CHAIN -i br0 -m mac --mac-source $pc_lan_mac1 -p tcp --dport 80 -j ACCEPT
		fi
		
		if [ "${#pc_lan_mac2}" -eq 17 ];then
			iptables -A $LAN_WEB_FILTER_CHAIN -i br0 -m mac --mac-source $pc_lan_mac2 -p tcp --dport 80 -j ACCEPT
		fi
		
		if [ "${#pc_lan_mac3}" -eq 17 ];then
			iptables -A $LAN_WEB_FILTER_CHAIN -i br0 -m mac --mac-source $pc_lan_mac3 -p tcp --dport 80 -j ACCEPT
		fi
	    
		iptables -A $LAN_WEB_FILTER_CHAIN -i br0 -p tcp --dport 80 -j DROP
	else
		iptables -A $LAN_WEB_FILTER_CHAIN -i br0 -p tcp --dport 80 -j ACCEPT
	fi
}


iptablesRemoteManageRun()
{
	pc_remote_manage_en=`nvram_get 2860 RemoteManagement`
	pc_remote_manage_ip=`nvram_get 2860 AllowIp`
	pc_remote_manage_port=`nvram_get 2860 AllowPort`
	
	if [ "$pc_remote_manage_en" = "1" ];then
		if [ "$pc_remote_manage_ip" = "255.255.255.255" ];then
		#	iptables -t nat -A $REMOTE_MANAGE_PREROUT_CHAIN -i $wan_ppp_if -p icmp -j ACCEPT
			iptables -t nat -A $REMOTE_MANAGE_PREROUT_CHAIN -i $wan_ppp_if -p tcp -m tcp --dport $pc_remote_manage_port -j REDIRECT --to-ports 80
			iptables -t nat -A $REMOTE_MANAGE_PREROUT_CHAIN -i $wan_ppp_if -p tcp -m tcp --dport 80 -j REDIRECT --to-ports $pc_remote_manage_port
			iptables -t filter -A $REMOTE_MANAGE_INPUT_CHAIN -i $wan_ppp_if -p tcp --dport 80 -j ACCEPT
		else
		#	iptables -t nat -A $REMOTE_MANAGE_PREROUT_CHAIN -i $wan_ppp_if -p icmp -s $pc_remote_manage_ip -j ACCEPT
			iptables -t nat -A $REMOTE_MANAGE_PREROUT_CHAIN -i $wan_ppp_if -p tcp -m tcp -s $pc_remote_manage_ip --dport $pc_remote_manage_port -j REDIRECT --to-ports 80
			iptables -t nat -A $REMOTE_MANAGE_PREROUT_CHAIN -i $wan_ppp_if -p tcp -m tcp -s $pc_remote_manage_ip --dport 80 -j REDIRECT --to-ports $pc_remote_manage_port
			iptables -t filter -A $REMOTE_MANAGE_INPUT_CHAIN -i $wan_ppp_if -p tcp -s $pc_remote_manage_ip --dport 80 -j ACCEPT
		fi
		
	else
		iptables -A $REMOTE_MANAGE_INPUT_CHAIN -i $wan_ppp_if -m state -p tcp --dport 80 --state NEW,INVALID -j DROP
	fi
}

echo "<<<<<<<<<<<< web manager >>>>>>>>>>"
echo $wan_ppp_if
if [ "$1" = "" ];then
	pc_lan_web_en=`nvram_get 2860 LanWebEn`
	pc_remote_manage_en=`nvram_get 2860 RemoteManagement`
	if [ "$pc_lan_web_en" = "1" ] && [ "$pc_remote_manage_en" = "1" ];then
                var=init
        elif [ "$pc_lan_web_en" = "1" ];then
                var=lan
        elif [ "$pc_remote_manage_en" = "1" ];then
                var=wan
        else
                exit 1
        fi
else
	var=$1
fi

case $var in
init)
iptablesLanWebFilterInit
iptablesRemoteManageInit
iptablesLanWebFilterRun
iptablesRemoteManageRun
;;
lan)
iptablesLanWebFilterFlush
iptablesLanWebFilterRun
;;
wan)
iptablesRemoteManageFlush
iptablesRemoteManageRun
;;
delete)
iptablesLanWebFilterClear
iptablesRemoteManageClear
;;
lan_delete)
iptablesLanWebFilterClear
;;
wan_delete)
iptablesRemoteManageClear
;;
*)
echo "usage lan_web_filter init|delete|wan|lan"
;;
esac

