#!/bin/bash -e

num_gpio=$(snapctl get gpio-iface-count)
hardware_observe=$(snapctl get hardware-observe-iface)

# check which hook was connected
case "$1" in
    hardware-observe)
        hardware_observe=false
        snapctl set hardware-observe-iface=$hardware_observe
        ;;
    gpio)
        num_gpio=$(( num_gpio - 1))
        # don't error check to see that num_gpio is less than zero, we trust 
        # snapd wouldn't run disconnect hooks more times than the number of 
        # times you connected interfaces, right?
        snapctl set gpio-iface-count=$num_gpio
        ;;
    *)
        echo "unknown hook $1"
        exit 1
        ;;
esac

# check to see if we should stop the service now that some interfaces aren't 
# available anymore
if [ $num_gpio -lt 2 ] || [ $hardware_observe = false ]; then
    snapctl stop --disable "$SNAP_NAME.svc1"
fi
