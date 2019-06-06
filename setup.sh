#!/bin/bash

set -ex

if [ "$USER" != "root" ]; then
        echo "Please run this as root or with sudo privileges."
        exit 1
fi

if [ -z "$1" ]; then
	echo "install uninstall"
	exit 1
fi

SOURCE_DIR=$(readlink -f $(dirname ${BASH_SOURCE[0]}))
cd $SOURCE_DIR

UDEV_RULE_FILE_PATH=/etc/udev/rules.d/85-aml-gxl.rules
SELF_FILE_PATH=`readlink -f ${BASH_SOURCE[0]}`

if [ "$1" = "install" ]; then
	if [ -z "$2" -o -z "$3" ]; then
		echo "please reference board and function"
		exit 1
	fi
	if [ ! -d "files/$2" ]; then
		echo "board does not exist"
		exit 1
	fi
	if [ ! -d "function/$3" ]; then
		echo "function does not exist"
		exit 1
	fi
	if [ ! -f "function/$3/run.sh" ]; then
		echo "function incomplete"
		exit 1
	fi
	if [ -f "$UDEV_RULE_FILE_PATH" ]; then
		echo "already installed"
		exit 1
	else
		tee "$UDEV_RULE_FILE_PATH" <<EOF
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1b8e", ATTR{idProduct}=="c003", RUN+="$SOURCE_DIR/function/$3/run.sh $2"
EOF
		if [ "$NOUDEV" -ne 1 ]; then
			udevadm control --reload-rules
			udevadm trigger
		fi
	fi
elif [ "$1" = "uninstall" ]; then
	if [ -f "$UDEV_RULE_FILE_PATH" ]; then
		rm "$UDEV_RULE_FILE_PATH"
		if [ "$NOUDEV" -ne 1 ]; then
			udevadm control --reload-rules
			udevadm trigger
		fi
	else
		exit 1
	fi
else
	echo "unknown command"
	exit 1
fi
