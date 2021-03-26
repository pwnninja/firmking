#!/bin/sh
FIRSTDDNS=/var/firstddns
LINKFILE=/etc/ppp/link
ETH1_IP=/var/eth1_ip
killall -9 peanut 2> /dev/null
killall -9 updatedd 2> /dev/null

#if [ -z $3 ]; then
###########kill sleep that ddns.sh created###############
TMPFILEDDNS=/tmp/tmpfileddns
AFTER_SLEEP="0"
line=0
ps | grep "sleep 82800" > $TMPFILEDDNS
line=`cat $TMPFILEDDNS | wc -l`
num=1
while [ $num -le $line ];
do
	pat0=` head -n $num $TMPFILEDDNS | tail -n 1`
	pat1=`echo $pat0 | cut -f1 -dS`  
	pat2=`echo $pat1 | cut -f1 -d " "`
	kill -9 $pat2 2> /dev/null

	num=`expr $num + 1`
done
###########################
rm -f /var/firstddns 2> /dev/null
rm -f /tmp/tmpfileddns 2> /dev/null
#fi



if [ ! -f $FIRSTDDNS ] || [ $1 = 'option' ]; then
{
echo "pass" > $FIRSTDDNS
while [ true ];
do
  eval `flash get DDNS_ENABLED`
  if [ $DDNS_ENABLED = 0 ]; then
    rm -f $FIRSTDDNS
    break
  fi
  if [ ! -f $FIRSTDDNS ]; then
    break
  fi
  
 eval `flash get WAN_DHCP`
  if [ $WAN_DHCP = 3 ] || [ $WAN_DHCP = 4 ] || [ $WAN_DHCP = 6 ] || [ $WAN_DHCP = 7 ] || [ $WAN_DHCP = 8 ]; then
    WAN=ppp0
  else
    WAN=eth1
  fi
  if [ $WAN_DHCP = 3 ] || [ $WAN_DHCP = 4 ] || [ $WAN_DHCP = 6 ] || [ $WAN_DHCP = 7 ] || [ $WAN_DHCP = 8 ]; then
   if [ ! -f $LINKFILE ]; then
   		sleep 10
     continue
   fi
   fi
   if [ $WAN_DHCP = 1 ]; then
   if [ ! -f $ETH1_IP ]; then
   		sleep 10
     continue
   fi
   
   
   fi
  eval `flash get DDNS_TYPE`
  eval `flash get DDNS_DOMAIN_NAME`
  eval `flash get DDNS_USER`
  eval `flash get DDNS_PASSWORD`
  eval `flash get DDNS_TIMEOUT`
  TIMEOUT=`expr $DDNS_TIMEOUT "*" 3600`
  WAN_IP=""	
  WAN_IP=`ifconfig $WAN | grep "inet addr" | cut -d':' -f2 | cut -d' ' -f1`
  if [ -f /var/ddns_last_update ]; then
      DDNS_CHECK=`cat /var/ddns_last_update | cut -d'|' -f2`
      LAST_TIME=`cat /var/ddns_last_update | cut -d'|' -f1`
	  NOW_TIME=`date +%s`
	  DIFF_TIME=`expr $NOW_TIME - $LAST_TIME`
	  if [ "$DIFF_TIME" -gt "$TIMEOUT" ] || [ "$DIFF_TIME" -lt "-3600" ]; then
	  	AFTER_SLEEP=1
	  fi
  else
      DDNS_CHECK=""
  fi
  echo  WAN_IP=$WAN_IP DDNS_CHECK=$DDNS_CHECK $WAN_IP:$DDNS_TYPE:$DDNS_USER:$DDNS_PASSWORD:$DDNS_DOMAIN_NAME AFTER_SLEEP=$AFTER_SLEEP
  for var in one two three four five
  do
  if [ "$WAN_IP" != "" -a "$DDNS_CHECK" != "$WAN_IP:$DDNS_TYPE:$DDNS_USER:$DDNS_PASSWORD:$DDNS_DOMAIN_NAME" ] || [ "$WAN_IP" != "" -a "$AFTER_SLEEP" = "1" ]; then
      AFTER_SLEEP="0"
	  #echo "DDNS Timeout $TIMEOUT"
	  if [ $DDNS_TYPE = 1 ]|| [ $DDNS_TYPE = 6 ] || [ $DDNS_TYPE = 7 ] || [ $DDNS_TYPE = 8 ] ; then
		rm -f /var/ddns/ddns_status 2> /dev/null
		rm -f /var/ddns/ddns_domain_name 2> /dev/null
		rm -f /var/ddns/ddns_user_type 2> /dev/null
		echo "$DDNS_TYPE" > /var/ddns_user_type

		echo updatedd dyndns $WAN_IP $DDNS_USER:$DDNS_PASSWORD $DDNS_DOMAIN_NAME > /dev/console
		updatedd dyndns $WAN_IP $DDNS_USER:$DDNS_PASSWORD $DDNS_DOMAIN_NAME
		ret=`echo $?`
	  elif [ $DDNS_TYPE = 4 ]; then
		updatedd noip $DDNS_USER:$DDNS_PASSWORD $DDNS_DOMAIN_NAME
		ret=`echo $?`
	  elif [ $DDNS_TYPE = 3 ]; then
		echo "service-type=easydns" > /tmp/ipupdate.conf
		echo "user=$DDNS_USER:$DDNS_PASSWORD" >> /tmp/ipupdate.conf
		echo "host=$DDNS_DOMAIN_NAME" >> /tmp/ipupdate.conf
		echo "interface=$WAN" >> /tmp/ipupdate.conf
		echo "cache-file=/tmp/ez-ipupdate.cache" >> /tmp/ipupdate.conf
		ez-ipupdate -c /tmp/ipupdate.conf
		ret=`echo $?`
	  elif [ $DDNS_TYPE = 5 ]; then
		#killall -9 peanut 2> /dev/null
		rm -f /var/ddns/ddns_status 2> /dev/null
		rm -f /var/ddns/ddns_domain_name 2> /dev/null
		rm -f /var/ddns/ddns_user_type 2> /dev/null
		#orayddns -u $DDNS_USER -p $DDNS_PASSWORD -host $DDNS_DOMAIN_NAME &
		echo "Start peanut"
		peanut $DDNS_USER:$DDNS_PASSWORD 
		ret=`echo $?`
	  fi
	  if [ $ret = 0 ]; then
	    echo "`date +%s`|$WAN_IP:$DDNS_TYPE:$DDNS_USER:$DDNS_PASSWORD:$DDNS_DOMAIN_NAME" > /var/ddns_last_update
		echo "DDNS update successfully"
            break
	 else
	    echo "`date +%s`|$WAN_IP:$DDNS_TYPE:$DDNS_USER:$DDNS_PASSWORD:$DDNS_DOMAIN_NAME" > /var/ddns_last_update
                echo "DDNS update failed"
		sleep 10
	  fi
  else
      echo "ddns.sh: wan don't have ip or ddns conf is not changed"
	break
  fi
  done
  sleep $TIMEOUT && AFTER_SLEEP="1"
  if [ -f /var/ddns_last_update -a "$AFTER_SLEEP" = "1"]; then
      rm /var/ddns_last_update
  fi
done
} &
fi

