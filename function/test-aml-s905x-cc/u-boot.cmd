#!/bin/bash
setenv bootcmd
setenv autoload no
echo "READING FIRMWARE FROM USB"
if fatload usb 0 $kernel_addr_r aml-s805x-ac.bin; then
	echo "READING FIRMWARE FROM EMMC"
	if fatload mmc 0 $ramdisk_addr_r aml-s805x-ac.bin; then
		echo "COMPARING FIRMWARE"
		if cmp.b $kernel_addr_r $ramdisk_addr_r $filesize; then
			echo "DETECTING SPI NOR"
			if sf probe; then
				if sf read $ramdisk_addr_r 0 $filesize; then
					if cmp.b $kernel_addr_r $ramdisk_addr_r $filesize; then
						echo "SPI NOR MATCHES"
						if dhcp; then
							echo "SUCCESSFUL!"
							fatload usb 0 $kernel_addr_r OK.BMP
						else
							echo "NETWORK FAILED!"
							fatload usb 0 $kernel_addr_r NETWORK.BMP
						fi
					else
						echo "ERASING SPI NOR"
						if sf erase 0 +$filesize; then
							echo "WRITING FIRMWARE TO SPI NOR"
							if sf write $fileaddr 0 $filesize; then
								echo "GETTING IP FROM DHCP"
								if dhcp; then
									echo "SUCCESSFUL!"
									fatload usb 0 $kernel_addr_r OK.BMP
								else
									echo "NETWORK FAILED!"
									fatload usb 0 $kernel_addr_r NETWORK.BMP
								fi
							else
								echo "FLASH FAILED!"
								fatload usb 0 $kernel_addr_r SPINORWRITE.BMP
							fi
						else
							echo "ERASE FAILED!"
							fatload usb 0 $kernel_addr_r SPINORERASE.BMP
						fi
					fi
				else
					echo "SPI READ FAILED!"
					fatload usb 0 $kernel_addr_r SPINORREAD.BMP
				fi
			else
				echo "SPI PROBE FAILED!"
				fatload usb 0 $kernel_addr_r SPINORPROBE.BMP
			fi
		else
			echo "USB EMMC MISMATCH!"
			fatload usb 0 $kernel_addr_r USBEMMC.BMP
		fi
	else
		echo "EMMC FAILED!"
		fatload usb 0 $kernel_addr_r EMMC.BMP
	fi
else
	echo "USB LOAD FAILED"
fi
bmp display $kernel_addr_r
sleep 9999
