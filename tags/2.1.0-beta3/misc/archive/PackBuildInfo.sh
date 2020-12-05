#!/bin/sh

config=default
if [ "$1" == "-cfg" ]; then
	config=$2; shift; shift
fi

if [ ! -f config/$config/config ]; then
	echo "ERROR: $config not found!"
	exit 1
fi

eval `grep "ROCKCFG_ID=" config/$config/config`

if [ -z "$ROCKCFG_ID" -o ! -d build/$ROCKCFG_ID/var/adm/logs/ ]; then
	echo "ERROR: '$ROCKCFG' is not a valid build id!"
	exit 2
fi

tmpdir=`mktemp -d`
rev=`svn info | sed -n 's,^Revision: \(.*\),\1,p'`
mkdir -p $tmpdir/{config,cache,errlogs,flist}	# logs

echo "INFO: backuping configuration of $config ..." 1>&2
cp -av config/$config/* $tmpdir/config/

echo "INFO: creating build summary ..." 1>&2
./scripts/Create-ErrList -cfg $config 2>&1 | tee $tmpdir/summary

echo "INFO: adding cache files ..." 1>&2
#for x in $( cd build/$ROCKCFG_ID/var/adm/cache; ls -1 ); do
#	[ -s build/$ROCKCFG_ID/var/adm/cache/$x ] && \
#		cp build/$ROCKCFG_ID/var/adm/cache/$x $tmpdir/cache/
		cp build/$ROCKCFG_ID/var/adm/cache/* $tmpdir/cache/
#done

echo "INFO: adding log files ..." 1>&2
#for x in $( cd build/$ROCKCFG_ID/var/adm/logs; ls -1 ); do
#	if [ -s build/$ROCKCFG_ID/var/adm/logs/$x ]; then
#		[[ $x == *.out ]] && continue
#		cp build/$ROCKCFG_ID/var/adm/logs/$x $tmpdir/logs/
		cp build/$ROCKCFG_ID/var/adm/logs/*.err $tmpdir/errlogs/
#		[[ $x == *.err ]] && ln -s ../logs/$x $tmpdir/errlogs/$x
#	fi
#done

echo "INFO: adding flist files ..." 1>&2
#for x in $( cd build/$ROCKCFG_ID/var/adm/flists; ls -1 ); do
#	[ -s $x ] && cp build/$ROCKCFG_ID/var/adm/flists/$x $tmpdir/flist/
	cp build/$ROCKCFG_ID/var/adm/flists/* $tmpdir/flist/
#done

tar -C $tmpdir -jcf cachepack-$config-t2-r${rev:-0}.tar.bz2 .

rm -rf $tmpdir