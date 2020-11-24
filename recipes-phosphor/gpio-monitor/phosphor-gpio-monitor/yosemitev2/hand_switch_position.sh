#!/bin/sh
# Set the phoshpor-buttons Positions property

SERVICE="xyz.openbmc_project.Chassis.Buttons"
OBJECT="/xyz/openbmc_project/Chassis/Buttons/Selector0"
INTERFACE="xyz.openbmc_project.Chassis.Buttons.Selector"
PROPERTY="Position"

systemctl stop phosphor-multi-gpio-monitor.service
# Get current state
state1=$(gpioget 0 212)  #HAND_SW1
state2=$(gpioget 0 213)  #HAND_SW2
state3=$(gpioget 0 214)  #HAND_SW3
state4=$(gpioget 0 215)  #HAND_SW4

systemctl start phosphor-multi-gpio-monitor.service

target=$(($target+$state1*1))
target=$(($target+$state2*2))
target=$(($target+$state3*4))
target=$(($target+$state4*8))
target=$(($target+1))

#target=6

if [ $target -eq 6 ] || [ $target -eq 1 ]
then
 tmp=1
  echo  "SW Position : [Host1]...."
  gpioset 0 32=0 #DEBUG_UART_SEL_0
  gpioset 0 33=0 #DEBUG_UART_SEL_1
  gpioset 0 34=0 #DEBUG_UART_SEL_2
  prsnt=$(gpioget 0 139) #DEBUG_PORT_UART_SEL_BMC_N
  if [ $prsnt -eq 1 ]
  then
    gpioset 0 35=0  #DEBUG_UART_RX_SEL_N
    echo  "Debug card present"
  else
    gpioset 0 35=1
    echo  "Debug card not present"
  fi

elif [ $target -eq 7 ] || [ $target -eq 2 ]
then
 tmp=2
 echo  "SW Position : [Host2]...."
  gpioset 0 32=1
  gpioset 0 33=0
  gpioset 0 34=0
  prsnt=$(gpioget 0 139)
  if [ $prsnt -eq 1 ] 
  then 
    gpioset 0 35=0
  else
    gpioset 0 35=1
  fi

elif [ $target -eq 8 ] || [ $target -eq 3 ]
then
 tmp=3
 echo  "SW Position : [Host3]...."
  gpioset 0 32=0
  gpioset 0 33=1
  gpioset 0 34=0
  prsnt=$(gpioget 0 139)
  if [ $prsnt -eq 1 ] 
  then 
    gpioset 0 35=0
  else
    gpioset 0 35=1
  fi

elif [ $target -eq 9 ] || [ $target -eq 4 ]
then
 tmp=4
 echo  "SW Position : [Host4]...."
  gpioset 0 32=1
  gpioset 0 33=1
  gpioset 0 34=0
  prsnt=$(gpioget 0 139)
  if [ $prsnt -eq 1 ]
  then 
    gpioset 0 35=0
  else
    gpioset 0 35=1
  fi

elif [ $target -eq 10 ] || [ $target -eq 5 ]
then
 tmp=5
 echo  "SW Position : [BMC]...."
  gpioset 0 32=0
  gpioset 0 33=0
  gpioset 0 34=1
  gpioset 0 35=1

else
   echo  "Position not match"
fi

echo  "Position : $tmp"

# Set target state
busctl set-property $SERVICE $OBJECT $INTERFACE $PROPERTY q $tmp
