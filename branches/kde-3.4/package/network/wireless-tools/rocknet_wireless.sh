iwdetect_mangle_cells() {
	local essid=none mode= encryption= quality=
	local line=

	mkdir -p $rocknet_tmp_base/$if/

	iwlist $if scan | while read line; do
		if [[ $line = *ESSID* ]]; then
			[ -n "$essid" ] && echo -e "$essid\t$mode\t$encryption\t$quality"
			essid="$( echo "$line" | sed -e 's,.*"\(.*\)",\1,g' )"
			mode=
			encryption=
			quality=
		elif [[ $line = Mode:* ]]; then
			mode=${line#*:}
		elif [[ $line = Encryption* ]]; then
			encryption=${line#*:}
		elif [[ $line = *Quality* ]]; then
			quality=$( echo "$line" | sed -e 's,:\([^ ]*\),:\1\n,g' | sed -e 's,^.*:,,g' | head -n 2 | tr '\n' '\t' )
		elif [ -z "$line" ]; then
			[ "$essid" != "none" ] && echo -e "$essid\t$mode\t$encryption\t$quality"
		fi
	done > $rocknet_tmp_base/$if/detected_cells
}
iwdetect_select_cell() {
	local networkfile=${1:-/etc/network/nettab}
	local essid= key= extra=
	local line=

	if [ -f $networkfile ]; then
	while read -r essid key extra; do
		line="$( grep -e "^$essid" $rocknet_tmp_base/$if/detected_cells )"
		if [ -n "$line" ]; then
			echo "'$essid' selected..."
			echo "$line" | ( read -r -d '\t' essid mode encryption quality signal;
				iwconfig $if essid "$essid"
				case "$mode" in
					Master)	iwconfig $if mode Managed	;;
					Ad-Hoc) iwconfig $if mode "Ad-Hoc"	;;
					*)	echo "WARNING: Unknown mode '$mode'." ;;
				esac
				)
			break
		fi
	done < $networkfile
	else
		echo "INFO: to use iwdetect you need to set a $networkfile."
	fi
}

public_iwdetect() {
	addcode up 4 2 "ip link set $if up"
	addcode up 4 3 "iwdetect_mangle_cells" 
	addcode up 4 4 "iwdetect_select_cell $1"
	addcode down 4 5 "iwconfig $if essid any"
}

public_essid() {
	addcode up 4 5 "iwconfig $if essid $*"
	addcode down 4 5 "iwconfig $if essid any"
}

public_nwid() {
	addcode up 4 5 "iwconfig $if nwid $*"
	addcode down 4 5 "iwconfig $if nwid off"
}

public_domain() {
	addcode up 4 5 "iwconfig $if domain $*"
	addcode down 4 5 "iwconfig $if domain off"
}

public_freq() {
	addcode up 4 5 "iwconfig $if freq $*"
}

public_channel() {
	addcode up 4 5 "iwconfig $if channel $*"
}

public_sens() {
	addcode up 4 5 "iwconfig $if sens $*"
}

public_mode() {
	addcode up 4 4 "iwconfig $if mode $*"
	addcode down 4 4 "iwconfig $if mode Auto"
}

public_ap() {
	addcode up 4 5 "iwconfig $if ap $*"
	addcode down 4 5 "iwconfig $if ap any"
}

public_nick() {
	addcode up 4 5 "iwconfig $if nick $*"
}

public_rate() {
	addcode up 4 5 "iwconfig $if rate $*"
	addcode down 4 5 "iwconfig $if rate auto"
}

public_rts() {
	addcode up 4 5 "iwconfig $if rts $*"
}

public_frag() {
	addcode up 4 5 "iwconfig $if frag $*"
}

public_key() {
	addcode up 4 5 "iwconfig $if key $*"
	addcode down 4 5 "iwconfig $if key off"
}

public_enc() {
        addcode up 4 5 "iwconfig $if enc $*"
	addcode down 4 5 "iwconfig $if enc off"
}

public_power() {
	addcode up 4 5 "iwconfig $if power $*"
}

public_txpower() {
	addcode up 4 5 "iwconfig $if txpower $*"
	addcode down 4 5 "iwconfig $if txpower auto"
}

public_retry() {
	addcode up 4 5 "iwconfig $if retry $*"
}

public_commit() {
        addcode up 4 9 "iwconfig $if commit"
}

