#!/bin/sh
CONF=/etc/bpalogin.conf

eval `flash get BPA_USER_NAME`
eval `flash get BPA_PASSWORD`
eval `flash get BPA_SERVER_IP_ADDR`
eval `flash get BPA_AUTH_SERVER`


echo "username $BPA_USER_NAME" > $CONF  
echo "password $BPA_PASSWORD" >> $CONF  
echo "localport 5050" >> $CONF
if [ "$BPA_SERVER_IP_ADDR" != '0.0.0.0' ]; then
  echo "authserver $BPA_SERVER_IP_ADDR" >> $CONF  
elif [ $BPA_AUTH_SERVER = 1 ]; then
  echo "authserver dce-server" >> $CONF  
else
  echo "authserver sm-server" >> $CONF  
fi
  
bpalogin -c /etc/bpalogin.conf

