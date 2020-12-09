#!/bin/bash
find ./ -name "*.bin" >/tmp/tenda.list
for i in `cat /tmp/tenda.list`
do
    binwalk -Me $i
    echo $i
    rm $i
done
