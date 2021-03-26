#!/bin/sh
killall -9 pppoe.sh 2>/dev/null
killall -9 pptp.sh 2>/dev/null
TMPFILE=/tmp/tmpfile
line=0
ps | grep '\.sh' | grep -v boa-dog.sh > $TMPFILE
line=`cat $TMPFILE | wc -l`
num=1
while [ $num -le $line ];
do
	pat0=` head -n $num $TMPFILE | tail -n 1`
	pat1=`echo $pat0 | cut -f1 -dS`  
	pat2=`echo $pat1 | cut -f1 -d " "`  
	kill -9 $pat2 2> /dev/null

	num=`expr $num + 1`
done

