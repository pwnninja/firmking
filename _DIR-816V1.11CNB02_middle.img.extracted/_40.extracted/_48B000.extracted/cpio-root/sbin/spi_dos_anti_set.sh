#!/bin/sh
#
#usage: spi_dos_anti.sh spi|dos|all|delete|init
#

. /sbin/config.sh
. /sbin/global.sh

SPI_FORWARD_CHAIN="spi_forward"  
SPI_INPUT_CHAIN="spi_input"
MALICIOUS_FILTER_CHAIN="malicious_filter"                              
TCP_SYNFLOOD_FILTER_CHAIN="tcp_synflood_filter"					#tcp forword flood          
UDP_SYNFLOOD_FILTER_CHAIN="udp_synflood_filter"					#udp forword flood          
ICMP_SYNFLOOD_FILTER_CHAIN="icmp_synflood_filter"				#icmp forword flood      
MALICIOUS_INPUT_FILTER_CHAIN="malicious_input_filter"                      
TCP_SYNFLOOD_INPUT_FILTER_CHAIN="tcp_synflood_input_filter"		#tcp input flood  
UDP_SYNFLOOD_INPUT_FILTER_CHAIN="udp_synflood_input_filter"		#udp input flood  
ICMP_SYNFLOOD_INPUT_FILTER_CHAIN="icmp_synflood_input_filter"	#icmp input flood
WAN_ICMP_INPUT_CHAIN="wan_icmp_input" 

pc_ddos_en=`nvram_get 2860 AntiDoSEnable`
pc_spi_en=`nvram_get 2860 SPIFWEnabled`
wan_bound_if=$wan_ppp_if

iptablesSpiDisable()
{
	echo "in iptablesSpiDisable"
	iptables -t filter -D INPUT -j $SPI_INPUT_CHAIN 1>/dev/null 2>&1
        iptables -t filter -F $SPI_INPUT_CHAIN 1>/dev/null 2>&1
        iptables -t filter -X $SPI_INPUT_CHAIN 1>/dev/null 2>&1
	iptables -t filter -D FORWARD -j $SPI_FORWARD_CHAIN 1>/dev/null 2>&1
	iptables -t filter -F $SPI_FORWARD_CHAIN 1>/dev/null 2>&1
	iptables -t filter -X $SPI_FORWARD_CHAIN  1>/dev/null 2>&1
}

iptablesSpiInit()
{
	
	iptables -t filter -N $SPI_FORWARD_CHAIN 1>/dev/null 2>&1
	iptables -t filter -A FORWARD -j $SPI_FORWARD_CHAIN 1>/dev/null 2>&1
	iptables -t filter -N $SPI_INPUT_CHAIN 1>/dev/null 2>&1
	iptables -t filter -A INPUT  -j $SPI_INPUT_CHAIN 1>/dev/null 2>&1

}

iptablesSpiFlush()
{
	iptables -t filter -F $SPI_INPUT_CHAIN 1>/dev/null 2>&1
	iptables -t filter -F $SPI_FORWARD_CHAIN 1>/dev/null 2>&1
}

iptablesMaliciousFilterClear()
{
	iptables -D INPUT -j $WAN_ICMP_INPUT_CHAIN 1>/dev/null 2>&1
	iptables -F $WAN_ICMP_INPUT_CHAIN 1>/dev/null 2>&1
	iptables -t filter -X $WAN_ICMP_INPUT_CHAIN  1>/dev/null 2>&1
	
	############################ INPUT CHAIN ###################################
	#TCP
	iptables -t filter -D $MALICIOUS_INPUT_FILTER_CHAIN -i $wan_bound_if -p tcp --syn -j $TCP_SYNFLOOD_INPUT_FILTER_CHAIN 1>/dev/null 2>&1 
	iptables -F $TCP_SYNFLOOD_INPUT_FILTER_CHAIN   1>/dev/null 2>&1
	iptables -t filter -X $TCP_SYNFLOOD_INPUT_FILTER_CHAIN 1>/dev/null 2>&1
	#UDP
	iptables -t filter -D $MALICIOUS_INPUT_FILTER_CHAIN -i $wan_bound_if -p udp -j $UDP_SYNFLOOD_INPUT_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -F $UDP_SYNFLOOD_INPUT_FILTER_CHAIN   1>/dev/null 2>&1
	iptables -t filter -X $UDP_SYNFLOOD_INPUT_FILTER_CHAIN 1>/dev/null 2>&1
	#ICMP
	iptables -t filter -D $MALICIOUS_INPUT_FILTER_CHAIN -i $wan_bound_if -p icmp -j $ICMP_SYNFLOOD_INPUT_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -F $ICMP_SYNFLOOD_INPUT_FILTER_CHAIN   1>/dev/null 2>&1
	iptables -t filter -X $ICMP_SYNFLOOD_INPUT_FILTER_CHAIN 1>/dev/null 2>&1
	
	iptables -D INPUT -j $MALICIOUS_INPUT_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -F $MALICIOUS_INPUT_FILTER_CHAIN   1>/dev/null 2>&1
	iptables -t filter -X $MALICIOUS_INPUT_FILTER_CHAIN 1>/dev/null 2>&1


	########################### FORWARD CHAIN ##############################
       # icmp synflood
	iptables -t filter -D $MALICIOUS_FILTER_CHAIN -i $wan_bound_if -p icmp -j $ICMP_SYNFLOOD_FILTER_CHAIN 1>/dev/null 2>&1
        iptables -F $ICMP_SYNFLOOD_FILTER_CHAIN  1>/dev/null 2>&1
        iptables -t filter -X $ICMP_SYNFLOOD_FILTER_CHAIN 1>/dev/null 2>&1
	# udp synflood
        iptables -t filter -D $MALICIOUS_FILTER_CHAIN -i $wan_bound_if -p udp -j $UDP_SYNFLOOD_FILTER_CHAIN 1>/dev/null 2>&1
        iptables -F $UDP_SYNFLOOD_FILTER_CHAIN  1>/dev/null 2>&1
        iptables -t filter -X $UDP_SYNFLOOD_FILTER_CHAIN 1>/dev/null 2>&1
	 # tcp synflood
	iptables -t filter -D $MALICIOUS_FILTER_CHAIN -i $wan_bound_if -p tcp --syn -j $TCP_SYNFLOOD_FILTER_CHAIN 1>/dev/null 2>&1
        iptables -F $TCP_SYNFLOOD_FILTER_CHAIN  1>/dev/null 2>&1
        iptables -t filter -X $TCP_SYNFLOOD_FILTER_CHAIN 1>/dev/null 2>&1
        # 
        iptables -D FORWARD -j $MALICIOUS_FILTER_CHAIN 1>/dev/null 2>&1
        iptables -F $MALICIOUS_FILTER_CHAIN  1>/dev/null 2>&1
        iptables -t filter -X $MALICIOUS_FILTER_CHAIN 1>/dev/null 2>&1
}

iptablesMaliciousFilterFlush()
{
	iptables -F $WAN_ICMP_INPUT_CHAIN 1>/dev/null 2>&1

	iptables -F $TCP_SYNFLOOD_INPUT_FILTER_CHAIN
	iptables -F $UDP_SYNFLOOD_INPUT_FILTER_CHAIN   1>/dev/null 2>&1
	iptables -F $ICMP_SYNFLOOD_INPUT_FILTER_CHAIN   1>/dev/null 2>&1

	iptables -F $ICMP_SYNFLOOD_FILTER_CHAIN  1>/dev/null 2>&1
	iptables -F $UDP_SYNFLOOD_FILTER_CHAIN  1>/dev/null 2>&1
	iptables -F $TCP_SYNFLOOD_FILTER_CHAIN  1>/dev/null 2>&1
}

iptablesMaliciousFilterInit()
{
	
#	iptables -t filter -N $WAN_ICMP_INPUT_CHAIN 1>/dev/null 2>&1
#	iptables -t filter -A INPUT  -j $WAN_ICMP_INPUT_CHAIN 1>/dev/null 2>&1
	
	iptables -t filter -N $MALICIOUS_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -N $TCP_SYNFLOOD_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -N $UDP_SYNFLOOD_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -N $ICMP_SYNFLOOD_FILTER_CHAIN 1>/dev/null 2>&1
		
	iptables -t filter -A FORWARD -j $MALICIOUS_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -A $MALICIOUS_FILTER_CHAIN -i $wan_bound_if -p tcp --syn -j $TCP_SYNFLOOD_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -A $MALICIOUS_FILTER_CHAIN -i $wan_bound_if -p udp -j $UDP_SYNFLOOD_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -A $MALICIOUS_FILTER_CHAIN -i $wan_bound_if -p icmp -j $ICMP_SYNFLOOD_FILTER_CHAIN 1>/dev/null 2>&1
		
		
	iptables -t filter -N $MALICIOUS_INPUT_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -N $TCP_SYNFLOOD_INPUT_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -N $UDP_SYNFLOOD_INPUT_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -N $ICMP_SYNFLOOD_INPUT_FILTER_CHAIN 1>/dev/null 2>&1
		
	iptables -t filter -A INPUT  -j $MALICIOUS_INPUT_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -A $MALICIOUS_INPUT_FILTER_CHAIN -i $wan_bound_if -p tcp --syn -j $TCP_SYNFLOOD_INPUT_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -A $MALICIOUS_INPUT_FILTER_CHAIN -i $wan_bound_if -p udp -j $UDP_SYNFLOOD_INPUT_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -A $MALICIOUS_INPUT_FILTER_CHAIN -i $wan_bound_if -p icmp -j $ICMP_SYNFLOOD_INPUT_FILTER_CHAIN 1>/dev/null 2>&1

	iptables -t filter -N $WAN_ICMP_INPUT_CHAIN 1>/dev/null 2>&1
	iptables -t filter -A INPUT  -j $WAN_ICMP_INPUT_CHAIN 1>/dev/null 2>&1	
}

iptablesMaliciousFilterRun()
{
	pc_ddos_en=`nvram_get 2860 AntiDoSEnable`
	pc_icmp_flood_en=`nvram_get 2860 icmp_flood_enable`
	pc_icmp_flood_th=`nvram_get 2860 icmp_flood_threshold`
	pc_udp_flood_en=`nvram_get 2860 udp_flood_enable`
	pc_udp_flood_th=`nvram_get 2860 udp_flood_threshold`
	pc_tcp_flood_en=`nvram_get 2860 tcp_flood_enable`
	pc_tcp_flood_th=`nvram_get 2860 tcp_flood_threshold`
#	pc_wan_ping=`nvram_get 2860 wanping`
	pc_lan_ping=`nvram_get 2860 lanping`
	bps=`nvram_get 2860 BlockPortScan`
	bsf=`nvram_get 2860 BlockSynFlood`
		
#	if [ "$pc_ddos_en" = "1" ] && [ "$pc_wan_ping" = "1" ];then
#		iptables -A $WAN_ICMP_INPUT_CHAIN -i $wan_ppp_if -p icmp --icmp-type 8 -j DROP
#	else
#		iptables -A $WAN_ICMP_INPUT_CHAIN -i $wan_ppp_if -p icmp -j ACCEPT
#	fi
	
	if [ "$pc_ddos_en" = "1" ] && [ "$pc_icmp_flood_en" = "1" ];then
	#	if [ "$pc_wan_ping" != "1" ];then
	#		iptables -F $WAN_ICMP_INPUT_CHAIN 1>/dev/null 2>&1
	#	fi
		iptables -A $ICMP_SYNFLOOD_FILTER_CHAIN -i $wan_bound_if -m limit --limit $pc_icmp_flood_th/s --limit-burst $pc_icmp_flood_th -j RETURN
		iptables -A $ICMP_SYNFLOOD_FILTER_CHAIN -i $wan_bound_if -j LOG --log-prefix '**ICMP ANTI**' --log-level 4
		iptables -A $ICMP_SYNFLOOD_FILTER_CHAIN -i $wan_bound_if -j DROP
		iptables -A $ICMP_SYNFLOOD_INPUT_FILTER_CHAIN -i $wan_bound_if -m limit --limit $pc_icmp_flood_th/s --limit-burst $pc_icmp_flood_th -j RETURN
		iptables -A $ICMP_SYNFLOOD_INPUT_FILTER_CHAIN -i $wan_bound_if -j LOG --log-prefix '**ICMP ANTI**' --log-level 4
		iptables -A $ICMP_SYNFLOOD_INPUT_FILTER_CHAIN -i $wan_bound_if -j DROP
	fi
	
	if [ "$pc_ddos_en" = "1" ] && [ "$pc_tcp_flood_en" = "1" ];then
		iptables -A $TCP_SYNFLOOD_FILTER_CHAIN -i $wan_bound_if -m limit --limit $pc_tcp_flood_th/s --limit-burst $pc_tcp_flood_th -j RETURN
		iptables -A $TCP_SYNFLOOD_FILTER_CHAIN -i $wan_bound_if -j LOG --log-prefix '**TCP SYN ANTI**' --log-level 4
		iptables -A $TCP_SYNFLOOD_FILTER_CHAIN -i $wan_bound_if -j DROP

		iptables -A $TCP_SYNFLOOD_INPUT_FILTER_CHAIN -i $wan_bound_if -m limit --limit $pc_tcp_flood_th/s --limit-burst $pc_tcp_flood_th -j RETURN
		iptables -A $TCP_SYNFLOOD_INPUT_FILTER_CHAIN -i $wan_bound_if -j LOG --log-prefix '**TCP SYN ANTI**' --log-level 4
		iptables -A $TCP_SYNFLOOD_INPUT_FILTER_CHAIN -i $wan_bound_if -j DROP
	fi

	if [ "$pc_ddos_en" = "1" ] && [ "$pc_udp_flood_en" = "1" ];then
		iptables -A $UDP_SYNFLOOD_FILTER_CHAIN -i $wan_bound_if -m limit --limit $pc_udp_flood_th/s --limit-burst $pc_udp_flood_th -j RETURN
		iptables -A $UDP_SYNFLOOD_FILTER_CHAIN -i $wan_bound_if -j LOG --log-prefix '**UDP SYN ANTI**' --log-level 4
		iptables -A $UDP_SYNFLOOD_FILTER_CHAIN -i $wan_bound_if -j DROP

		iptables -A $UDP_SYNFLOOD_INPUT_FILTER_CHAIN -i $wan_bound_if -m limit --limit $pc_udp_flood_th/s --limit-burst $pc_udp_flood_th -j RETURN
		iptables -A $UDP_SYNFLOOD_INPUT_FILTER_CHAIN -i $wan_bound_if -j LOG --log-prefix '**UDP SYN ANTI**' --log-level 4
		iptables -A $UDP_SYNFLOOD_INPUT_FILTER_CHAIN -i $wan_bound_if -j DROP
	fi
	
	if [ "$pc_ddos_en" = "1" ] && [ "$bps" = "1" ];then
		iptables -A $MALICIOUS_FILTER_CHAIN -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP
		iptables -A $MALICIOUS_FILTER_CHAIN -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
		iptables -A $MALICIOUS_FILTER_CHAIN -p tcp --tcp-flags ALL NONE -j DROP
		iptables -A $MALICIOUS_FILTER_CHAIN -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
		iptables -A $MALICIOUS_FILTER_CHAIN -p tcp --tcp-flags SYN,FIN SYN,FIN
		iptables -A $MALICIOUS_INPUT_FILTER_CHAIN -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP
		iptables -A $MALICIOUS_INPUT_FILTER_CHAIN -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
		iptables -A $MALICIOUS_INPUT_FILTER_CHAIN -p tcp --tcp-flags ALL NONE -j DROP
		iptables -A $MALICIOUS_INPUT_FILTER_CHAIN -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
		iptables -A $MALICIOUS_INPUT_FILTER_CHAIN -p tcp --tcp-flags SYN,FIN SYN,FIN
	fi
	
	if [ "$pc_ddos_en" = "1" ] && [ "$bsf" = "1" ];then
		echo 1 > /proc/sys/net/ipv4/tcp_syncookies 2>&1 1>/dev/null
	fi

	if [ "$pc_ddos_en" = "1" ];then
		if [ "$pc_icmp_flood_en" = "1" ] || [ "$pc_tcp_flood_en" = "1" ] || [ "$pc_udp_flood_en" = "1" ];then
			echo 1 > /proc/sys/kernel/printk_ratelimit_burst
		fi
	fi
}

iptablesSpiFwForwardRun()
{
	if [ "$pc_spi_en" != "1" ];then
		return
	fi
	opmode=`nvram_get 2860 OperationMode`
	
	if [ "$opmode" = "2" ];then
		if [ "$pc_spi_en" = "1" ];then
			iptables -t filter -A $SPI_FORWARD_CHAIN -m state --state INVALID -j DROP
			iptables -t filter -A $SPI_FORWARD_CHAIN -i $wan_ppp_if -m state --state NEW -j ACCEPT
			iptables -t filter -A $SPI_FORWARD_CHAIN -i lo -m state --state NEW -j ACCEPT
			iptables -t filter -A $SPI_FORWARD_CHAIN -m state --state RELATED,ESTABLISHED -j ACCEPT
			iptables -t filter -A $SPI_FORWARD_CHAIN -j DROP
		else
			iptables -t filter -A $SPI_FORWARD_CHAIN -i $wan_ppp_if -j ACCEPT
		fi
		
	else 
		if [ "$pc_spi_en" = "1" ];then
			iptables -t filter -A $SPI_FORWARD_CHAIN -m state --state INVALID -j DROP
			iptables -t filter -A $SPI_FORWARD_CHAIN -i $lan_if -m state --state NEW -j ACCEPT
			iptables -t filter -A $SPI_FORWARD_CHAIN -i lo -m state --state NEW -j ACCEPT
			iptables -t filter -A $SPI_FORWARD_CHAIN -m state --state RELATED,ESTABLISHED -j ACCEPT
			iptables -t filter -A $SPI_FORWARD_CHAIN -j DROP
		else
			iptables -t filter -A $SPI_FORWARD_CHAIN -i $lan_if -j ACCEPT	
		fi
	fi	
}

iptablesSpiFwInputRun()
{
	if [ "$pc_spi_en" != "1" ];then
                return
        fi
	opmode=`nvram_get 2860 OperationMode`
	
	if [ "$opmode" = "2" ];then
		if [ "$pc_spi_en" = "1" ];then
			iptables -t filter -A $SPI_INPUT_CHAIN -m state --state INVALID -j DROP
			iptables -t filter -A $SPI_INPUT_CHAIN -i $wan_ppp_if -m state --state NEW -j ACCEPT
			iptables -t filter -A $SPI_INPUT_CHAIN -i lo -m state --state NEW -j ACCEPT
			iptables -t filter -A $SPI_INPUT_CHAIN -m state --state RELATED,ESTABLISHED -j ACCEPT
			iptables -t filter -A $SPI_INPUT_CHAIN -j DROP
		else
			iptables -t filter -A $SPI_INPUT_CHAIN -i $wan_ppp_if -j ACCEPT
		fi
		
	else 
		if [ "$pc_spi_en" = "1" ];then
			iptables -t filter -A $SPI_INPUT_CHAIN -m state --state INVALID -j DROP
			iptables -t filter -A $SPI_INPUT_CHAIN -i $lan_if -m state --state NEW -j ACCEPT
			iptables -t filter -A $SPI_INPUT_CHAIN -i lo -m state --state NEW -j ACCEPT
			iptables -t filter -A $SPI_INPUT_CHAIN -m state --state RELATED,ESTABLISHED -j ACCEPT
			iptables -t filter -A $SPI_INPUT_CHAIN -j DROP
		else
			iptables -t filter -A $SPI_INPUT_CHAIN -i $lan_if -j ACCEPT	
		fi
	fi	
}

echo "<<<<<<<<<<<<<< SPI DOS ANTI >>>>>>>>>>>>>>>>>>"
if [ "$1" = "" ];then
	spi_enable=`nvram_get 2860 SPIFWEnabled`
	antiDosE=`nvram_get 2860 AntiDoSEnable`
	if [ "$spi_enable" = "1" ] && [ "$antiDosE" = "1" ];then
		var=all
	elif [ "$spi_enable" = "1" ];then
		var=spi
	elif [ "$antiDosE" = "1" ];then
		var=dos
	else
		exit 1
	fi
else
	var=$1
fi
case $var in
dos_init)
iptablesMaliciousFilterInit
iptablesMaliciousFilterRun
;;
spi_init)
iptablesSpiInit
iptablesSpiFwInputRun
iptablesSpiFwForwardRun
;;
all)
iptablesSpiFlush
iptablesMaliciousFilterFlush
iptablesSpiFwInputRun
iptablesSpiFwForwardRun
iptablesMaliciousFilterRun
;;
spi)
iptablesSpiFlush
iptablesSpiFwInputRun
iptablesSpiFwForwardRun
;;
dos)
iptablesMaliciousFilterFlush
iptablesMaliciousFilterRun
;;
spi_flush)
iptablesSpiFlush
;;
dos_flush)
iptablesMaliciousFilterFlush
;;
flush)
iptablesSpiFlush
iptablesMaliciousFilterFlush
;;
delete)
iptablesSpiDisable
iptablesMaliciousFilterClear
;;
esac
