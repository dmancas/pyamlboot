#!/bin/bash

set -ex

if [ -z "$1" ]; then
	exit 1
fi

if [ "$1" != "libretech-ac" ]; then
	exit 1
fi

SOURCE_DIR=$(readlink -f $(dirname ${BASH_SOURCE[0]}))
cd $SOURCE_DIR/../..

echo "`date '+%Y-%m-%d %H:%M:%S'` START" >> $SOURCE_DIR/run.log

./boot.py "$1" --ramfs $SOURCE_DIR/../../files/libretech-ac/u-boot.bin.spi --fdt $SOURCE_DIR/../../files/images/OK.BMP --script $SOURCE_DIR/u-boot.scr

echo "`date '+%Y-%m-%d %H:%M:%S'` END" >> $SOURCE_DIR/run.log
