#!/bin/sh
#
# script file to start dhcp client (udhcpc)
#


if [ $# -lt 2 ]; then echo "Usage: $0 interface {wait|no]";  exit 1 ; fi

GETMIB="flash get"
SCRIPTFILE_PATH=/usr/share/udhcpc
PIDFILE=/etc/udhcpc/udhcpc-$1.pid
CMD="-i $1 -p $PIDFILE -s $SCRIPTFILE_PATH/$1.sh"
eval `flash get WAN_DHCP`
eval `flash get NETBIOS_SOURCE`

#get dhcpplus usernam,password
eval `flash get PPP_USER_NAME`
eval `flash get PPP_PASSWORD`
DHCPPLUSPID="/var/run/dhcpplus.pid"

if [ $2 = 'no' ]; then
# marked Auto-AP
#	CMD="$CMD -n -a"
	CMD="$CMD -n"
	eval `$GETMIB IP_ADDR`
	eval `$GETMIB SUBNET_MASK`
	eval `$GETMIB DEFAULT_GATEWAY`

	# Generate deconfig script, used when DHCP request is failed

	echo "#!/bin/sh" > $SCRIPTFILE_PATH/$1.deconfig
	echo "ifconfig $1 $IP_ADDR netmask $SUBNET_MASK" >> $SCRIPTFILE_PATH/$1.deconfig
        echo "while route del default dev $1" >> $SCRIPTFILE_PATH/$1.deconfig
        echo "do :" >> $SCRIPTFILE_PATH/$1.deconfig
        echo "done" >> $SCRIPTFILE_PATH/$1.deconfig
	echo "route add -net default gw $DEFAULT_GATEWAY dev $1" >> $SCRIPTFILE_PATH/$1.deconfig

	# added to start wlan application daemon
	echo "init.sh ap wlan_app" >> $SCRIPTFILE_PATH/$1.deconfig
else
	CMD="$CMD -a 30 -I $NETBIOS_SOURCE"
	
	# Generate deconfig script
	echo "#!/bin/sh" > $SCRIPTFILE_PATH/$1.deconfig
	echo "ifconfig $1 0.0.0.0" >> $SCRIPTFILE_PATH/$1.deconfig
#	echo "killall -9 upnp.sh 2> /dev/null" >> $SCRIPTFILE_PATH/$1.deconfig
#	echo "upnp.sh" >> $SCRIPTFILE_PATH/$1.deconfig
	
	eval `$GETMIB HOST_NAME`
	if [ "$HOST_NAME" != ""  ]; then	
			#flash get HOST_NAME > /var/hostname move to init.sh. Keith
		CMD="$CMD -h $HOST_NAME"
	fi
fi

eval `$GETMIB DHCP_UNICASTING`
if [ "$DHCP_UNICASTING" = 0 ]; then
	CMD="$CMD -B"
fi

if [ -f $PIDFILE ] ; then
	PID=`cat $PIDFILE`
	if [ $PID != 0 ]; then
		kill -9 $PID
       	fi
	rm -f $PIDFILE
fi
#add by tsrites for dhcpplus
echo "enter dhcpplus"
if [ -f $DHCPPLUSPID ]; then
	PID=`cat $DHCPPLUSPID`
	echo '1'
	if [ $PID != 0 ]; then
	echo '2'
		kill $PID >/dev/console 2>&1\n
	fi
	echo '3'
	rm -f $DHCPPLUSPID
fi
#echo  "dhcpplus -U $PPP_USER_NAME -P $PPP_PASSWORD &"

CMD="$CMD -m"

dhcpplus -U $PPP_USER_NAME -P $PPP_PASSWORD &


udhcpc $CMD
