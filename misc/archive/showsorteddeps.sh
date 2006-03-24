#!/bin/sh
# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: misc/archive/showsorteddeps.sh
# Copyright (C) 2006 The T2 SDE Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---

cachefiles=
packages=
config=default

if [ "$1" == "-cfg" ]; then
	config="$2"
	shift; shift
fi

echo_warning() {
	echo "$@" | sed -e 's,^,!> ,g' >& 2
	}

echo_error() {
	echo "$@" | sed -e 's,^,!> ,g' >& 2
	exit 1
	}

if [ ! -f config/$config/packages ]; then
	echo_error "config '$config' doesn't exist, sorry"
fi

# get the list of cache files
#
for pkg; do
	confdir=`echo package/*/$pkg/`
	if [ -d $confdir ]; then
		packages="$packages $pkg"
		if [ -f ${confdir}$pkg.cache ]; then
			cachefiles="$cachefiles ${confdir}$pkg.cache"
		else
			echo_warning "package '$pkg' doesn't have a .cache file"
		fi
	else
		echo_warning "package '$pkg' doesn't exist"
	fi
done

{
# get the list of interesting packages
# just one level of recursion
#
packages=$( {
echo "$packages" | tr ' ' '\n'
for cache in $cachefiles; do
	grep '^\[DEP\]' $cache | cut -d' ' -f2
done } | sort -u | tr -s '\n' | tr '\n' ' ' )

# pattern to search at packages file of this config
#
pkgsexp=$( echo "$packages" | sed -e 's,^ ,,' -e 's, $,,' -e 's,\+,[+],' -e 's, ,\\\|,g' )

# catch interesting data from packages file
# (sorted by package name)
#
mkfifo $0.$$
( sed -n -e "s,^. \([^ ]*\) \(...\)\.\(...\) [^ ]* \($pkgsexp\) .*,\4 \2\3 \1,p" \
	config/$config/packages | sort > $0.$$ ) &

sleep 1
packages_orig="$packages"
while read pkg prio stages; do
	packages_new="${packages/ $pkg / }"
	if [ "$packages" != "$packages_new" ]; then
		packages="$packages_new"
		echo "$prio $stages $pkg"
	else
		echo_warning "what is '$pkg' doing here?"
	fi
done < $0.$$
rm $0.$$

# and catch data from dependencies which were not found at packages list
#
for pkg in $packages; do
	confdir=`echo package/*/$pkg/`
	if [ -f $confdir/$pkg.desc ]; then
		echo_warning "dependency '$pkg' is not available for this build."
		sed -n -e 's,^\[P\] . \([^ ]*\) \([^ \.]*\)\.\([^ \.]*\).*,\2\3 \1 '$pkg' *,p' $confdir/$pkg.desc
	else
		echo_warning "dependency '$pkg' doesn't exist!"
	fi
done
} | sort -n
