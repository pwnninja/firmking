#!/bin/bash
find ./ -name "httpd" >/tmp/tenda.list
dst=/root/
brand=tenda/
mkdir -p $dst$brand
for i in `cat /tmp/tenda.list`
do
	var=${i//.//_}
	var=${var////_}
	var=${var//__/_}
    target=$dst$brand$var
    cp $i $target
    echo $i
done