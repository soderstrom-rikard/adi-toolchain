#!/bin/sh
#
# This just slightly touches up the VDSP headers before we add them to the
# bfin-elf toolchain.
#

dos2unix() {
	echo "$@" | xargs sed -i 's/\r$//'
}

usage() {
	echo "Usage: ${0##*/} <dir of vdsp headers>" 1>&2
	exit 1
}

dir=$1
[ ! -d "$dir" ] && usage
[ ! -f "$dir/blackfin.h" ] && usage

echo "Stripping DOS newlines ..."
dos2unix "$dir"/*.h "$dir"/sys/*.h

echo "Stripping whitespace ..."
sed -i 's:[[:space:]]*$::' "$dir"/*.h "$dir"/sys/*.h

echo "Converting _LANGUAGE_C to __ASSEMBLY__ ..."
sed -i \
	-e 's:#ifdef _LANGUAGE_C:#ifdef __ASSEMBLY__:' \
	-e 's:\(/\*[[:space:]]*\)_LANGUAGE_C\([[:space:]]*\*/\):\1__ASSEMBLY__\2:' \
	"$dir"/*.h "$dir"/sys/*.h

echo "Tagging license ..."
grep -L -Z 'and license this software and its documentation for any purpose, provided' "$dir"/*.h "$dir"/sys/*.h | \
	xargs -0 sed -i -e '1i/*\
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

echo "Done"
