#!/bin/sh
routed_conf=/var/run/routed.conf
rm /var/run/routed.conf 2>/dev/null
killall -15 routed 2>/dev/null

eval `flash get NAT_ENABLED`
eval `flash get RIP_ENABLED`
eval `flash get RIP_WAN_TX`
eval `flash get RIP_WAN_RX`
eval `flash get RIP_LAN_TX`
eval `flash get RIP_LAN_RX`
eval `flash get WAN_DHCP`


if [ "$WAN_DHCP" = '0' ]; then
	wan_if=eth1
elif [ "$WAN_DHCP" = '1' ]; then
	wan_if=eth1			
elif [ "$WAN_DHCP" = '3' ]; then
	wan_if=ppp0
elif [ "$WAN_DHCP" = '4' ]; then
	wan_if=ppp0
elif [ "$WAN_DHCP" = '5' ]; then				
	wan_if=eth1
elif [ "$WAN_DHCP" = '6' ]; then	
	wan_if=ppp0
elif [ "$WAN_DHCP" = '7' ]; then	
	wan_if=ppp0
elif [ "$WAN_DHCP" = '8' ]; then	
	wan_if=ppp0		
else
	echo 'Invalid DHCP MIB value for WAN interface!'
fi


	if [ "$RIP_LAN_TX" != '0' ] && [ "$RIP_LAN_RX" = '0' ]; then
		  if [ "$RIP_LAN_TX" = '2' ]; then
		    echo "version 2" >> $routed_conf
		    run_cmd="-x -s -b"
		  else
		    echo "version 1" >> $routed_conf
		    run_cmd=" -x -s"
		  fi
		  echo "network br0" >> $routed_conf
	  
	elif [ "$RIP_LAN_TX" != '0' ] && [ "$RIP_LAN_RX" != '0' ]; then
		if [ "$RIP_LAN_TX" = '2' ]; then
		    echo "version 2" >> $routed_conf
		    run_cmd="-s -b"
		  else
		    echo "version 1" >> $routed_conf
		    run_cmd="-s"
		  fi
		if [ "$RIP_LAN_RX" = '2' ]; then
		    run_cmdrx="-y"
		  else
		    run_cmdrx="-z"
		  fi	  
		  echo "network br0" >> $routed_conf
		  echo "network $wan_if" >> $routed_conf
	else
		if [ "$RIP_LAN_RX" != '0' ]; then
		  	if [ "$RIP_LAN_RX" = '2' ]; then
		    		echo "version 2" >> $routed_conf
		    		run_cmd="-r -y"
		  	else
		    		echo "version 1" >> $routed_conf
		    		run_cmd="-r -z"
		  	fi
	  		echo "network br0" >> $routed_conf
	  		echo "network $wan_if" >> $routed_conf
		fi	
	fi
	


if [ "$RIP_ENABLED" != '0' ]; then
#echo "Start RIP daemon"
#echo "routed $run_cmdrx $run_cmd"
routed $run_cmdrx $run_cmd
fi
