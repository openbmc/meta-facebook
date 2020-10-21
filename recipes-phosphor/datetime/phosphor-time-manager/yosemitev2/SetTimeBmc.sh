#!/bin/bash
#BMC set time

PATH=/sbin:/bin:/usr/sbin:/usr/bin
echo "SetTimeBmc has been called with service time-manager-bmc-set-time.service::"
# Sync BMC's date with one of the four servers
sync_date()
{
    for i in 1 2 3 4
    do
        slot_id=$(((i-1)*4))
        # Use standard IPMI command 'SendRequest method' to read RTC time
        echo "chosen slot id :::$slot_id"
        output=$(busctl call xyz.openbmc_project.Ipmi.Channel.Ipmb /xyz/openbmc_project/Ipmi/Channel/Ipmb org.openbmc.Ipmb sendRequest yyyyay $slot_id 0x38 0 0x2 6 0x15 0xA0 0x0 0x1 0x28 0x48)
        echo $output
        if [[ $(echo "$output" | awk '{ print NF }') -eq 18 ]];
        then
        echo Syncing up BMC time with server$i...
        date -s @$((0x$(echo "$output" | awk '{printf "%02x%02x%02x%02x",$18,$17,$16,$15}')))
        test -x /etc/init.d/hwclock.sh && /etc/init.d/hwclock.sh stop
        echo 1 > /tmp/sync_date
        break
        fi
    done
}

sync_date
