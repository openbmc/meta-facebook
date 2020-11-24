#!/bin/sh
# Set the phoshpor-buttons Positions property

SERVICE="xyz.openbmc_project.Chassis.Buttons"
OBJECT="/xyz/openbmc_project/Chassis/Buttons/Selector0"
INTERFACE="xyz.openbmc_project.Chassis.Buttons.Selector"
PROPERTY="Position"

target=$(busctl get-property $SERVICE $OBJECT $INTERFACE $PROPERTY | awk '{print $NF;}')

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
  else
    gpioset 0 35=1
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

