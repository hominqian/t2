# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: target/archivista/build.sh
# Copyright (C) 2004 - 2005 The T2 SDE Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---

pkgloop

isofsdir="$build_rock/isofs"		# for the ISO9660 content
imagelocation="$build_rock/rootfs"	# where the roofs is prepared and sq.

# create the live initrd's first and the actual root file-system, re-using
# the livecd code
. $base/target/$target/build_initrd.sh
[ $REBUILD ] && . $base/target/$target/build_image.sh

cat > $build_rock/isofs.txt <<- EOT
BOOT	-b boot/grub/stage2_eltorito -no-emul-boot
BOOTx	-boot-load-size 4 -boot-info-table
DISK1	build/${SDECFG_ID}/TOOLCHAIN/isofs /
EOT

echo_status "Done!"

