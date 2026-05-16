#!/bin/bash

# http://aaronlasseigne.com/2012/10/15/battery-life-in-the-land-of-tmux/

# all green if external connected power and fully charged
# last heart green if charging
# otherwise red

HEART='♥'

if [[ `uname` == 'Linux' ]]; then
  current_charge=$(cat /proc/acpi/battery/BAT1/state | grep 'remaining capacity' | awk '{print $3}')
  total_charge=$(cat /proc/acpi/battery/BAT1/info | grep 'last full capacity' | awk '{print $4}')
else
  battery_info=`ioreg -rc AppleSmartBattery`
  current_charge=$(echo $battery_info | grep -o '"CurrentCapacity" = [0-9]\+' | awk '{print $3}')
  total_charge=$(echo $battery_info | grep -o '"MaxCapacity" = [0-9]\+' | awk '{print $3}')
  is_charging=$(echo $battery_info | grep -o "\"IsCharging\" = \(Yes\|No\)" | awk '{print $3}')
  externalconnected=$(echo $battery_info | grep -o "\"ExternalConnected\" = \(Yes\|No\)" | awk '{print $3}')
  fullycharged=$(echo $battery_info | grep -o "\"FullyCharged\" = \(Yes\|No\)" | awk '{print $3}')
fi

charged_slots=$(echo "(($current_charge/$total_charge)*10)+1" | bc -l | cut -d '.' -f 1)
if [[ $charged_slots -gt 10 ]]; then
  charged_slots=10
fi

if [[ $fullycharged == 'Yes' ]] && [[ $externalconnected == 'Yes' ]]; then
    # all green
    echo -n '#[fg=green]'
    for i in `seq 1 10`; do echo -n "$HEART"; done
elif [[ $is_charging == 'Yes' ]]; then
    # all red, last charged is green
    echo -n '#[fg=red]'
    for i in `seq 1 $(echo "$charged_slots-1" | bc)`; do echo -n "$HEART"; done
    echo -n "#[fg=colour10]$HEART"
    if [[ $charged_slots -lt 10 ]]; then
        echo -n '#[fg=colour8]'
        for i in `seq 1 $(echo "10-$charged_slots" | bc)`; do echo -n "$HEART"; done
    fi
else
    echo -n '#[fg=red]'
    for i in `seq 1 $charged_slots`; do echo -n "$HEART"; done
    if [[ $charged_slots -lt 10 ]]; then
        echo -n '#[fg=colour8]'
        for i in `seq 1 $(echo "10-$charged_slots" | bc)`; do echo -n "$HEART"; done
    fi
fi
