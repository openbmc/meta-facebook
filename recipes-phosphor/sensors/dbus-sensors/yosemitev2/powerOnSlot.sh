#!/bin/bash
# Power on the slots if NIC sensor's values goes low.

PATH=/sbin:/bin:/usr/sbin:/usr/bin
echo "Power on the slots if NIC sensor's values goes low ::"

# Power on the slots. 
powerOnSlot()
{
    for i in 1 2 3 4
    do
        slot_id=$i
        echo "chosen slot id :::$slot_id"

        # 12V power on
        output=$(busctl set-property xyz.openbmc_project.State.Chassis$slot_id /xyz/openbmc_project/state/chassis_system$slot_id xyz.openbmc_project.State.Chassis RequestedPowerTransition s xyz.openbmc_project.State.Chassis.Transition.On)
        echo $output
 
    done
}

powerOnSlot

