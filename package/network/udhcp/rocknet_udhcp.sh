# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: package/.../udhcp/rocknet_udhcp.sh
# Copyright (C) 2004 - 2005 The T2 SDE Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---

public_udhcp() {
	local opt_nodns=
	local HOSTNAME="`hostname`" cmdline=
	[ "$HOSTNAME" == "(none)" ] && HOSTNAME=
	
	[ "$CANUSESERVICE" == "1" ] && cmdline="exec "

	cmdline="$cmdline /usr/sbin/udhcpc ${HOSTNAME:+-h $HOSTNAME} -i $if"
	cmdline="$cmdline -s /etc/udhcp/t2-default.script"

	while [ $# -ge 1 ]; do
		case "$1" in
			nodns)	opt_nodns=1	;;
			*)	echo "WARNING: udhcp doesn't understand '$1'"
				;;
		esac
		shift
	done
	
	if [ "$opt_nodns" ]; then
		cmdline="export UPDATE_RESOLVCONF=0;
$cmdline"
	fi

	if [ "$CANUSESERVICE" == "1" ]; then
		addcode up 5 1 "service_create $if '$cmdline -f' \
			'sleep 2 ; ip link set $if down'"
		addcode down 5 1 "service_destroy $if"
	else
		addcode up   5 5 "$cmdline"
		addcode down 5 5 "killall -TERM udhcpc"
		addcode down 5 5 "sleep 2 ; ip link set $if down"
	fi
}
