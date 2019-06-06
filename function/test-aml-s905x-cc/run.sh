#!/bin/bash

set -ex

if [ -z "$1" ]; then
	exit 1
fi

if [ "$1" != "libretech-cc" ]; then
	exit 1
fi

SOURCE_DIR=$(readlink -f $(dirname ${BASH_SOURCE[0]}))
cd $SOURCE_DIR/../..

./boot.py "$1"

