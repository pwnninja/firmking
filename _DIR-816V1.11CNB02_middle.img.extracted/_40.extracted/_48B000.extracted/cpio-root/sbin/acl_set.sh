#!/bin/sh
#
#
# usage: acl_set.sh init|delete
#

. /sbin/config.sh
. /sbin/global.sh

s_wan_if=$wan_ppp_if
s_lan_if=$lan_if


wanConnect_rules=`nvram_get 2860 wanConnectionMode`
if [ "$wanConnect_rules" == "RUPPPOE" ]; then
	s_wan_if="ppp0"
fi

ACL_REMOTE_INPUT="ACL_REMOTE_INPUT"
ACL_REMOTE_PRE="ACL_REMOTE_PRE"
ACL_REMOTE_PRE_TAIL="$ACL_REMOTE_PRE_TAIL"
ACL_VPNFILTER_FORWARD="ACL_VPNFILTER_FORWARD"


acl_rules=`nvram_get 2860 acl_rules`

acl_rules_init()
{
	echo "acl init!!!"
	iptables -t filter -F $ACL_REMOTE_INPUT 
#	iptables -t filter -D INPUT  -j $ACL_REMOTE_INPUT 
	iptables -t filter -N $ACL_REMOTE_INPUT 
	iptables -t filter -A INPUT   -j $ACL_REMOTE_INPUT 
	
	iptables -t nat -F $ACL_REMOTE_PRE 
#	iptables -t nat -D PREROUTING  -j $ACL_REMOTE_PRE 
	iptables -t nat -N $ACL_REMOTE_PRE 
	iptables -t nat -A PREROUTING  -j $ACL_REMOTE_PRE 
	
	iptables -t filter -F $ACL_VPNFILTER_FORWARD
	iptables -t filter -N $ACL_VPNFILTER_FORWARD 
	iptables -t filter -A FORWARD -j $ACL_VPNFILTER_FORWARD
	
#	iptables -t nat -F $ACL_REMOTE_PRE_TAIL 
#	iptables -t nat -N $ACL_REMOTE_PRE_TAIL 
#	iptables -t nat -D PREROUTING  -j $ACL_REMOTE_PRE_TAIL 
#	iptables -t nat -A PREROUTING  -j $ACL_REMOTE_PRE_TAIL 
}

acl_rules_delete()
{
	iptables -t filter -F $ACL_REMOTE_INPUT 
	iptables -t filter -D INPUT  -j $ACL_REMOTE_INPUT 
	iptables -t filter -X $ACL_REMOTE_INPUT 
	
	iptables -t nat -F $ACL_REMOTE_PRE 
	iptables -t nat -D PREROUTING  -j $ACL_REMOTE_PRE 
	iptables -t nat -X $ACL_REMOTE_PRE 
	
	iptables -t filter -F $ACL_VPNFILTER_FORWARD
	iptables -t filter -D FORWARD -j $ACL_VPNFILTER_FORWARD 
	iptables -t filter -X $ACL_VPNFILTER_FORWARD
#	iptables -t nat -D PREROUTING  -j $ACL_REMOTE_PRE_TAIL 
#	iptables -t nat -F $ACL_REMOTE_PRE_TAIL 
#	iptables -t nat -X $ACL_REMOTE_PRE_TAIL 
}

acl_rules_Flush()
{
	iptables -t filter -F $ACL_REMOTE_INPUT 
	iptables -t nat -F $ACL_REMOTE_PRE 
	iptables -t filter -F $ACL_VPNFILTER_FORWARD
#	iptables -t nat -F $ACL_REMOTE_PRE_TAIL 
}

acl_default_action()
{
	#iptables -A $ACL_REMOTE_INPUT -i $s_wan_if -p icmp --icmp-type 8 -j DROP
	#iptables -A $ACL_REMOTE_INPUT -i $s_wan_if -p TCP --dport 80 -j DROP
	iptables -t filter -I $ACL_REMOTE_INPUT -m state --state INVALID -j DROP	
	iptables -A $ACL_REMOTE_INPUT -i $s_wan_if -p TCP --dport 0 -j DROP
	iptables -A $ACL_REMOTE_INPUT -i $s_wan_if -p TCP --dport 1 -j DROP
	iptables -A $ACL_REMOTE_INPUT -i $s_wan_if -m state --state NEW -j DROP
	if [ "$wanConnect_rules" == "RUPPPOE" ]; then
		iptables -A $ACL_REMOTE_INPUT -i eth2.2 -p TCP --dport 0 -j DROP
		iptables -A $ACL_REMOTE_INPUT -i eth2.2 -p TCP --dport 1 -j DROP
		iptables -A $ACL_REMOTE_INPUT -i eth2.2 -m state --state NEW -j DROP
	fi
	if [ "$wanConnect_rules" == "L2TP" ]; then
		iptables -t filter -A $ACL_VPNFILTER_FORWARD -i br0 -o eth2.2 -p icmp -j DROP
		iptables -A $ACL_REMOTE_INPUT -i eth2.2 -p TCP --dport 0 -j DROP
		iptables -A $ACL_REMOTE_INPUT -i eth2.2 -p TCP --dport 1 -j DROP
		iptables -A $ACL_REMOTE_INPUT -i eth2.2 -m state --state NEW -j DROP
	fi
	#pptp 单独添加规则，否则会出现pptp断线
	if [ "$wanConnect_rules" == "PPTP" ]; then
		iptables -t filter -A $ACL_VPNFILTER_FORWARD -i br0 -o eth2.2 -p icmp -j DROP
		iptables -A $ACL_REMOTE_INPUT -i eth2.2 -p TCP --dport 0 -j DROP
		iptables -A $ACL_REMOTE_INPUT -i eth2.2 -p TCP --dport 1 -j DROP
		iptables -A $ACL_REMOTE_INPUT -i eth2.2 -p icmp --icmp-type 8 -j DROP
		iptables -A $ACL_REMOTE_INPUT -i eth2.2 -p TCP --dport 1:1024 -j DROP
		iptables -A $ACL_REMOTE_INPUT -i eth2.2 -p TCP --dport 6352 -j DROP
		iptables -A $ACL_REMOTE_INPUT -i eth2.2 -p TCP --dport 8888 -j DROP
		iptables -A $ACL_REMOTE_INPUT -i eth2.2 -p UDP -m state --state NEW -j DROP
	fi
}

#$acl_rules="

#wan,web,80;
#wan,ping;

#wanip,web,80,10.10.1.11-10.10.1.13;
#wanip,ping,10.10.1.11-10.10.1.13;
#wanip,web,80,0.0.0.0;
#wanip,ping,0.0.0.0;

#"
acl_run()
{
	if [ "acl_ruls" != "" ];then
	OLD_IFS="$IFS"
	IFS=";"
	arr=$acl_rules
	for s in $arr
	do
		item1=`echo $s | cut -d ',' -f 1`
		item2=`echo $s | cut -d ',' -f 2`
		item3=`echo $s | cut -d ',' -f 3`
		if [ "$item1" != "" ] && [ "$item2" != "" ];then
			case $item1 in
			wan)							
				if [ "$item2" == "web" ] && [ "$item3" != "" ];then		
					iptables -t nat -A $ACL_REMOTE_PRE -i $s_wan_if -p TCP -m iprange --src-range 0.0.0.0-255.255.255.255 --dport $item3 -j REDIRECT --to-ports 80  
					iptables -t nat -A $ACL_REMOTE_PRE -i $s_wan_if -p TCP -m iprange --src-range 0.0.0.0-255.255.255.255 --dport 80 -j REDIRECT --to-ports $item3  
					iptables -t filter -A $ACL_REMOTE_INPUT -i $s_wan_if -p TCP -m iprange --src-range 0.0.0.0-255.255.255.255 --dport 80 -j ACCEPT  
					#iptables -t filter -A $ACL_REMOTE_INPUT -i $s_wan_if -p TCP --dport 80 -j DROP 
					if [ "$wanConnect_rules" == "RUPPPOE" ]; then
						iptables -t nat -A $ACL_REMOTE_PRE -i eth2.2 -p TCP -m iprange --src-range 0.0.0.0-255.255.255.255 --dport $item3 -j REDIRECT --to-ports 80  
						iptables -t nat -A $ACL_REMOTE_PRE -i eth2.2  -p TCP -m iprange --src-range 0.0.0.0-255.255.255.255 --dport 80 -j REDIRECT --to-ports $item3  
						iptables -t filter -A $ACL_REMOTE_INPUT -i eth2.2  -p TCP -m iprange --src-range 0.0.0.0-255.255.255.255 --dport 80 -j ACCEPT 
					fi
					
					/sbin/flush_conntrack >/dev/null 2>/dev/null;
				
				elif  [ "$item2" == "ping" ];then
					iptables -t filter -A $ACL_REMOTE_INPUT -i $s_wan_if  -p icmp --icmp-type 8 -j ACCEPT
					if [ "$wanConnect_rules" == "RUPPPOE" ]; then
						iptables -t filter -A $ACL_REMOTE_INPUT -i eth2.2  -p icmp --icmp-type 8 -j ACCEPT
					fi
				
				fi
			;;
				
			wanip)			
				item4=`echo $s | cut -d ',' -f 4`
				echo "$item1 : $item2 : $item3 : $item4 "
				if [ "$item2" == "web" ];then			
					echo "web!!!"							
					if [ "$item4" == "0.0.0.0" ];then
						iptables -t nat -A $ACL_REMOTE_PRE -i $s_wan_if -p TCP -m iprange --src-range 0.0.0.0-255.255.255.255 --dport $item3 -j REDIRECT --to-ports 80  
						iptables -t nat -A $ACL_REMOTE_PRE -i $s_wan_if -p TCP -m iprange --src-range 0.0.0.0-255.255.255.255 --dport 80 -j REDIRECT --to-ports $item3  
						iptables -t filter -A $ACL_REMOTE_INPUT -i $s_wan_if -p TCP -m iprange --src-range 0.0.0.0-255.255.255.255 --dport 80 -j ACCEPT  
						#iptables -t filter -A $ACL_REMOTE_INPUT -i $s_wan_if -p TCP --dport 80 -j DROP  
						if [ "$wanConnect_rules" == "RUPPPOE" ]; then
							iptables -t nat -A $ACL_REMOTE_PRE -i eth2.2 -p TCP -m iprange --src-range 0.0.0.0-255.255.255.255 --dport $item3 -j REDIRECT --to-ports 80  
							iptables -t nat -A $ACL_REMOTE_PRE -i eth2.2 -p TCP -m iprange --src-range 0.0.0.0-255.255.255.255 --dport 80 -j REDIRECT --to-ports $item3  
							iptables -t filter -A $ACL_REMOTE_INPUT -i eth2.2 -p TCP -m iprange --src-range 0.0.0.0-255.255.255.255 --dport 80 -j ACCEPT
						fi
						
						/sbin/flush_conntrack >/dev/null 2>/dev/null;
						
					else
					
						iptables -t nat -A $ACL_REMOTE_PRE -i $s_wan_if -p TCP -m iprange --src-range $item4 --dport $item3 -j REDIRECT --to-ports 80  
						iptables -t filter -A $ACL_REMOTE_INPUT -i $s_wan_if -p TCP -m iprange --src-range $item4 --dport 80 -j ACCEPT  
						#iptables -t filter -A $ACL_REMOTE_INPUT -i $s_wan_if -p TCP --dport 80 -j DROP  
						if [ "$wanConnect_rules" == "RUPPPOE" ]; then
							iptables -t nat -A $ACL_REMOTE_PRE -i eth2.2 -p TCP -m iprange --src-range $item4 --dport $item3 -j REDIRECT --to-ports 80  
							iptables -t filter -A $ACL_REMOTE_INPUT -i eth2.2 -p TCP -m iprange --src-range $item4 --dport 80 -j ACCEPT  
						fi
						
						/sbin/flush_conntrack >/dev/null 2>/dev/null;
						
					fi	
				elif  [ "$item2" == "ping" ];then
					echo "ping!!!"
					if [ "$item3" == "0.0.0.0" ];then
						iptables -t filter -A $ACL_REMOTE_INPUT -i $s_wan_if  -p icmp --icmp-type 8 -j ACCEPT
						if [ "$wanConnect_rules" == "RUPPPOE" ]; then
							iptables -t filter -A $ACL_REMOTE_INPUT -i eth2.2  -p icmp --icmp-type 8 -j ACCEPT
						fi
						
					else
						iptables -t filter -A $ACL_REMOTE_INPUT -i $s_wan_if -m iprange --src-range $item3 -p icmp --icmp-type 8 -j ACCEPT
						if [ "$wanConnect_rules" == "RUPPPOE" ]; then
							iptables -t filter -A $ACL_REMOTE_INPUT -i eth2.2 -m iprange --src-range $item3 -p icmp --icmp-type 8 -j ACCEPT
						fi
					fi
				fi

			;;
			esac
		else
			echo "acl set error!!!"
		fi
	done
	IFS="$OLD_IFS"	
	else
		echo "acl rule is null!!!"	
		return
	fi
}

echo "<<<<<<<<<<<<<<<< ACL SET  >>>>>>>>>>>>>>>>>>>>"

if [ "$1" = "" ];then
	var=run
else
	var=$1
fi
case $var in
init)
acl_rules_init
acl_rules_Flush
acl_run
acl_default_action
;;
run)
acl_rules_Flush
acl_run
acl_default_action
;;
delete)
acl_rules_delete
;;
esac

