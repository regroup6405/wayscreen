#!/bin/bash

echo "---> onboot start"

cp /usr/etc/X11/xorg.conf.d/20-amdgpu.conf /etc/X11/xorg.conf.d/20-amdgpu.conf
if lspci | grep -q -i 'AMD.*Radeon'; then
  sed -i 's|^#||g' /etc/X11/xorg.conf.d/20-amdgpu.conf
fi

echo "---> onboot complete"

exit 0
