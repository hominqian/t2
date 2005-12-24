# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: package/.../dhcp/rocknet_dhcp.sh
# Copyright (C) 2004 - 2005 The T2 SDE Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---

public_dhcp() {
	addcode up   5 5 "/sbin/dhclient -q $if"
	addcode down 5 5 "killall -TERM dhclient"
	addcode down 5 6 "sleep 2 ; ip link set $if down || ifconfig $if down"
}

