# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: package/.../stone/stone_mod_network.sh
# Copyright (C) 2004 - 2005 The T2 SDE Project
# Copyright (C) 1998 - 2003 ROCK Linux Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---
#
# [MAIN] 20 network Network Configuration

### DYNAMIC NEW-STYLE CONFIG ###

export rocknet_base="/lib/network" # export needed for subshells ...
export rocknet_config="/etc/conf/network"

edit() {
	gui_edit "Edit file $1" "$1"
	exec $STONE network
}

read_section() {
	local globals=1
	local readit=0
	local i=0

	unset tags
	unset interfaces


	[ "$1" = "" ] && readit=1
	while read netcmd para
	do
		if [ -n "$netcmd" ]; then
			netcmd="${netcmd//-/_}"
			para="$( echo "$para" | sed 's,[\*\?],\\&,g' )"
			if [ "$netcmd" = "interface" ] ; then
				prof="$( echo "$para" | sed 's,[(),],_,g' )"
				[ "$prof" = "$1" ] && readit=1 || readit=0
				globals=0
				interfaces="$interfaces $prof"
			fi
			if [ $readit = 1 ] ; then
				tags[$i]="$netcmd $para"
				i=$((i+1))
			fi
		fi
	done < <( sed 's,\(^\|[ \t]\)#.*$,,' < $rocknet_config )
}

write_tags() {
	for (( i=0 ; $i < ${#tags[@]} ; i=i+1 )) ; do
		local netcmd="${tags[$i]}"
		[ "$netcmd" ] || continue
		[ $1 = 0 ] && [[ "$netcmd" != interface* ]] && \
			echo -en "\t"
		echo "${tags[$i]}"
	done
}

write_section() {
	local globals=1
	local passit=1
	local dumped=0

	[ "$1" = "" ] && passit=0

	echo -n > $rocknet_config.new

	while read netcmd para ; do

		[ "$netcmd" ] || continue
		netcmd="${netcmd//-/_}"
		para="$( echo "$para" | sed 's,[\*\?],\\&,g' )"

		# when we reached the matching section dump the
		# mew tags ...
		if [ $passit = 0 -a $dumped = 0 ] ; then
			write_tags $globals >> $rocknet_config.new
			dumped=1
		fi

		# if we reached a new interface section maybe change
		# the state
		if [ "$netcmd" = "interface" ] ; then
			prof="$( echo "$para" | sed 's,[(),],_,g' )"
			[ "$prof" = "$1" ] && passit=0 || passit=1

			# write out a separating newline
			echo "" >> $rocknet_config.new

			globals=0
		fi

		# just pass the line thru?
		if [ $passit = 1 ] ; then
			[ $globals = 0 -a "$netcmd" != "interface" ] && \
			  echo -en "\t" >> $rocknet_config.new
			echo "$netcmd $para" >> $rocknet_config.new
		fi
	done < <( cat $rocknet_config )

	# if the config file was empty, for an not yet present or last
	# we had no change to match the existing position - so write them
	# out now ...
	[ $globals = 0 ] && echo "" >> $rocknet_config.new
	[ "$1" ] && globals=0
	[ $dumped = 0 ] && write_tags $globals >> $rocknet_config.new

	mv $rocknet_config{.new,}
}

edit_tag() {
	tag="${tags[$1]}"
	name="$tag"
	gui_input "Set new value for tag '$name'" \
	          "$tag" "tag"

	tags[$1]="$tag"
}

edit_global_tag() {
	edit_tag $@
	write_section ""
}

add_tag() {
	tta="$@"
	if [ "$tta" = "" ] ; then
		cmd="gui_menu add_tag 'Add tag of from module'"

		while read module ; do
			cmd="$cmd "$module" module='$module'"
		done < <( cd $rocknet_base/ ; grep public_ * | sed -e \
			  's/\.sh//' -e 's/:.*//' | sort -u )
		module=""
		eval $cmd

		cmd="gui_menu add_tag 'Add tag of type'"
		while read tag ; do
			cmd="$cmd "$tag" 'tta=$tag'"
		done < <( cd $rocknet_base/ ; grep -h public_ $module.sh \
			  | sed -e 's/public_\([^(]*\).*/\1/' | sort )
		eval "$cmd"
	fi

	if [ "$tta" ] ; then
		tagno=${#tags[@]}
		tags[$tagno]="$tta"
		edit_tag $tagno
	fi
}

add_global_tag() {
	add_tag $@
	write_section ""
}

edit_if() {
	read_section "$1"

	quit=0
	while 
		cmd="gui_menu if_edit 'Configure interface ${1//_/ }'"
		for (( i=0 ; $i < ${#tags[@]} ; i=i+1 )) ; do
			[ "${tags[$i]}" ] || continue
			cmd="$cmd '${tags[$i]}' 'edit_tag $i'"
		done

		cmd="$cmd '' '' 'Add new tag' 'add_tag'"
		cmd="$cmd 'Delete this interface/profile' 'del_interface $1 && quit=1'"

		# tiny hack since gui_menu return 0 or 1 depending on the exec
		# status of e.g. dialog - and thus a del_interface && false
		# cannot be used ...

		eval "$cmd" || quit=1
		[ $quit = 0 ]
	do : ; done
	write_section "$1"
}

add_interface() {
	if="$1"

	gui_input "The new interface name (and profile)" \
	          "$if" "if"
	unset tags
	tags[0]="interface $if"

	if gui_yesno "Use DHCP to obtain the configuration?" ; then
		add_tag "dhcp"
	else
		add_tag "ip 192.168.5.1/24"
		add_tag "gw 192.168.5.1"
		add_tag "nameserver 192.168.5.1"
	fi

	write_section "$if"
} 

del_interface() {
	unset tags
	write_section "$1"
}

### STATIC OLD-STYLE CONFIG ###

set_name() {
	old1="$HOSTNAME" old2="$HOSTNAME.$DOMAINNAME" old3="$DOMAINNAME"
	if [ $1 = HOSTNAME ] ; then
		gui_input "Set a new hostname (without domain part)" \
		          "${!1}" "$1"
	else
		gui_input "Set a new domainname (without host part)" \
		          "${!1}" "$1"
	fi
	new="$HOSTNAME.$DOMAINNAME $HOSTNAME"

	echo "$HOSTNAME" > /etc/HOSTNAME ; hostname "$HOSTNAME"

	#ip="`echo $IPADDR | sed 's,[/ ].*,,'`"
	#if grep -q "^$ip\\b" /etc/hosts ; then
	#	tmp="`mktemp`"
	#	sed -e "/^$ip\\b/ s,\\b$old2\\b[ 	]*,,g" \
	#	    -e "/^$ip\\b/ s,\\b$old1\\b[ 	]*,,g" \
	#	    -e "/^$ip\\b/ s,[ 	]\\+,&$new ," < /etc/hosts > $tmp
	#	cat $tmp > /etc/hosts ; rm -f $tmp
	#else
	#	echo -e "$ip\\t$new" >> /etc/hosts
	#fi

	if [ $1 = DOMAINNAME ] ; then
		tmp="`mktemp`"
		grep -vx "search $old3" /etc/resolv.conf > $tmp
		[ -n "$DOMAINNAME" ] && echo "search $DOMAINNAME" >> $tmp
		cat $tmp > /etc/resolv.conf
		rm -f $tmp
	fi
}

set_dns() {
	gui_input "Set a new (space seperated) list of DNS Servers" "$DNSSRV" "DNSSRV"
	DNSSRV="`echo $DNSSRV`" ; [ -z "$DNSSRV" ] && DNSSRV="none"

	tmp="`mktemp`" ; grep -v '^nameserver\b' /etc/resolv.conf > $tmp
	for x in $DNSSRV ; do
		[ "$x" != "none" ] && echo "nameserver $x" >> $tmp
	done
	cat $tmp > /etc/resolv.conf
	rm -f $tmp
}

HOSTNAME="`hostname`"
DOMAINNAME="`hostname -d 2> /dev/null`"

tmp="`mktemp`"
grep '^nameserver ' /etc/resolv.conf | tr '\t' ' ' | tr -s ' ' | \
    sed 's,^nameserver *\([^ ]*\),DNSSRV="$DNSSRV \1",' > $tmp
DNSSRV='' ; . $tmp ; DNSSRV="`echo $DNSSRV`"
[ -z "$DNSSRV" ] && DNSSRV="none" ; rm -f $tmp

main() {
    first_run=1
    while

	# read global section and interface list ...
	read_section ""

	p_interfaces=$(ip link | egrep '[^:]*: .*' | \
	               sed 's/[^:]*: \([a-z0-9]*\): .*/\1/' | \
	               grep -v -e lo -e sit)

	if [ $first_run = 1 ] ; then
		first_run=0
		# check if a section for the interface is already present
		for x in $p_interfaces ; do
			if [[ $interfaces != *$x* ]] ; then
			  if gui_yesno "Unconfigured interface $x detected. \
Do you want to create an interface section?" ; then
				add_interface "$x"
			  fi
			fi
		done
		read_section ""
	fi

	cmd="gui_menu network 'Network Configuration - Select an item to
change the value

WARNING: This script tries to adapt /etc/conf/network and /etc/hosts
according to your changes. Changes only take affect the next time
rocknet is executed.'"

	cmd="$cmd 'Static hostname:   $HOSTNAME'   'set_name HOSTNAME'"
	cmd="$cmd 'Static domainname: $DOMAINNAME' 'set_name DOMAINNAME'"
	cmd="$cmd 'Static DNS-Server: $DNSSRV'     'set_dns' '' ''"

	for (( i=0 ; $i < ${#tags[@]} ; i=i+1 )) ; do
		cmd="$cmd '${tags[$i]}' 'edit_global_tag $i'"
	done
	cmd="$cmd 'Add new global tag' 'add_global_tag' '' ''"

	for if in $interfaces ; do
		cmd="$cmd 'Edit interface ${if//_/ }' 'edit_if $if'"
	done

	cmd="$cmd 'Add new interface/profile' 'add_interface' '' ''"

	cmd="$cmd 'Configure runlevels for network service'"
	cmd="$cmd '$STONE runlevel edit_srv network'"
	cmd="$cmd '(Re-)Start network init script'"
	cmd="$cmd '$STONE runlevel restart network'"
	cmd="$cmd '' ''"

	cmd="$cmd 'View/Edit /etc/resolv.conf file'     'edit /etc/resolv.conf'"
	cmd="$cmd 'View/Edit /etc/hosts file'           'edit /etc/hosts'"
	cmd="$cmd 'View/Edit $rocknet_config file' 'edit $rocknet_config'"

	eval "$cmd"
    do : ; done
}
