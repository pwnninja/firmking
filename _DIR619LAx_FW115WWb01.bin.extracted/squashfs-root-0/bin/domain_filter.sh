#!/bin/sh
domainf_conf=/var/domain.conf
rm /var/domain.conf 2>/dev/null
killall dnrd 2>/dev/null

eval `flash get DOMAINFILTER_ENABLED`
eval `flash get DOMAINFILTER_TBL_NUM`
eval `flash get DOMAINPERMIT_ENABLED`
eval `flash get DOMAINPERMIT_TBL_NUM`
eval `flash get SCRLOG_ENABLED`
eval `flash get NAT_ENABLED`

if [ $DOMAINFILTER_TBL_NUM -gt 0 ] && [ $DOMAINFILTER_ENABLED = 1 ] && [ $NAT_ENABLED -gt 0 ];then
echo "$DOMAINFILTER_ENABLED">> $domainf_conf
echo "$SCRLOG_ENABLED">> $domainf_conf
  num=1
  while [ $num -le $DOMAINFILTER_TBL_NUM ];
  do
    str=`flash get DOMAINFILTER_TBL | grep DOMAINFILTER_TBL$num=`
    str=`echo $str | cut -f2 -d=`
    echo "$str">> $domainf_conf
    num=`expr $num + 1`
    
  done
elif [ $DOMAINPERMIT_TBL_NUM -gt 0 ] && [ $DOMAINPERMIT_ENABLED = 2 ] && [ $NAT_ENABLED -gt 0 ];then
echo "$DOMAINPERMIT_ENABLED">> $domainf_conf
echo "$SCRLOG_ENABLED">> $domainf_conf
  num=1
  while [ $num -le $DOMAINPERMIT_TBL_NUM ];
  do
    str=`flash get DOMAINPERMIT_TBL | grep DOMAINPERMIT_TBL$num=`
    str=`echo $str | cut -f2 -d=`
    echo "$str">> $domainf_conf
    num=`expr $num + 1`
    
  done
else
	echo "0">> $domainf_conf
fi


