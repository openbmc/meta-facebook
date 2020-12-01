#!/bin/bash
# Power off the slots when fan sensors crossed thresholds.

PATH=/sbin:/bin:/usr/sbin:/usr/bin
echo "Power off the slots if fansensors threshold crossed ::"

# Power off the slots. 
powerOffSlot()
{
    for i in 1 2 3 4
    do
        slot_id=$i
        echo "chosen slot id :::$slot_id"

        # 12V power off
        output=$(busctl set-property xyz.openbmc_project.State.Chassis$slot_id /xyz/openbmc_project/state/chassis_system$slot_id xyz.openbmc_project.State.Chassis RequestedPowerTransition s xyz.openbmc_project.State.Chassis.Transition.Off)
        echo $output
 
    done
}

powerOffSlot

