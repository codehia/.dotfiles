#!/bin/bash
touch /etc/X11/xorg.conf.d/20-amdgpu.conf
touch /etc/X11/xorg.conf.d/30-touchpad.conf

cat <<EOF >>/etc/X11/xorg.conf.d/20-amdgpu.conf
Section "Device"
     Identifier "AMD"
     Driver "amdgpu"
     Option "TearFree" "true"
EndSection
EOF

cat <<EOF >>/etc/X11/xorg.conf.d/30-touchpad.conf
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "TappingButtonMap" "lrm"
EndSection
EOF
