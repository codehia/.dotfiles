#!/bin/bash
touch /etc/udev/rules.d/50-powersave-net-bak.rules
touch /etc/udev/rules.d/50-wake-on-device.rules
touch /etc/udev/rules.d/81-wifi-powersave.rules

cat<<EOF>>/etc/udev/rules.d/50-powersave-net-bak.rules
# Disable ethernet ports
ACTION=="add", SUBSYSTEM=="net", KERNEL=="enp*", RUN+="/usr/bin/ip link set dev %k down"

# Disable Wake-on-LAN
ACTION=="add", SUBSYSTEM=="net", KERNEL=="enp*", RUN+="/usr/bin/ethtool -s %k wol d"
EOF

cat<<EOF>>/etc/udev/rules.d/50-wake-on-device.rules
ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="04f2", ATTRS{idProduct}=="b6d0", ATTR{power/wakeup}="enabled", ATTR{driver/1-2/power/wakeup}="enabled"
EOF

cat<<EOF>>/etc/udev/rules.d/81-wifi-powersave.rules
ACTION=="add", SUBSYSTEM=="net", KERNEL=="wl*", RUN+="/usr/bin/iw dev $name set power_save on"
EOF
