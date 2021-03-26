#!/bin/sh
action=$1
end=$2
eval `flash get IP_ADDR`

case $action in
        start)
			killall -9 dnsmasq
			killall -9 proxyd
			dnsmasq --port=63481 --address=/dlinkrouter/$IP_ADDR --address=/dlinkrouter.local/$IP_ADDR --address=/#/1.33.203.39
			dnsmasq -C /etc/DNS.conf &
			
			iptables -t nat -D PREROUTING -d 1.33.203.39 -p tcp --dport 80 -j REDIRECT --to-ports 5449 >/dev/null
			
			iptables -t nat -D PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 80 >/dev/null
			iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 80

			iptables -t nat -D PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 63481 >/dev/null
			iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 63481

        	echo "smart404 start ok."
        ;;
        stop) 
			iptables -t nat -D PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 63481 >/dev/null
			iptables -t nat -D PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 80 >/dev/null
			killall -9 dnsmasq
			killall -9 proxyd
			
			proxyd -m 1.33.203.39 -f /etc/proxyd.conf -u /etc/proxyd_url.conf &
			iptables -t nat -D PREROUTING -d 1.33.203.39 -p tcp --dport 80 -j REDIRECT --to-ports 5449 >/dev/null
			iptables -t nat -I PREROUTING -d 1.33.203.39 -p tcp --dport 80 -j REDIRECT --to-ports 5449
			
        	echo "smart404 stop ok."
        ;;

        active)
			iptables -t nat -D PREROUTING -d 1.33.203.39 -p tcp --dport 80 -j REDIRECT --to-ports 5449 >/dev/null
			iptables -t nat -D PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 80 >/dev/null
			iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 80

			iptables -t nat -D PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 63481 >/dev/null
			iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 63481
        	echo "smart404 active ok."
        ;;

        reproxy)
                        iptables -t nat -D PREROUTING -d 1.33.203.39 -p tcp --dport 80 -j REDIRECT --to-ports 5449 >/dev/null
                        iptables -t nat -I PREROUTING -d 1.33.203.39 -p tcp --dport 80 -j REDIRECT --to-ports 5449
        ;;

        *)
        	echo "smart404.sh {start|stop}"
        ;;
esac

exit 0
