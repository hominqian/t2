#!/bin/bash
# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: package/.../iproute2/dumpnetcfg.sh
# Copyright (C) 2004 - 2005 The T2 SDE Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---

echo
echo "# IP-Tables configuration"
while read line; do
	[ -z "${line##\**}" ] && table="${line#\*}"
	[ -z "${line##-A*}" ] && echo iptables -t $table $line
done < <( iptables-save )

echo
echo "# Link Configuration"
ip link | awk -- '
BEGIN {
	f["ARP"]       = "on";
	f["MULTICAST"] = "on";
	f["ALLMULTI"]  = "off";
	f["PROMISC"]   = "off";
	f["DYNAMIC"]   = "off";

	a["00:00:00:00:00:00"] = 1;
	a["ff:ff:ff:ff:ff:ff"] = 1;
}

/^[0-9]/ {
	if ( command ) print command updown;

	interface = $2;
	sub(":", "", interface);

	command = "ip link set " interface;

	updown = " down";
	if ( match($3, "[^A-Z]UP[^A-Z]") ) updown = " up";

	for ( field in f ) {
		val = f[field];
		if ( match($3, "[^A-Z]"   field "[^A-Z]") ) val = "on";
		if ( match($3, "[^A-Z]NO" field "[^A-Z]") ) val = "off";
		if ( val != f[field] && val != "auto" ) {
			command = command " " tolower(field) " " val;
		}
	}

	if ( $4 == "mtu" ) {
		command = command " mtu " $5;
	}
}

/^ *link\// {
	if ( ! a[$2] ) command = command " address " $2;
	if ( ! a[$4] ) command = command " broadcast " $4;
}

END {
	if ( command ) print command updown;
}
'

echo
echo "# IPv4 Address Configuration"
ip addr | grep '^ *inet ' | sed 's, *inet,ip addr add,; s,\(.*\) ,\1 dev ,'

echo
echo "# IPv4 Route Configuration"
ip route | grep -v ' scope link ' | sed 's,^,ip route add ,'

echo

