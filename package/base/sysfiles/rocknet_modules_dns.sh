# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: package/.../sysfiles/rocknet_modules_dns.sh
# Copyright (C) 2004 - 2005 The T2 SDE Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---

dns_init() {
	if isfirst "dns"; then
		addcode up   4 1 "echo -n "" > /etc/resolv.conf"
	fi
}

public_nameserver() {
	addcode up 4 5 "echo nameserver $1 >> /etc/resolv.conf"
	dns_init
}

public_search() {
	if ! isfirst "dns_search"; then
		error "Keyword >>search<< not allowed multiple times."
		return
	fi

	addcode up 4 4 "echo search $* >> /etc/resolv.conf"
	dns_init
}

public_hostname() {
	addcode up 9 5 "hostname $1"
}

public_domainname() {
	# THIS IS A HACK
	addcode up 9 5 "sed 's/`hostname`\..* /`hostname`.$1 /' /etc/hosts > \
	                /etc/hosts.new ; mv /etc/hosts{.new,}"
}

