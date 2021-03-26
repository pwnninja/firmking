#!/bin/sh
url_conf=/var/url.conf
rm /var/url.conf 2>/dev/null
killall dnrd 2>/dev/null

eval `flash get DOMAINFILTER_ENABLED`
eval `flash get DOMAINFILTER_TBL_NUM`
eval `flash get NAT_ENABLED`

if [ $DOMAINFILTER_ENABLED = 1 ] && [ $NAT_ENABLED -gt 0 ];then
  echo "$DOMAINFILTER_ENABLED"> $url_conf
  num=1
  while [ $num -le $DOMAINFILTER_TBL_NUM ];
  do
    str=`flash get DOMAINFILTER_TBL | grep DOMAINFILTER_TBL$num=`
    str=`echo $str | cut -f2 -d=`

    if [ ! -z $str ]; then
	    echo "$str">> $url_conf
    fi

    num=`expr $num + 1`
    
  done
else
	echo "0"> $url_conf
fi

