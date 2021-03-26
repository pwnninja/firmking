#!/bin/sh

PPPOE_FILE=/etc/options.pppoe
PPPOED_FILE=/etc/options.pppoed

if [ ! -n "$4" ]; then
  echo "insufficient arguments!"
  echo "Usage: $0 <user> <password> <eth_name> <opmode>"
  exit 0
fi

PPPOE_USER_NAME="$1"
PPPOE_PASSWORD="$2"
PPPOE_IF="$3"
PPPOE_OPMODE="$4"
PPPOE_IDLETIME="$5"
#get parems
PPPOE_MTU=`nvram_get 2860 wan_mtu`
PPPOE_SEVICE_NAME=`nvram_get 2860 wan_pppoe_srvname`
PPPOE_MODE=`nvram_get 2860 wan_pppoe_mode`
PPPOE_STAICIP=`nvram_get 2860 wan_pppoe_staticIp`
PPPOE_AUTODNS=`nvram_get 2860 wan_pppoe_autodns`
PPPOE_IPtype=`nvram_get 2860 wan_pppoe_ipaddrmode`

echo "noauth" > $PPPOE_FILE
echo "user '$PPPOE_USER_NAME'" >> $PPPOE_FILE
echo "password '$PPPOE_PASSWORD'" >> $PPPOE_FILE
echo "nomppe" >> $PPPOE_FILE
echo "hide-password" >> $PPPOE_FILE
echo "noipdefault" >> $PPPOE_FILE
echo "defaultroute" >> $PPPOE_FILE
echo "nodetach" >> $PPPOE_FILE
if [ "$PPPOE_IPtype" == "2" ]; then
	IPadd2=`nvram_get 2860 wan_pppoe_staticIp`
	echo "$IPadd2:" >> $PPPOE_FILE
fi
if [ "$PPPOE_AUTODNS" == "0" ]; then
	PPPOE_AUTODNS1=`nvram_get 2860 wan_pppoe_primary_dns`
	PPPOE_AUTODNS2=`nvram_get 2860 wan_pppoe_secondary_dns`
	echo "ms-dns $PPPOE_AUTODNS1" >> $PPPOE_FILE
	if [ "$PPPOE_AUTODNS2" != "" ]; then
		echo "ms-dns $PPPOE_AUTODNS2" >> $PPPOE_FILE
	fi
else
echo "usepeerdns" >> $PPPOE_FILE
fi
if [ "$PPPOE_OPMODE" == "KeepAlive" ]; then
	echo "persist" >> $PPPOE_FILE
elif [ "$PPPOE_OPMODE" == "OnDemand" ]; then
	PPPOE_IDLETIME=`expr $PPPOE_IDLETIME \* 60`
	echo "demand" >> $PPPOE_FILE
	echo "idle $PPPOE_IDLETIME" >> $PPPOE_FILE
fi
echo "ipcp-accept-remote" >> $PPPOE_FILE 
echo "ipcp-accept-local" >> $PPPOE_FILE 
if [ "$PPPOE_MODE" == "1" ]; then
	echo "$PPPOE_STAICIP:" >> $PPPOE_FILE
fi
echo "lcp-echo-failure 6" >> $PPPOE_FILE
echo "lcp-echo-interval 20" >> $PPPOE_FILE
echo "ktune" >> $PPPOE_FILE
echo "default-asyncmap nopcomp noaccomp" >> $PPPOE_FILE
echo "novj nobsdcomp nodeflate" >> $PPPOE_FILE
echo "plugin /etc_ro/ppp/plugins/rp-pppoe.so $PPPOE_IF" >> $PPPOE_FILE

if [ "$PPPOE_MTU" != "" ]; then
	echo "mtu $PPPOE_MTU" >> $PPPOE_FILE
	echo "mru $PPPOE_MTU" >> $PPPOE_FILE
fi

rm $PPPOED_FILE -rf
if [ "$PPPOE_SEVICE_NAME" != "" ]; then
	echo "rp_pppoe_service $PPPOE_SEVICE_NAME" > $PPPOED_FILE
fi
