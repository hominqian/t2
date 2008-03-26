# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: target/embedded/build.sh
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

imagelocation="$build_toolchain/rootfs"
echo "COPY PATH"
echo "$base/target/$target/rootfs/etc/* $root/etc"
echo "$base/target/$target/rootfs/etc/init.d/* $root/etc/init.d"

#cp $base/target/$target/rootfs/etc/* $root/etc
#cp -R $base/target/$target/rootfs/etc/init.d/* $root/etc/init.d

. $base/target/$target/build_image.sh

#. $base/target/$target/makedev.sh


echo_status "Done!"

