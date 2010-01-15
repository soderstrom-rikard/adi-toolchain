#!/bin/bash
a=${0##/*}
d=${0%/*}
c=${d}/certs

err() { echo "${a}: $*" 1>&2; exit 1; }

if ! command -v signcode >/dev/null ; then
	err "you must install mono for the signcode utility"
fi

if [ ! -d "${c}" ] ; then
	err "you must install the ADI certs into ${c}"
fi

dd=$1
if [ -z "${dd}" ] ; then
	dd=$(find "${d}"/../.. -maxdepth 1 -type d -iname gnICE-drivers)
	[ -z "${dd}" ] && err "no drivers found"
fi
set -- \
	$(find "${dd}" -type f -name '*.cat') \
	$(find "${dd}" -type f -exec file {} + | grep ':.*PE' | cut -d: -f1)
[ -z "$1" ] && err "no driver files found"

echo "Trying to sign the files:"
printf '\t%s\n' "$@"

signcode \
	-spc "${c}/adi.spc" \
	-v "${c}/adi.pvk" \
	-t http://timestamp.verisign.com/scripts/timstamp.dll \
	"$@"

# signcode (sometimes?) creates .bak files
rm -f "${@/%/.bak}"
