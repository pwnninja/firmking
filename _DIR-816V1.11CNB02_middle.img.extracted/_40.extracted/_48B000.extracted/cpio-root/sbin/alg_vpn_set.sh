#!/bin/sh
#
#
# usage alg_vpn_set.sh vpn|alg|all
#

. /sbin/config.sh
. /sbin/global.sh

firewallConfigAlgRun()
{
	pc_alg_ftp_en=`nvram_get 2860 ALG_FTP`
	pc_alg_sip_en=`nvram_get 2860 ALG_SIP`
	if [ "$pc_alg_ftp_en" = "1" ];then

		insmod /lib/modules/2.6.36/kernel/net/netfilter/nf_conntrack_ftp.ko 2>/dev/null
		insmod /lib/modules/2.6.36/kernel/net/ipv4/netfilter/nf_nat_ftp.ko 2>/dev/null
	else
		rmmod nf_nat_ftp.ko 2>/dev/null
		rmmod nf_conntrack_ftp.ko 2>/dev/null
	fi
	
	if [ "$pc_alg_sip_en" = "1" ];then
		echo 1 > /proc/algonoff_sip
	else	
		echo 0 > /proc/algonoff_sip	
	fi
}

firewallConfigVpnRun()
{
	
	pc_alg_pptp_en=`nvram_get 2860 ALG_PPTP`
	pc_alg_l2tp_en=`nvram_get 2860 ALG_L2TP`
	pc_alg_ipsec_en=`nvram_get 2860 ALG_IPSEC`
	
	if [ "$pc_alg_pptp_en" = "1" ];then
		echo 1 > /proc/algonoff_pptp
	else
		echo 0 > /proc/algonoff_pptp
	fi
	
	if [ "$pc_alg_l2tp_en" = "1" ];then
		echo 1 > /proc/algonoff_l2tp
	else
		echo 0 > /proc/algonoff_l2tp
	fi
	
	if [ "$pc_alg_ipsec_en" = "1" ];then
		echo 1 > /proc/algonoff_ipsec
	else
		echo 0 > /proc/algonoff_ipsec
	fi
	
}

echo "<<<<<<<<<<<<<<<<<<< ALG VPN >>>>>>>>>>>>>>>>>>>>>"

case $1 in
init)
firewallConfigAlgRun
firewallConfigVpnRun
;;
all)
firewallConfigAlgRun
firewallConfigVpnRun
;;
vpn)
firewallConfigVpnRun
;;
alg)
firewallConfigAlgRun
;;
delete)
;;
*)
echo "usage: alg_vpn_set.sh vpn|alg"
;;
esac

