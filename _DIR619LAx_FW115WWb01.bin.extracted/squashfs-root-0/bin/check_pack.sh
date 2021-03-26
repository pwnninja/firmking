#!/bin/sh

eval `flash get HW_11N_RESERVED8`
if [ $HW_11N_RESERVED8 = 1 ]; then
	mount -t squashfs /dev/mtdblock2 /web-lang
fi

