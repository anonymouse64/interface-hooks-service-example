#!/bin/bash -e

num_gpio=$(snapctl get gpio-iface-count)
hardware_observe=$(snapctl get hardware-observe-iface)

# check which hook was connected
case "$1" in
    hardware-observe)
        hardware_observe=true
        snapctl set hardware-observe-iface=$hardware_observe
        ;;
    gpio)
        num_gpio=$(( num_gpio + 1))
        snapctl set gpio-iface-count=$num_gpio
        ;;
    *)
        echo "unknown hook $1"
        exit 1
        ;;
esac

# check to see if we have at least 2 gpios and hardware-observe and then start
# the service if so
if [ $num_gpio -ge 2 ] && [ $hardware_observe = true ]; then
    snapctl start --enable "$SNAP_NAME.svc1"
fi
