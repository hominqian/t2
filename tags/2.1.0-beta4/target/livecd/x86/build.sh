# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: target/livecd/x86/build.sh
# Copyright (C) 2004 - 2005 The T2 SDE Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---

syslinux_ver="`sed -n 's,.*syslinux-\(.*\).tar.*,\1,p' \
               $base/target/livecd/download.txt`"

cd $disksdir

echo_header "Creating isolinux setup:"
#
echo_status "Extracting isolinux boot loader."
mkdir -p isolinux
tar --use-compress-program=bzip2 \
    -xf $base/download/livecd/syslinux-$syslinux_ver.tar.bz2 \
    syslinux-$syslinux_ver/isolinux.bin -O > isolinux/isolinux.bin
#
echo_status "Creating isolinux config file."
cp $base/target/$target/x86/isolinux.cfg isolinux/
cp $base/target/$target/x86/help?.txt isolinux/
#
echo_status "Copy images to isolinux directory."
cp boot/memtest86.bin isolinux/memtest86
cp initrd.gz boot/vmlinuz isolinux/
#
cat > ../isofs_arch.txt <<- EOT
	BOOT	-b isolinux/isolinux.bin -c isolinux/boot.catalog
	BOOTx	-no-emul-boot -boot-load-size 4 -boot-info-table
	DISK1	build/${ROCKCFG_ID}/TOOLCHAIN/livecd/isolinux/ isolinux/
EOT
