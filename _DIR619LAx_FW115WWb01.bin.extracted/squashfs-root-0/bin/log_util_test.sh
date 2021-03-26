#!/bin/sh

SMTP_CONFIG=/tmp/smtp_config
LOG_SMTP_CONFIG="/tmp/mydlink_test_subject.log"

if [ -f "$SMTP_CONFIG" ]; then
	rm -f $SMTP_CONFIG
fi

eval `flash get SCRLOG_ENABLED`
if [ "$SCRLOG_ENABLED" != '0'  ]; then
	echo "log_capability:$SCRLOG_ENABLED;" > $SMTP_CONFIG
	eval `flash get SMTP_AUTH_ENABLED`
	eval `flash get EMAIL_NOTIFICATION`
	eval `flash get LOG_SEND_FROM`
	eval `flash get LOG_SEND_TO`
	eval `flash get SMTP_SERVER`
	eval `flash get WAN_DHCP`
	eval `flash get REMOTELOG_ENABLED`
	eval `flash get SUBNET_MASK`
	eval `flash get EMAIL_LOG_FULL`
	eval `flash get EMAIL_SUBJECT`
	eval `flash get SMTP_SECRET`
	eval `flash get SMTP_PORT`
	
	echo "subnet_ip:$SUBNET_MASK;" >> $SMTP_CONFIG
	echo "wan_if:$WAN_DHCP;" >> $SMTP_CONFIG
	
	
	if [ -n "$EMAIL_SUBJECT" ]; then
		#echo "mail_sub:$EMAIL_SUBJECT;" >> $SMTP_CONFIG
		cat /tmp/smtp_subject >> $SMTP_CONFIG
	fi
	
	if [ "$REMOTELOG_ENABLED" != '0' ]; then
		eval `flash get REMOTELOG_SERVER`
		echo "logsvr_ip:$REMOTELOG_SERVER;" >> $SMTP_CONFIG
	fi
	
	#if [ $EMAIL_NOTIFICATION != '0' ]; then
		echo "mail_log:$EMAIL_LOG_FULL;" >> $SMTP_CONFIG
			if [ -n "$LOG_SEND_FROM" ]; then
				echo "from_addr:$LOG_SEND_FROM;" >> $SMTP_CONFIG
			fi
		echo "to_addr:$LOG_SEND_TO;" >> $SMTP_CONFIG
		echo "smtp_svr:$SMTP_SERVER;" >> $SMTP_CONFIG
		if [ "$SMTP_AUTH_ENABLED" != '0' ]; then
			echo "auth_enable:$SMTP_AUTH_ENABLED;" >> $SMTP_CONFIG
			eval `flash get SMTP_USER_NAME`
			eval `flash get SMTP_PASSWORD`
			echo "user:$SMTP_USER_NAME;" >> $SMTP_CONFIG
			echo "pass:$SMTP_PASSWORD;" >> $SMTP_CONFIG
			echo "auth_ssl:$SMTP_SECRET;" >> $SMTP_CONFIG
			echo "smtp_port:$SMTP_PORT;" >> $SMTP_CONFIG
		else
			echo "auth_enable:0;" >> $SMTP_CONFIG
		fi
	#fi
fi

mailcontrol -g

eval `flash get SMTP_AUTH_ENABLED`
#add for E-mail log now!!,$1 = TYPE , mark
if [ "$1" != "" ]; then

        if [ "$SMTP_AUTH_ENABLED" = 0 ]; then
                email -j -W $LOG_SMTP_CONFIG -f $LOG_SEND_FROM -n "mydlink" -s  "$EMAIL_SUBJECT" -r "$SMTP_SERVER" -z "/tmp/mydlink_test.email" -p $SMTP_PORT $LOG_SEND_TO &
        else
		if [ "$SMTP_SECRET" = 1 ]; then
			email -j -W $LOG_SMTP_CONFIG -f $LOG_SEND_FROM -n "mydlink" -s  "$EMAIL_SUBJECT" -r "$SMTP_SERVER" -z "/tmp/mydlink_test.email" -p $SMTP_PORT -tls -m login -u $SMTP_USER_NAME -i $SMTP_PASSWORD $LOG_SEND_TO &
		else		
			email -j -W $LOG_SMTP_CONFIG -f $LOG_SEND_FROM -n "mydlink" -s  "$EMAIL_SUBJECT" -r "$SMTP_SERVER" -z "/tmp/mydlink_test.email" -p $SMTP_PORT -m login -u $SMTP_USER_NAME -i $SMTP_PASSWORD $LOG_SEND_TO &
		fi
	fi
#	if [ $1 -ge 32 ]; then
#		exlog /tmp/log_web.lck /tmp/log_web "" sendmail &   
#	else
#            exlog /tmp/log_web.lck /tmp/log_web "" sendmail &
#	fi
fi
