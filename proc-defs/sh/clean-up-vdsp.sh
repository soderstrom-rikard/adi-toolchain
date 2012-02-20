#!/bin/sh
#
# This just slightly touches up the VDSP headers before we add them to the
# bfin-elf toolchain.
#

dos2unix() {
	echo "$@" | xargs sed -i 's/\r$//'
}

usage() {
	echo "Usage: ${0##*/} <dir of vdsp headers> [dir of latest vdsp headers]" 1>&2
	exit 1
}

dir=$1
[ ! -d "$dir" ] && usage
[ ! -f "$dir/blackfin.h" ] && usage

vdir=$2
if [ -n "$vdir" ] ; then
	[ ! -d "$vdir" ] && usage
	[ ! -f "$vdir/blackfin.h" ] && usage

	echo "Updating headers ..."
	cp "$vdir"/cdef* "$vdir"/def* "$dir"/
	find "$dir" \
		'(' -name '*.h' -a '!' -name 'ccblkfn.h' ')' \
		-printf '%P\n' | \
	while read header ; do
		cp "$vdir"/$header "$dir"/$header
	done
fi

echo "Fixing permissions ..."
find "$dir" -name '*.h' -exec chmod 00644 {} +

echo "Stripping DOS newlines ..."
dos2unix $(find "$dir" -name '*.h')

echo "Stripping whitespace ..."
find "$dir" -name '*.h' -exec sed -i 's:[[:space:]]*$::' {} +

echo "Converting _LANGUAGE_C to __ASSEMBLER__ ..."
find "$dir" -name '*.h' -exec \
sed -i \
	-e 's:#ifdef _LANGUAGE_C:#ifndef __ASSEMBLER__:' \
	-e 's:#if defined(_LANGUAGE_C):#ifndef __ASSEMBLER__:' \
	-e 's:\(/\*[[:space:]]*\)_LANGUAGE_C\([[:space:]]*\*/\):\1__ASSEMBLER__\2:' \
	{} +

echo "Tagging license ..."
grep -L -Z 'and license this software and its documentation for any purpose, provided' "$dir"/*.h "$dir"/sys/*.h | \
	xargs -0 -r sed -i -e '1i/*\
 * The authors hereby grant permission to use, copy, modify, distribute,\
 * and license this software and its documentation for any purpose, provided\
 * that existing copyright notices are retained in all copies and that this\
 * notice is included verbatim in any distributions. No written agreement,\
 * license, or royalty fee is required for any of the authorized uses.\
 * Modifications to this software may be copyrighted by their authors\
 * and need not follow the licensing terms described here, provided that\
 * the new terms are clearly indicated on the first page of each file where\
 * they apply.\
 */\
'

notice=false
echo "Checking header includes ..."
for inc in $(find "$dir" -name '*.h' \
	-exec sed -n '/#[[:space:]]*include[[:space:]]*</{s:.*<\(.*\)>$:\1:p}' {} + | \
	sort -u)
do
	if [ ! -e "$dir"/$inc ] ; then
		if ! ${notice} ; then
			notice=true
			echo " note that missing cdef/def headers may be 'normal' as VDSP"
			echo " does not include all the ones referenced by sys/_adi_platform.h"
		fi
		echo " !!! missing $inc"
	fi
done

if type -P bfin-elf-gcc >/dev/null ; then
	echo "Checking things compile ..."
	for cpu in $(grep -o "__ADSPBF...__" "$dir"/sys/_adi_platform.h | sort -u | sed 's:__ADSPBF\(...\)__:bf\1:') ; do
		if ! bfin-elf-gcc -mcpu=${cpu} -E - </dev/null >/dev/null 2>&1 ; then
			echo " gcc does not support $cpu, skipping"
			continue
		fi

		printf " testing"
		for si in "" -any -none ; do
			printf " $cpu$si"
			for inc in $(find "$dir" -name '*.h' -printf '%P ') ; do
				case $inc in
					# sys/_adi_platform.h should test these for us indirectly
					def*|cdef*) continue;;
				esac

				echo "#include <$inc>" | \
				bfin-elf-gcc \
					-mcpu=${cpu}${si} \
					-nostdinc -isystem "$dir" \
					-x c -c -o /dev/null -
			done
		done
		printf "\n"
	done
else
	echo "Skipping compile check (bfin-elf-gcc not in PATH)"
fi

echo "Done"
