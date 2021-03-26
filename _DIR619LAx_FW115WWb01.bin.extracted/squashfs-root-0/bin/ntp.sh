#!/bin/sh  
#                                 
# script file to start ntp client

TOOL=flash
GETMIB="$TOOL get"
NTPTMP=/tmp/ntp_tmp
NTP_SERVER_ID=0
WAIT_TIME=0
LINKFILE=/etc/ppp/link
ETH1_IP=/var/eth1_ip
NTP_PROCESS=/var/ntp_run
success=0
eval `flash get WAN_DHCP`
eval `$GETMIB NTP_ENABLED`
WAIT_TIME=0
killall date 2> /dev/null
killall ntpclient 2> /dev/null
###########kill sleep that ntp.sh created###############
TMPFILEDL=/tmp/tmpfiledl
line=0
ps | grep 'sleep 86400' > $TMPFILEDL
line=`cat $TMPFILEDL | wc -l`
num=1
while [ $num -le $line ];
do
	pat0=` head -n $num $TMPFILEDL | tail -n 1`
	pat1=`echo $pat0 | cut -f1 -dS`  
	pat2=`echo $pat1 | cut -f1 -d " "`  
	kill -9 $pat2 2> /dev/null
	num=`expr $num + 1`
done
rm -f /tmp/tmpfiledl 2> /dev/null

TMPFILEDL1=/tmp/tmpfiledl1
line1=0
ps | grep 'sleep 300' > $TMPFILEDL1
line1=`cat $TMPFILEDL1 | wc -l`
num1=1
while [ $num1 -le $line1 ];
do
	dl_pat0=` head -n $num1 $TMPFILEDL1 | tail -n 1`
	dl_pat1=`echo $dl_pat0 | cut -f1 -dS`  
	dl_pat2=`echo $dl_pat1 | cut -f1 -d " "`  
	kill -9 $dl_pat2 2> /dev/null
	num1=`expr $num1 + 1`
done
rm -f /tmp/tmpfiledl1 2> /dev/null
###########################

eval `$GETMIB DAYLIGHT_SAVE`
eval `$GETMIB DL_SAVE_OFFSET`

## Web UI can set -2/-1.5/-1/-0.5/0.5/1/1.5/2 hours
## DL_SAVE_OFFSET's unit is Second and base is 0 (-2:0/-1.5:1800/-1:3600/-0.5:5400/0.5:9000/1:10800/1.5:12600/2:14400)
##	change to minutes (-2:-120/-1.5:-90/-1:-60/-0.5:-30/0.5:30/1:60/1.5:90/2:120)

if [ $DAYLIGHT_SAVE = 1 ];then
	DAYLIGHT_MIN=""
	if [ "$DL_SAVE_OFFSET" = '0' ]; then
		DAYLIGHT_MIN="-120"
	elif [ "$DL_SAVE_OFFSET" = '1800' ]; then
		DAYLIGHT_MIN="-90"
	elif [ "$DL_SAVE_OFFSET" = '3600' ]; then
		DAYLIGHT_MIN="-60"
	elif [ "$DL_SAVE_OFFSET" = '5400' ]; then
		DAYLIGHT_MIN="-30"
	elif [ "$DL_SAVE_OFFSET" = '9000' ]; then
		DAYLIGHT_MIN="30"
	elif [ "$DL_SAVE_OFFSET" = '10800' ]; then
		DAYLIGHT_MIN="60"
	elif [ "$DL_SAVE_OFFSET" = '12600' ]; then
		DAYLIGHT_MIN="90"
	elif [ "$DL_SAVE_OFFSET" = '14400' ]; then
		DAYLIGHT_MIN="120"
	fi
fi
			

if [ $NTP_ENABLED = 1 ]; then
	echo Start NTP daemon
	rm -f /tmp/ntp_success 2> /dev/null	
	while [ true ];
	do
	eval `$GETMIB NTP_SERVER_IP1`
	#eval `$GETMIB NTP_SERVER_IP2`
	eval `$GETMIB NTP_TIMEZONE`
	eval `$GETMIB NTP_SERVER_ID`
	eval `$GETMIB DL_START_MONTH`
	eval `$GETMIB DL_START_WEEK`
	eval `$GETMIB DL_START_DAY`
	eval `$GETMIB DL_END_MONTH`
	eval `$GETMIB DL_END_WEEK`
	eval `$GETMIB DL_END_DAY`
	eval `$GETMIB DL_START_DATE`
	eval `$GETMIB DL_END_DATE`
	eval `$GETMIB DL_START_HOUR`
	eval `$GETMIB DL_END_HOUR`


	echo "run" > /var/ntp_run
	# rock: VOIP_SUPPORT is decided by mkimg
	###VOIP_SUPPORT###
	if [ "$VOIP_SUPPORT" != "" ] && [ -f "/bin/ash" ]; then
		TZ1=`echo $NTP_TIMEZONE | cut -d"\\\\" -f1`
	else
		TZ1=`echo $NTP_TIMEZONE | cut -d" " -f1`
	fi
	TZ2=`echo $NTP_TIMEZONE | cut -d" " -f2`
                DAYLIGHT=""
                if [ $DAYLIGHT_SAVE = 0 ];then
                	DAYLIGHT=""
                else
                  DAYLIGHT="PDT,J$DL_START_DATE/$DL_START_HOUR,J$DL_END_DATE/$DL_END_HOUR"
                fi

                TZ_HALF="0"

                if [ "$TZ1" = '3' ] && [ "$TZ2" = '1' ]; then
                       TZ_HALF="-1"
                fi
                if [ "$TZ1" = '4' ] && [ "$TZ2" = '3' ]; then
                       TZ_HALF="-1"
                fi
                if [ "$TZ1" = '-3' ] && [ "$TZ2" = '4' ]; then
                       TZ_HALF="1"
                fi
                if [ "$TZ1" = '-4' ] && [ "$TZ2" = '3' ]; then
                       TZ_HALF="1"
                fi
                if [ "$TZ1" = '-5' ] && [ "$TZ2" = '3' ]; then
                       TZ_HALF="1"
                fi
                if [ "$TZ1" = '-6' ] && [ "$TZ2" = '2' ]; then
                       TZ_HALF="1"
                fi                
                if [ "$TZ1" = '-9' ] && [ "$TZ2" = '4' ]; then
                       TZ_HALF="1"
                fi
                if [ "$TZ1" = '-9' ] && [ "$TZ2" = '5' ]; then
                       TZ_HALF="1"
                fi

                if [ "$TZ_HALF" = "1" -o "$TZ_HALF" = "-1" ]; then
					COMMAND="GMT$TZ1:30$DAYLIGHT"                  
                else
					COMMAND="GMT$TZ1$DAYLIGHT"
                fi

		if [ $NTP_SERVER_ID = 0 ];then
			ntpserver=$NTP_SERVER_IP1
		else
			ntpserver=$NTP_SERVER_IP2
		fi
		
			if [ $success = 0 ]; then
					#ntpdate  $NTP_SERVER_IP 
			                echo "" > $NTPTMP
			                
					ntpclient -s -h $ntpserver -i 5 > $NTPTMP
					if [ $? = 0 ]; then
					if [ -n "`cat $NTPTMP`" ];then
						echo ntp client success
						echo "1" > /tmp/ntp_success
						success=1
					else
						success=0
					fi
					else
						success=0
					fi	
					
					if [ $success = 1 ] ;then
					
						echo $COMMAND > /etc/TZ		
			                   	echo "" > $NTPTMP
			                   	date > $NTPTMP
			                   	
						if [ -n "`cat $NTPTMP`" ];then
							TZ_STR=`cat $NTPTMP | cut -d" " -f3`
							if [ "$TZ_STR" = "" ]; then
								TZ_STR=`cat $NTPTMP | cut -d" " -f6`
							else    
								TZ_STR=`cat $NTPTMP | cut -d" " -f5`
							fi
							
							if [ "$TZ_STR" = 'PDT' ]; then
			#					echo "$TZ1 $TZ_HALF 1" > /proc/tz 
								echo "$TZ1 $TZ_HALF $DAYLIGHT_MIN" > /proc/tz 
			
							elif [ "$TZ_STR" = 'GMT' ]; then
								echo "$TZ1 $TZ_HALF 0" > /proc/tz
			                        	fi
							
						fi 	
			                   	
					else
						sleep 300
						
					fi
				fi	
					
					
					if [ $success = 1 ] ;then
						if [ -n "`cat $NTPTMP`" ];then
							sleep 86400
							success=0
						fi
					fi
	done &
else	
	echo "0 0 0" > /proc/tz 
fi # NTP Enabled
