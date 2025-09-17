#!/bin/bash

# --- Configuration ---
IPMIHOST=192.168.0.120    
IPMIUSER=root             
IPMIPW="calvin"           


# Set the desired fan speed percentage when in manual mode
FANSPEED=20

# Set the maximum temperature (in Celsius) before switching back to auto control
MAXTEMP=45


TEMP=$(ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW sdr type temperature | grep -m1 "Inlet" | awk '{print $10}' | awk '{print $1}' | tr -d '\n\r')

if [[ -z "$TEMP" ]]; then
    echo "$(date): ERROR: Could not read temperature from iDRAC. Exiting for safety." >&2
    # Enable auto control just in case something is wrong
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x01
    exit 1
fi

# Convert the desired fan speed percentage to hexadecimal
SPEEDHEX=$(printf "%x" "$FANSPEED")

# The main logic: Check if current temp is greater than the max allowed temp
if (( $(echo "$TEMP > $MAXTEMP" | bc -l) )); then
    # Temperature is too high! Switch to Automatic mode.
    echo "$(date): Temperature is too high ($TEMP C > $MAXTEMP C). Activating dynamic fan control!"
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x01
else
    # Temperature is OK. Switch to Manual mode and set the low speed.
    echo "$(date): Temperature is OK ($TEMP C <= $MAXTEMP C). Setting manual fan speed to $FANSPEED%."
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x01 0x00
    ipmitool -I lanplus -H $IPMIHOST -U $IPMIUSER -P $IPMIPW raw 0x30 0x30 0x02 0xff "0x$SPEEDHEX"
fi