dnl --- T2-COPYRIGHT-NOTE-BEGIN ---
dnl T2 SDE: architecture/riscv/linux.conf.m4
dnl Copyright (C) 2004 - 2021 The T2 SDE Project
dnl 
dnl This Copyright note is generated by scripts/Create-CopyPatch,
dnl more information can be found in the files COPYING and README.
dnl 
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License version 2.
dnl --- T2-COPYRIGHT-NOTE-END ---

define(`RISCV', 'RISCV')dnl

dnl RiscV
dnl
dnl
dnl
dnlCONFIG_SOC_SIFIVE=y
dnlCONFIG_SOC_VIRT=y

CONFIG_HZ_100=y
CONFIG_PCI=y
CONFIG_NET=y
CONFIG_UNIX=y
CONFIG_INET=y
CONFIG_VIRTIO_BLK=y
CONFIG_NETDEVICES=y
CONFIG_VIRTIO_NET=y
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_SERIAL_OF_PLATFORM=y
CONFIG_VIRT_DRIVERS=y
CONFIG_VIRTIO_MMIO=y
CONFIG_EXT4_FS=y

include(`linux-common.conf.m4')
include(`linux-block.conf.m4')
include(`linux-net.conf.m4')
include(`linux-fs.conf.m4')

CONFIG_NET_VENDOR_SPINAL=y
# CONFIG_GPIO_SPINAL_LIB is not set
