#!/bin/sh

# udhcpc script edited by Tim Riker <Tim@Rikers.org>

. /sbin/config.sh
. /sbin/global.sh

[ -z "$1" ] && echo "Error: should be called from udhcpc" && exit 1

RESOLV_CONF="/etc/resolv.conf"
[ -n "$broadcast" ] && BROADCAST="broadcast $broadcast"
[ -n "$subnet" ] && NETMASK="netmask $subnet"

echo "[udhcpc]: $1"
case "$1" in
	deconfig)
		/sbin/ifconfig $interface 0.0.0.0
		#nvram_set 2860 wan_session_dhcp "0.0.0.0 0.0.0.0"
		rm -f /var/run/openl2tpd.pid
		killall -q pppd
		killall -q l2tpd
		killall -q openl2tpd
		./sbin/miniupnpd.sh remove
#		./sbin/portal_manage.sh flush
#		./sbin/portal_manage.sh add
		;;
		
	renew)
		echo "[udhcpc]: nothing to do!"
		;;
		
	bound)
		/sbin/ifconfig $interface $ip $BROADCAST $NETMASK
		echo $ip > /proc/alg_ip
		
		#wan_sd_tmp=`nvram_get 2860 wan_session_dhcp`
		#wan_sd="$ip $siaddr"
		#if [ "$wan_sd" != "$wan_sd_tmp" ]; then
		#	nvram_set 2860 wan_session_dhcp "$wan_sd"
		#fi
		if [ -n "$router" ] ; then
			echo "deleting routers"
			while route del default gw 0.0.0.0 dev $interface ; do
				:
			done
			if [ "$wanmode" != "RUPPPOE" ]; then
				metric=0
				for i in $router ; do
					metric=`expr $metric + 1`
					route add default gw $i dev $interface metric $metric
				done
			fi
		fi
		if [ "$wanmode" == "L2TP" ]; then
			autodns=`nvram_get 2860 wan_l2tp_autodns`
		elif [ "$wanmode" == "PPTP" ]; then
			autodns=`nvram_get 2860 wan_pptp_autodns`
		else
			autodns=`nvram_get 2860 wan_dhcp_autodns`	
		fi
		if [ "$autodns" = "1" ] ; then
			echo -n > $RESOLV_CONF
			[ -n "$domain" ] && echo search $domain >> $RESOLV_CONF
			for i in $dns ; do
				echo adding dns $i
				echo nameserver $i >> $RESOLV_CONF
			done
		fi
		# notify goahead when the WAN IP has been acquired. --yy
		killall -SIGTSTP goahead

		# restart igmpproxy daemon
		# config-igmpproxy.sh
		./sbin/miniupnpd.sh init
		./sbin/ntp.sh
#		./sbin/portal_manage.sh flush
	
		if [ "$wanmode" != "L2TP" -a "$wanmode" != "PPTP" ]; then
			exit 1
		fi
	
#		./sbin/portal_manage.sh add	
		i=0
		while [ "`ps | grep "pppd"|grep -v "grep"|cut -b 27-30`" = "pppd" ]
		do
			i=`expr $i + 1` 
			if [ $i -eq 10 ]  ; then
				break
			fi
			sleep 1
		done
		echo "[wan.sh]wait for pppd exit $i second."
		
		if [ "$wanmode" = "L2TP" ]; then
			u=`nvram_get 2860 wan_l2tp_user`
			pw=`nvram_get 2860 wan_l2tp_pass`
			openl2tp.sh $router
			openl2tpd -U $u -W $pw
		elif [ "$wanmode" = "PPTP" ]; then
			accel-pptp.sh $router
			pppd file /etc/options.pptp  &
		fi
		;;
esac

exit 0

