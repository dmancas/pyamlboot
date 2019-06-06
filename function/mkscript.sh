#!/bin/bash
if [ -z "$1" ]; then
	echo "$0 inputfile"
	exit 1
fi
if [ ! -f "$1" ]; then
	echo "inputfile does not exist"
	exit 1
fi
mkimage -C none -A arm -T script -d "$1" "${1%.*}.scr"
