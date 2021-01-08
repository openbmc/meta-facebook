#!/bin/sh

POWER_STATUS_SERVICE="xyz.openbmc_project.State.Chassis"
POWER_STATUS_OBJPATH="/xyz/openbmc_project/state/chassis"
POWER_STATUS_INTERFACE="xyz.openbmc_project.State.Chassis"
POWER_STATUS_PROPERTY="CurrentPowerState"

LED_SERVICE="xyz.openbmc_project.LED.GroupManager"
LED_POWER_OBJPATH="/xyz/openbmc_project/led/groups/power_led"
LED_ENCLOSURE_IDENTIFY="/xyz/openbmc_project/led/groups/enclosure_identify"
LED_INTERFACE="xyz.openbmc_project.Led.Group"
LED_PROPERTY="Asserted"

LED_POWER_ON_OBJPATH="/xyz/openbmc_project/led/groups/power_on_led"
LED_POWER_OFF_OBJPATH="/xyz/openbmc_project/led/groups/power_off_led"
LED_SYSTEM_ON_OBJPATH="/xyz/openbmc_project/led/groups/system_on_led"
LED_SYSTEM_OFF_OBJPATH="/xyz/openbmc_project/led/groups/system_off_led"

KNOB_SELECTOR_SERVICE="xyz.openbmc_project.Chassis.Buttons"
KNOB_SELECTOR_OBJPATH="/xyz/openbmc_project/Chassis/Buttons/Selector0"
KNOB_SELECTOR_INTERFACE="xyz.openbmc_project.Chassis.Buttons.Selector"
KNOB_SELECTOR_PROPERTY="Position"

OBJECT_MAPPER_NAME="xyz.openbmc_project.ObjectMapper"
OBJECT_MAPPER_PATH="/xyz/openbmc_project/object_mapper"
OBJECT_MAPPER_INTERFACE="xyz.openbmc_project.ObjectMapper"

SENSOR_PATH="/xyz/openbmc_project/sensors"
SENSOR_OBJECT="xyz.openbmc_project.IpmbSensor"
SENSOR_INTERFACE="xyz.openbmc_project.Sensor.Threshold.Critical"
SENSOR_HIGH_PROPERTY="CriticalAlarmHigh"
SENSOR_LOW_PROPERTY="CriticalAlarmLow"

echo 792 > /sys/class/gpio/export
echo low > /sys/class/gpio/gpio792/direction

health() {

    health_status="Good"
    sensor=$(busctl call $OBJECT_MAPPER_NAME $OBJECT_MAPPER_PATH $OBJECT_MAPPER_INTERFACE \
             GetSubTreePaths sias $SENSOR_PATH 0 1 $SENSOR_INTERFACE)

    for i in $sensor;
    do
      host=$( echo $i | grep -o "/$1_*")
      if [ "$host" ]
      then
           path=$( echo $i | cut -d'"' -f2)
           critical_low=$(busctl get-property $SENSOR_OBJECT $path $SENSOR_INTERFACE $SENSOR_LOW_PROPERTY \
                          |  awk '{print $NF;}')
           critical_high=$(busctl get-property $SENSOR_OBJECT $path $SENSOR_INTERFACE $SENSOR_HIGH_PROPERTY \
                           |  awk '{print $NF;}')

           if [ "$critical_low" = "true" ] || [ "$critical_high" = "true" ]
           then
                health_status="Bad"
           fi
      fi
    done
}

power() {

    power_status=$(busctl get-property $POWER_STATUS_SERVICE$1 $POWER_STATUS_OBJPATH$1 $POWER_STATUS_INTERFACE \
                   $POWER_STATUS_PROPERTY | cut -d'"' -f2 | cut -d"." -f6)
}

led() {

    busctl set-property $LED_SERVICE $1$2 $LED_INTERFACE $LED_PROPERTY b $3
}

while true; do

    sled_identify=$(busctl get-property $LED_SERVICE $LED_ENCLOSURE_IDENTIFY $LED_INTERFACE $LED_PROPERTY \
                    | awk '{print $NF;}')

    if [ "$sled_identify" = "true" ]
    then
         led $LED_POWER_OBJPATH 0 false
         led $LED_POWER_OBJPATH 1 true
         led $LED_POWER_ON_OBJPATH 1 false
         led $LED_POWER_ON_OBJPATH 2 false
         led $LED_POWER_ON_OBJPATH 3 false
         led $LED_POWER_ON_OBJPATH 4 false
         led $LED_POWER_OFF_OBJPATH 1 false
         led $LED_POWER_OFF_OBJPATH 2 false
         led $LED_POWER_OFF_OBJPATH 3 false
         led $LED_POWER_OFF_OBJPATH 4 false
         led $LED_SYSTEM_ON_OBJPATH 1 false
         led $LED_SYSTEM_ON_OBJPATH 2 false
         led $LED_SYSTEM_ON_OBJPATH 3 false
         led $LED_SYSTEM_ON_OBJPATH 4 false
         led $LED_SYSTEM_OFF_OBJPATH 1 false
         led $LED_SYSTEM_OFF_OBJPATH 2 false
         led $LED_SYSTEM_OFF_OBJPATH 3 false
         led $LED_SYSTEM_OFF_OBJPATH 4 false

    else

         position=$(busctl get-property $KNOB_SELECTOR_SERVICE $KNOB_SELECTOR_OBJPATH $KNOB_SELECTOR_INTERFACE $KNOB_SELECTOR_PROPERTY \
                    |  awk '{print $NF;}')
         echo "Knob Position : $position"

         if [ "$position" = "5" ]
         then
              led $LED_POWER_ON_OBJPATH 1 false
              led $LED_POWER_ON_OBJPATH 2 false
              led $LED_POWER_ON_OBJPATH 3 false
              led $LED_POWER_ON_OBJPATH 4 false
              led $LED_POWER_OFF_OBJPATH 1 false
              led $LED_POWER_OFF_OBJPATH 2 false
              led $LED_POWER_OFF_OBJPATH 3 false
              led $LED_POWER_OFF_OBJPATH 4 false
              led $LED_SYSTEM_ON_OBJPATH 1 false
              led $LED_SYSTEM_ON_OBJPATH 2 false
              led $LED_SYSTEM_ON_OBJPATH 3 false
              led $LED_SYSTEM_ON_OBJPATH 4 false
              led $LED_SYSTEM_OFF_OBJPATH 1 false
              led $LED_SYSTEM_OFF_OBJPATH 2 false
              led $LED_SYSTEM_OFF_OBJPATH 3 false
              led $LED_SYSTEM_OFF_OBJPATH 4 false
              led $LED_POWER_OBJPATH 1 false
              led $LED_POWER_OBJPATH 0 true

         elif [ "$position" = "1" ] || [ "$position" = "2" ] || [ "$position" = "3" ] || [ "$position" = "4" ]
         then

              power $position
              echo "Power status $position : $power_status"

              led $LED_POWER_OBJPATH 0 false
              led $LED_POWER_OBJPATH 1 true

              health $position
              echo "Health status $position : $health_status"

              if [ "$power_status" = "On" ] && [ "$health_status" = "Good" ]
              then
                   led $LED_POWER_OFF_OBJPATH $position false
                   led $LED_SYSTEM_ON_OBJPATH $position false
                   led $LED_SYSTEM_OFF_OBJPATH $position false
                   led $LED_POWER_ON_OBJPATH $position true

              elif [ "$power_status" = "Off" ] && [ "$health_status" = "Good" ]
              then
                   led $LED_POWER_ON_OBJPATH $position false
                   led $LED_SYSTEM_ON_OBJPATH $position false
                   led $LED_SYSTEM_OFF_OBJPATH $position false
                   led $LED_POWER_OFF_OBJPATH $position true

              elif [ "$power_status" = "On" ] && [ "$health_status" = "Bad" ]
              then
                   led $LED_POWER_ON_OBJPATH $position false
                   led $LED_POWER_OFF_OBJPATH $position false
                   led $LED_SYSTEM_OFF_OBJPATH $position false
                   led $LED_SYSTEM_ON_OBJPATH $position true

              elif [ "$power_status" = "Off" ] && [ "$health_status" = "Bad" ]
              then
                   led $LED_POWER_ON_OBJPATH $position false
                   led $LED_POWER_OFF_OBJPATH $position false
                   led $LED_SYSTEM_ON_OBJPATH $position false
                   led $LED_SYSTEM_OFF_OBJPATH $position true
              fi
         fi
    fi
done
