# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: target/generic/build.sh
# Copyright (C) 2004 - 2005 The T2 SDE Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---

# This is the shortest possible target build.sh script. Some targets will
# add code after calling pkgloop() or modify pkgloop's behavior by defining
# a new pkgloop_action() function.
#
pkgloop

echo_header "Finishing build."

echo_status "Creating package database ..."
admdir="build/${SDECFG_ID}/var/adm"
create_package_db $admdir build/${SDECFG_ID}/TOOLCHAIN/pkgs \
                  build/${SDECFG_ID}/TOOLCHAIN/pkgs/packages.db

echo_status "Creating isofs.txt file .."
cat << EOT > build/${SDECFG_ID}/TOOLCHAIN/isofs.txt
DISK1	$admdir/cache/					${SDECFG_SHORTID}/info/cache/
DISK1	$admdir/cksums/					${SDECFG_SHORTID}/info/cksums/
DISK1	$admdir/dependencies/				${SDECFG_SHORTID}/info/dependencies/
DISK1	$admdir/descs/					${SDECFG_SHORTID}/info/descs/
DISK1	$admdir/flists/					${SDECFG_SHORTID}/info/flists/
DISK1	$admdir/md5sums/				${SDECFG_SHORTID}/info/md5sums/
DISK1	$admdir/packages/				${SDECFG_SHORTID}/info/packages/
EVERY	build/${SDECFG_ID}/TOOLCHAIN/pkgs/packages.db	${SDECFG_SHORTID}/pkgs/packages.db
SPLIT	build/${SDECFG_ID}/TOOLCHAIN/pkgs/			${SDECFG_SHORTID}/pkgs/
EOT
