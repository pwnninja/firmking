#!/bin/sh
image_sign=`cat /etc/alpha_config/image_sign`
echo "Start telnetd ..." > /dev/console
if [ -f "/usr/bin/login" ]; then
	telnetd -l "/usr/bin/login" -u Alphanetworks:$image_sign -i br0 &
else
	telnetd &
fi
