#!/bin/sh

POWER_CMD="/usr/sbin/power-util mb"
OUT=/var/log/bios.update
IMAGE_FILE=$1/bios.bin
GPIO=389

IPMB_OBJ="xyz.openbmc_project.Ipmi.Channel.Ipmb"
IPMB_PATH="/xyz/openbmc_project/Ipmi/Channel/Ipmb"
IPMB_INTF="org.openbmc.Ipmb"
IPMB_CALL="sendRequest yyyyay"
ME_CMD_RECOVER="1 0x2e 0 0xdf 4 0x57 0x01 0x00 0x01"
ME_CMD_RESET="1 6 0 0x2 0"

set_gpio_to_bmc()
{
	echo "switch bios GPIO to bmc" >> $OUT
	if [ ! -d /sys/class/gpio/gpio$GPIO ]; then
		cd /sys/class/gpio
		echo $GPIO > export
		cd gpio$GPIO
	else
		cd /sys/class/gpio/gpio$GPIO
	fi
	direc=`cat direction`
	if [ $direc == "in" ]; then
		echo "out" > direction
	fi
	data=`cat value`
	if [ "$data" == "0" ]; then
		echo 1 > value
	fi
	return 0
}

set_gpio_to_pch()
{
	echo "switch bios GPIO to pch" >> $OUT
	if [ ! -d /sys/class/gpio/gpio$GPIO ]; then
		cd /sys/class/gpio
		echo $GPIO > export
		cd gpio$GPIO
	else
		cd /sys/class/gpio/gpio$GPIO
	fi
	direc=`cat direction`
	if [ $direc == "in" ]; then
		echo "out" > direction
	fi
	data=`cat value`
	if [ "$data" == "1" ]; then
		echo 0 > value
	fi
	echo "in" > direction
	echo $GPIO > /sys/class/gpio/unexport
	return 0
}

echo "Bios upgrade started at $(date)" > $OUT

#Power off host server.
echo "Power off host server" >> $OUT
$POWER_CMD off
sleep 15
if [ $($POWER_CMD status) != "off" ];
then
    echo "Host server didn't power off" >> $OUT
    echo "Bios upgrade failed" >> $OUT
    exit -1
fi
echo "Host server powered off" >> $OUT

#Set ME to recovery mode
echo "Set ME to recovery mode" >> $OUT
busctl call $IPMB_OBJ $IPMB_PATH $IPMB_INTF $IPMB_CALL $ME_CMD_RECOVER > /dev/null
sleep 5

#Flip GPIO to access SPI flash used by host.
echo "Set GPIO $GPIO to access SPI flash from BMC used by host" >> $OUT
set_gpio_to_bmc

#Bind spi driver to access flash
echo "bind aspeed-smc spi driver" >> $OUT
echo -n 1e630000.spi > /sys/bus/platform/drivers/aspeed-smc/bind
sleep 1

#Flashcp image to device.
if [ -e "$IMAGE_FILE" ];
then
    echo "Bios image is $IMAGE_FILE" >> $OUT

    if [ -e "/dev/mtd6" ]; then
        mtd6=`cat /sys/class/mtd/mtd6/name`
        if [ $mtd6 == "pnor" ]; then
            echo "Flashing bios image to mtd6..." >> $OUT
            flashcp -v $IMAGE_FILE /dev/mtd6
            if [ $? -eq 0 ]; then
                echo "bios updated successfully..." >> $OUT
            else
                echo "bios update failed..." >> $OUT
            fi
        fi
    fi

    if [ -e "/dev/mtd7" ]; then
        mtd7=`cat /sys/class/mtd/mtd7/name`
        if [ $mtd7 == "pnor" ]; then
            echo "Flashing bios image to mtd7..." >> $OUT
            flashcp -v $IMAGE_FILE /dev/mtd7
            if [ $? -eq 0 ]; then
                echo "bios updated successfully..." >> $OUT
            else
                echo "bios update failed..." >> $OUT
            fi
        fi
    fi
else
    echo "Bios image $IMAGE_FILE doesn't exist" >> $OUT
fi

#Unbind spi driver
echo "Unbind aspeed-smc spi driver" >> $OUT
echo -n 1e630000.spi > /sys/bus/platform/drivers/aspeed-smc/unbind
sleep 10

#Flip GPIO back for host to access SPI flash
echo "Set GPIO $GPIO back for host to access SPI flash" >> $OUT
set_gpio_to_pch
sleep 5

#Reset ME to boot from new bios
echo "Reset ME to boot from new bios" >> $OUT
busctl call $IPMB_OBJ $IPMB_PATH $IPMB_INTF $IPMB_CALL $ME_CMD_RESET > /dev/null
sleep 10

#Power on server.
echo "Power on server" >> $OUT
$POWER_CMD on
sleep 5

if [ $($POWER_CMD status) != "on" ];
then
    sleep 5
    echo "Powering on server again" >> $OUT
    $POWER_CMD on
fi
