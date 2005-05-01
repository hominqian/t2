dnl --- T2-COPYRIGHT-NOTE-BEGIN ---
dnl This copyright note is auto-generated by ./scripts/Create-CopyPatch.
dnl 
dnl T2 SDE: architecture/share/kernel-common.conf.m4
dnl Copyright (C) 2004 - 2005 The T2 SDE Project
dnl 
dnl More information can be found in the files COPYING and README.
dnl 
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; version 2 of the License. A copy of the
dnl GNU General Public License can be found in the file COPYING.
dnl --- T2-COPYRIGHT-NOTE-END ---

dnl Enable experimental features (like DevFS ;-)
dnl
CONFIG_EXPERIMENTAL=y

dnl On default we build SMP kernels and mods
dnl
CONFIG_SMP=y

dnl integrated .config is quite big - and we ship them in /boot/kconfig_ anyway
dnl
# CONFIG_IKCONFIG is not set

dnl PCI name database is also quite big (another >80kB) - so let's use user-
dnl space tools like lspci to use a non-kernel database
dnl
# CONFIG_PCI_NAMES ist not set

dnl Enable modules
dnl
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
# CONFIG_MODULE_FORCE_UNLOAD is not set
# CONFIG_MODVERSIONS is not set
CONFIG_KMOD=y

dnl Firmware loader can always be useful
dnl
CONFIG_FW_LOADER=y

dnl Loopback device can always be useful
dnl
CONFIG_BLK_DEV_LOOP=y

dnl We need initrd for install system and other stuff
dnl
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_INITRD=y

dnl Enable PCMCIA (PC-Card) as modules
dnl
CONFIG_PCMCIA=m
CONFIG_CARDBUS=y
CONFIG_TCIC=y
CONFIG_TCIC=y
CONFIG_I82092=y
CONFIG_I82365=y

dnl Misc stuff
CONFIG_BINFMT_AOUT=m
CONFIG_BINFMT_MISC=m

dnl Math emulation in the default kernel
dnl (we could also run this on an old 386)
dnl
CONFIG_MATH_EMULATION=y

dnl Sound system
dnl (module support is enought - default is y ...)
dnl
CONFIG_SOUND=m

dnl for 2.5/6 we do want the ALSA OSS emulation ...
dnl
CONFIG_SND_OSSEMUL=m

dnl Input devices
dnl
CONFIG_INPUT=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_KEYBDEV=y
CONFIG_INPUT_MOUSEDEV=y
CONFIG_INPUT_JOYSTICK=m
CONFIG_INPUT_TOUCHSCREEN=m
CONFIG_INPUT_MISC=y
CONFIG_INPUT_EVBUG=m

dnl USB drivers
dnl
CONFIG_USB=y
CONFIG_USB_DEVICEFS=y
CONFIG_USB_EHCI_HCD=y
CONFIG_USB_UHCI=y
CONFIG_USB_UHCI_ALT=n
CONFIG_USB_OHCI=y
CONFIG_USB_HID=y
CONFIG_USB_HIDINPUT=y
CONFIG_USB_HIDDEV=y

dnl USB - some others should be modular ...
dnl
CONFIG_USB_PRINTER=m
CONFIG_USB_STORAGE=m

dnl IEEE1394 - Firewire / iLink drivers
dnl
CONFIG_IEEE1394=m
CONFIG_IEEE1394_SBP2=m

dnl Crypto API
dnl
CONFIG_CRYPTO=y

dnl Console (FB) Options
dnl
CONFIG_VGA_CONSOLE=y
CONFIG_VIDEO_SELECT=y
CONFIG_FB=y
CONFIG_FB_VESA=y

dnl Console (Serial) Options
dnl
CONFIG_SERIAL=y
CONFIG_SERIAL_CONSOLE=y

dnl Video for Linux
dnl
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_PROC_FS=y

dnl DVB - Digital Video Broadcasting support
CONFIG_DVB=y

dnl The AGP support can be modular
dnl
CONFIG_AGP=y

dnl DRM drivers for hardware 3D
dnl
CONFIG_DRM=m

dnl The 2.6 kernel has several debugging options enabled
dnl
# CONFIG_FRAME_POINTER is not set

dnl Enable kernel profiling support (oprofile)
dnl
CONFIG_PROFILING=y
CONFIG_OPROFILE=m

