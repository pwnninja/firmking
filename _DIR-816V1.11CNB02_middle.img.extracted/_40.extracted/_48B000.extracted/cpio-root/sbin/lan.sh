#!/bin/sh
#
# $Id: //WIFI_SOC/release/SDK_4_1_0_0/source/user/rt2880_app/scripts/lan.sh#1 $
#
# usage: wan.sh
#

. /sbin/config.sh
. /sbin/global.sh
fname="/etc/resolv.conf"

# stop all
killall -q udhcpd
killall -q lld2d
killall -q igmpproxy
killall -q upnpd
killall -q pppoe-relay
killall -q dnsmasq
rm -rf /var/run/lld2d-*
echo "" > /var/udhcpd.leases
# ip address
ip=`nvram_get 2860 lan_ipaddr`
nm=`nvram_get 2860 lan_netmask`
ifconfig $lan_if down
ifconfig $lan_if $ip netmask $nm
opmode=`nvram_get 2860 OperationMode`
if [ "$opmode" = "0" -o "$opmode" = "3" ]; then
	gw=`nvram_get 2860 wan_gateway`
	pd=`nvram_get 2860 wan_primary_dns`
	sd=`nvram_get 2860 wan_secondary_dns`
	route del default
	route add default gw $gw
	config-dns.sh $pd $sd
fi

# hostname
host=`nvram_get 2860 HostName`
#if [ "$host" = "" ]; then
	#host="dlink"
	#nvram_set 2860 HostName dlink
#fi

hostname $host
echo "127.0.0.1 localhost.localdomain localhost" > /etc/hosts
echo "$ip $host.dlink.com $host" >> /etc/hosts

# dhcp server
DhcpStaticRulesStr=`nvram_get 2860 DhcpStaticRulesStr`
dhcp=`nvram_get 2860 dhcpEnabled`
dnsRelay=`nvram_get 2860 dnsRelayEN`
#echo "dnsRelay= $dnsRelay --------"
if [ "$dhcp" = "1" ]; then
	rm -f /etc/udhcpd.conf
	start=`nvram_get 2860 dhcpStart`
	end=`nvram_get 2860 dhcpEnd`
	mask=`nvram_get 2860 dhcpMask`
	gw=`nvram_get 2860 dhcpGateway`
	hn=`nvram_get 2860 wan_dhcp_hn`
	if [ "$dnsRelay" = "1" ]; then
	    i=0
	    # is /etc/resolv.conf file exit
	    if [ -f  $fname  ]; then
	       while read myline  
           do  
		      dnsip=`echo $myline|cut -d " " -f2`  
              i=`expr $i + 1`
		      #echo "i = $i"
		      if [ "$i" = "1" ];then
		         pd=$dnsip
		  	     #echo "1pd= $pd"
		      fi 
		      if [ "$i" = "2" ]; then
		          sd=$dnsip
		          #echo "2sd= $sd "
		      fi 
		
           done < $fname
		fi
		
		#echo "i = $i"
		if [ "$i" = "0" ];then
		    pd="0.0.0.0"
		    sd="0.0.0.0"
	    fi
        #echo "pd= $pd"
		#echo "sd= $sd"
		nvram_set 2860 dhcpPriDns "$pd"
		nvram_set 2860 dhcpSecDns "$sd"
	else
	  #forbidden the dns rely ,pc dns is route ip
	  pd=`nvram_get 2860 lan_ipaddr` 
	  sd=`nvram_get 2860 lan_ipaddr` 
	  #nvram_set 2860 dhcpPriDns "$pd"
	  #nvram_set 2860 dhcpSecDns "$sd" 
	fi
	lease=`nvram_get 2860 dhcpLease`
	#static1=`nvram_get 2860 dhcpStatic1 | sed -e 's/;/ /'`
	#static2=`nvram_get 2860 dhcpStatic2 | sed -e 's/;/ /'`
	#static3=`nvram_get 2860 dhcpStatic3 | sed -e 's/;/ /'`
	
	static1=`echo $DhcpStaticRulesStr | cut -f1 -d'|'`
	static2=`echo $DhcpStaticRulesStr | cut -f2 -d'|'`
	static3=`echo $DhcpStaticRulesStr | cut -f3 -d'|'`
	static4=`echo $DhcpStaticRulesStr | cut -f4 -d'|'`
	static5=`echo $DhcpStaticRulesStr | cut -f5 -d'|'`
	static6=`echo $DhcpStaticRulesStr | cut -f6 -d'|'`
	static7=`echo $DhcpStaticRulesStr | cut -f7 -d'|'`
	static8=`echo $DhcpStaticRulesStr | cut -f8 -d'|'`
	static9=`echo $DhcpStaticRulesStr | cut -f9 -d'|'`
	static10=`echo $DhcpStaticRulesStr | cut -f10 -d'|'`
	static11=`echo $DhcpStaticRulesStr | cut -f11 -d'|'`
	static12=`echo $DhcpStaticRulesStr | cut -f12 -d'|'`
	static13=`echo $DhcpStaticRulesStr | cut -f13 -d'|'`
	static14=`echo $DhcpStaticRulesStr | cut -f14 -d'|'`
	static15=`echo $DhcpStaticRulesStr | cut -f15 -d'|'`
	static16=`echo $DhcpStaticRulesStr | cut -f16 -d'|'`
	static17=`echo $DhcpStaticRulesStr | cut -f17 -d'|'`
	static18=`echo $DhcpStaticRulesStr | cut -f18 -d'|'`
	static19=`echo $DhcpStaticRulesStr | cut -f19 -d'|'`
	static20=`echo $DhcpStaticRulesStr | cut -f20 -d'|'`
	static21=`echo $DhcpStaticRulesStr | cut -f21 -d'|'`
	static22=`echo $DhcpStaticRulesStr | cut -f22 -d'|'`
	static23=`echo $DhcpStaticRulesStr | cut -f23 -d'|'`
	static24=`echo $DhcpStaticRulesStr | cut -f24 -d'|'`
	static25=`echo $DhcpStaticRulesStr | cut -f25 -d'|'`
	
	config-udhcpd.sh -s $start
	config-udhcpd.sh -e $end
	config-udhcpd.sh -i $lan_if
	config-udhcpd.sh -m $mask
	if [ "$pd" != "" -o "$sd" != "" ]; then
		config-udhcpd.sh -d $pd $sd
	fi
	if [ "$gw" != "" ]; then
		config-udhcpd.sh -g $gw
	fi
	if [ "$lease" != "" ]; then
		config-udhcpd.sh -t $lease
	fi
	if [ "$host" != "" ]; then
		config-udhcpd.sh -a $host
	fi
	if [ "$hn" != "" ]; then
		config-udhcpd.sh -n $hn
	fi
	if [ "$static1" != "" ]; then
		config-udhcpd.sh -S $static1
	fi
	if [ "$static2" != "" ]; then
		config-udhcpd.sh -S $static2
	fi
	if [ "$static3" != "" ]; then
		config-udhcpd.sh -S $static3
	fi
	if [ "$static4" != "" ]; then
	   config-udhcpd.sh -S $static4
        fi 
	if [ "$static5" != "" ]; then
	   config-udhcpd.sh -S $static5
	fi
	if [ "$static6" != "" ]; then
	  config-udhcpd.sh -S $static6
	fi 
	if [ "$static7" != "" ]; then
	  config-udhcpd.sh -S $static7
	fi 
	if [ "$static8" != "" ]; then
	  config-udhcpd.sh -S $static8
	fi
	if [ "$static9" != "" ]; then
	  config-udhcpd.sh -S $static9
	fi
	if [ "$static10" != "" ]; then
	  config-udhcpd.sh -S $static10
	fi
	if [ "$static11" != "" ]; then
	  config-udhcpd.sh -S $static11
	fi 
	if [ "$static12" != "" ]; then
	  config-udhcpd.sh -S $static12
	fi 
	if [ "$static13" != "" ]; then
	  config-udhcpd.sh -S $static13
	fi
	if [ "$static14" != "" ]; then
	  config-udhcpd.sh -S $static14
	fi
	if [ "$static15" != "" ]; then
	  config-udhcpd.sh -S $static15
	fi
	if [ "$static16" != "" ]; then
	  config-udhcpd.sh -S $static16
	fi      
	if [ "$static17" != "" ]; then
	  config-udhcpd.sh -S $static17
	fi      
	if [ "$static18" != "" ]; then
	  config-udhcpd.sh -S $static18
	fi
	if [ "$static19" != "" ]; then
	  config-udhcpd.sh -S $static19
	fi
	if [ "$static20" != "" ]; then
	  config-udhcpd.sh -S $static20
	fi
	if [ "$static21" != "" ]; then
	  config-udhcpd.sh -S $static21
	fi
	if [ "$static22" != "" ]; then
	  config-udhcpd.sh -S $static22
	fi      
	if [ "$static23" != "" ]; then
	  config-udhcpd.sh -S $static23
	fi      
	if [ "$static24" != "" ]; then
	  config-udhcpd.sh -S $static24
	fi
	if [ "$static25" != "" ]; then
	  config-udhcpd.sh -S $static25
	fi
	echo "remaining	yes">>/etc/udhcpd.conf
	echo "pidfile	/var/run/udhcpd.pid">>/etc/udhcpd.conf
	config-udhcpd.sh -r 1
fi



# lltd
lltd=`nvram_get 2860 lltdEnabled`
if [ "$lltd" = "1" ]; then
	lld2d $lan_if
fi

# igmpproxy
igmp=`nvram_get 2860 igmpEnabled`
if [ "$igmp" = "1" ]; then
	config-igmpproxy.sh $wan_if $lan_if
fi

# upnp
#if [ "$opmode" != "0" -a "$opmode" != "3" ]; then
#	upnp=`nvram_get 2860 upnpEnabled`
#	if [ "$upnp" = "1" ]; then
#		if [ "$CONFIG_USER_MINIUPNPD" = "y" ]; then
#			miniupnpd.sh init
#		else
#			route add -net 239.0.0.0 netmask 255.0.0.0 dev $lan_if
#			upnp_xml.sh $ip
#			upnpd -f $wan_ppp_if $lan_if &
#		fi
#	fi
#fi

# radvd
# radvd=`nvram_get 2860 radvdEnabled`
# ifconfig sit0 down
# echo "0" > /proc/sys/net/ipv6/conf/all/forwarding
# if [ "$radvd" = "1" ]; then
#	echo "1" > /proc/sys/net/ipv6/conf/all/forwarding
#	ifconfig sit0 up
#	ifconfig sit0 add 2002:1101:101::1101:101/16
#	route -A inet6 add 2000::/3 gw ::17.1.1.20 dev sit0
#	route -A inet6 add 2002:1101:101:0::/64 dev br0
#	radvd -C /etc_ro/radvd.conf -d 1 &
# fi

# pppoe-relay
# pppr=`nvram_get 2860 pppoeREnabled`
# if [ "$pppr" = "1" ]; then
#	pppoe-relay -S $wan_if -B $lan_if
# fi

# dns proxy
portal_manage.sh init
#if [ -f "/etc/resolv.conf" ];then
#	echo "wan connected!!!"
#else
	portal_manage.sh add
#fi
dnsp=`nvram_get 2860 dnsPEnabled`
if [ "$dnsp" = "1" ]; then
	dnsmasq &
fi

