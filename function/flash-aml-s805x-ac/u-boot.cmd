#!/bin/bash
setenv bootcmd
setenv autoload no
if sf probe; then
	if sf read $kernel_addr_r 0 0x120000; then
		if cmp.b $kernel_addr_r $ramdisk_addr_r 0x120000; then
			echo "SPI NOR MATCHES"
			bmp display $fdt_addr_r
		else
			echo "ERASING SPI NOR"
			if sf erase 0 +0x120000; then
				echo "WRITING FIRMWARE TO SPI NOR"
				if sf write $ramdisk_addr_r 0 0x120000; then
					echo "SPI NOR FLASHED"
					bmp display $fdt_addr_r
				else
					echo "SPI NOR FLASH FAILED!"
				fi
			else
				echo "SPI NOR ERASE FAILED!"
			fi
		fi
	else
		echo "SPI NOR READ FAILED!"
	fi
else
	echo "SPI NOR PROBE FAILED!"
fi
sleep 9999

