#!/bin/bash
# --- T2-COPYRIGHT-NOTE-BEGIN ---
# This copyright note is auto-generated by ./scripts/Create-CopyPatch.
# 
# T2 SDE: scripts/xfind.sh
# Copyright (C) 2004 - 2005 The T2 SDE Project
# 
# More information can be found in the files COPYING and README.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License. A copy of the
# GNU General Public License can be found in the file COPYING.
# --- T2-COPYRIGHT-NOTE-END ---

# Subversion has really big ".svn" subdirs. This has much better performance
# than the "find ... ! -path '*/.svn*' ! -path '*/CVS*' ..." used earlier
# in various places. Never use this with -depth! Instead pipe the output thru
# "tac" or "sort -r".

dirs=""; while [ -n "${1##[-\(\!]*}" ]; do dirs="$dirs $1"; shift; done
if [ $# -eq 0 ]; then set -- -print; fi; 
action=") -print"; if [ "${*#-print}" != "$*" ]; then action=""; fi
find $dirs '(' -path '*/.svn' -o -path '*/CVS' ')' -prune -o ${action:+\(} "$@" $action

