#!/bin/sh
#
#
# usage: web_url_filter init|delete|run
#

. /sbin/config.sh
. /sbin/global.sh

url_filter_en=`nvram_get 2860 urlFilterEnable`
url_filter=`nvram_get 2860 websURLFilters`
WEB_FILTER_CHAIN="web_url_filter" 

iptableWebUrlFilterInitClear()
{
	iptables -D FORWARD -j $WEB_FILTER_CHAIN  1>/dev/null 2>&1
	iptables -F $WEB_FILTER_CHAIN  1>/dev/null 2>&1
	iptables -t filter -X $WEB_FILTER_CHAIN  1>/dev/null 2>&1
}

iptableWebUrlFilterFlush()
{
	iptables -F $WEB_FILTER_CHAIN  1>/dev/null 2>&1
}

iptableWebUrlFilterInit()
{
	iptables -t filter -N $WEB_FILTER_CHAIN 1>/dev/null 2>&1
	iptables -t filter -A FORWARD -j $WEB_FILTER_CHAIN 1>/dev/null 2>&1
}

iptablesWebsFilterRun()
{
	OLD_IFS="$IFS"
	IFS=";"
	arr=$url_filter
	for s in $arr
	do
		temp=${s#http://}
		iptables -A $WEB_FILTER_CHAIN -i $lan_if -p tcp -m tcp -m webstr --url $temp -j REJECT --reject-with tcp-reset
	done
	IFS="$OLD_IFS"
}

echo "<<<<<<<<<<<<<<<< WEB URL FILTER >>>>>>>>>>>>>>>>>>>>>"
if [ "$1" = "" ];then

	if [ "$url_filter" = "" ];then
		exit 1
	else
		var=run
	fi
else
	var=$1
fi

case $var in
init)
iptableWebUrlFilterInit
iptablesWebsFilterRun
;;
delete)
iptableWebUrlFilterInitClear
;;
run)
if [ "$url_filter_en" = "1" ];then
	iptableWebUrlFilterFlush
	iptablesWebsFilterRun
else
	iptableWebUrlFilterFlush
fi
;;
*)
echo "usage: web_url_filter init|delete|run"
;;
esac
