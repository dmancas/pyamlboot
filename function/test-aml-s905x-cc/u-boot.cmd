#!/bin/bash
setenv bootcmd
setenv autoload no
firmware=aml-s905x-cc.bin
echo "READING FIRMWARE FROM USB 1"
fatload usb 0 $kernel_addr_r $firmware
if test $? -eq 1; then
	echo "USB LOAD 1 FAILED"
	bmp display $kernel_addr_r
	sleep 9999
fi
afs=$filesize
echo "READING FIRMWARE FROM USB 2"
fatload usb 1 $ramdisk_addr_r $firmware
if test $? -eq 1; then
	echo "USB LOAD 2 FAILED"
	fatload usb 0 $kernel_addr_r USBLOAD2.BMP
	bmp display $kernel_addr_r
	sleep 9999
fi
bfs=$filesize
if test "${afs}" != "${bfs}"; then 
	echo "USB LOAD 2 MISMATCH FILESIZE"
	fatload usb 0 $kernel_addr_r USBLOAD-MS2.BMP
	bmp display $kernel_addr_r
	sleep 9999
fi
cmp.b $kernel_addr_r $ramdisk_addr_r $afs;
if test $? -eq 1; then
	echo "USB LOAD 2 MISMATCH FILECONTENT"
	fatload usb 0 $kernel_addr_r USBLOAD-MC2.BMP
	bmp display $kernel_addr_r
	sleep 9999
fi
echo "READING FIRMWARE FROM USB 3"
fatload usb 2 $ramdisk_addr_r $firmware
if test $? -eq 1; then
	echo "USB LOAD 3 FAILED"
	fatload usb 0 $kernel_addr_r USBLOAD3.BMP
	bmp display $kernel_addr_r
	sleep 9999
fi
bfs=$filesize
if test "${afs}" != "${bfs}"; then
	echo "USB LOAD 3 MISMATCH FILESIZE"
	fatload usb 0 $kernel_addr_r USBLOAD-MS3.BMP
	bmp display $kernel_addr_r
	sleep 9999
fi
cmp.b $kernel_addr_r $ramdisk_addr_r $afs
if test $? -eq 1; then
	echo "USB LOAD 3 MISMATCH FILECONTENT"
	fatload usb 0 $kernel_addr_r USBLOAD-MC3.BMP
	bmp display $kernel_addr_r
	sleep 9999
fi
echo "READING FIRMWARE FROM SD"
fatload mmc 0 $ramdisk_addr_r $firmware
if test $? -eq 1; then
	echo "SD LOAD FAILED"
	fatload usb 0 $kernel_addr_r SDLOAD.BMP
	bmp display $kernel_addr_r
	sleep 9999
fi
bfs=$filesize
if test "${afs}" != "${bfs}"; then
	echo "SD LOAD MISMATCH FILESIZE"
	fatload usb 0 $kernel_addr_r SDLOAD-MS.BMP
	bmp display $kernel_addr_r
	sleep 9999
fi
cmp.b $kernel_addr_r $ramdisk_addr_r $afs
if test $? -eq 1; then
	echo "SD LOAD MISMATCH FILECONTENT"
	fatload usb 0 $kernel_addr_r SDLOAD-MC.BMP
	bmp display $kernel_addr_r
	sleep 9999
fi
echo "READING FIRMWARE FROM EMMC"
fatload mmc 1 $ramdisk_addr_r $firmware
if test $? -eq 1; then
	echo "EMMC LOAD FAILED"
	fatload usb 0 $kernel_addr_r EMMCLOAD.BMP
	bmp display $kernel_addr_r
	sleep 9999
fi
bfs=$filesize
if test "${afs}" != "${bfs}"; then
	echo "EMMC LOAD MISMATCH FILESIZE"
	fatload usb 0 $kernel_addr_r EMMCLOAD-MS.BMP
	bmp display $kernel_addr_r
	sleep 9999
fi
cmp.b $kernel_addr_r $ramdisk_addr_r $afs
if test $? -eq 1; then
	echo "EMMC LOAD MISMATCH FILECONTENT"
	fatload usb 0 $kernel_addr_r EMMCLOAD-MC.BMP
	bmp display $kernel_addr_r
	sleep 9999
fi
if dhcp; then
	echo "SUCCESSFUL!"
	fatload usb 0 $kernel_addr_r OK.BMP
else
	echo "NETWORK FAILED!"
	fatload usb 0 $kernel_addr_r NETWORK.BMP
fi
bmp display $kernel_addr_r
sleep 9999
