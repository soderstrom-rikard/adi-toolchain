#!/bin/bash
# Generate the Blackfin arch headers based on Blackfin proc XML files

set -e

xsl_opts="--stringparam EXPORT-P-DEFS yes"

srcdir=$(dirname "${0}")
[[ ${srcdir} == .* ]] && srcdir="${PWD}/${srcdir}"
builddir="${srcdir}/output"
srcdir="${srcdir}/.."

rm -rf "${builddir}"
mkdir -p "${builddir}"/mach-common

cd "${builddir}"

output="blackfin.h"
def_output="blackfin_def.h"
cdef_output="blackfin_cdef.h"

common_header="\
/* DO NOT EDIT THIS FILE
 * Automatically generated by toolchain/trunk/proc-defs/sh/create-arch-headers.sh
 * DO NOT EDIT THIS FILE
 */

#ifndef __MACH_@LOCAL@_BLACKFIN__
#define __MACH_@LOCAL@_BLACKFIN__
"
common_footer="
#endif /* __MACH_@LOCAL@_BLACKFIN__ */"

echo "${common_header//@LOCAL@/DEF}" > ${def_output}
echo "${common_header//@LOCAL@/CDEF}" > ${cdef_output}

archdir() {
	local p
	case "$@" in
	*52*)              p=bf527;;
	*531*|*532*|*533*) p=bf533;;
	*534*|*536*|*537*) p=bf537;;
	*54*)              p=bf548;;
	*56*)              p=bf561;;
	*)                 p=common;;
	esac
	echo "mach-${p}"
}

headers=""
for bf in BF52{2,3,4,5,6,7} BF53{1,2,3,4,6,7} BF54{1,2,4,7,8,9} BF561 ; do
	xml="${srcdir}/xml/ADSP-${bf}-proc.xml"
	arch=$(archdir ${xml})

	mkdir -p "${arch}"

	header="${arch}/${bf}_def.h"
	headers="${headers} ${header}"
	echo "Generating ${header} from ${xml##*/}"
	xsltproc ${xsl_opts} "${srcdir}/xsl/generate-def-headers.xsl" "${xml}" > ${header}
	cat <<-EOF >> ${def_output}
	#ifdef __ADSP${bf}__
	# include "${header}"
	# include "${arch}/anomaly.h"
	# include "${arch}/def_local.h"
	#endif
	EOF

	header="${arch}/${bf}_cdef.h"
	headers="${headers} ${header}"
	echo "Generating ${header} from ${xml##*/}"
	xsltproc ${xsl_opts} "${srcdir}/xsl/generate-cdef-headers.xsl" "${xml}" > ${header}
	cat <<-EOF >> ${cdef_output}
	#ifdef __ADSP${bf}__
	# include "${header}"
	#endif
	EOF
done

# now figure out what common files need to be generated
for header in $(sed -n '/^#include/s:.* "\(.*\)":\1:p' ${headers} | sort -u) ; do
	case ${header} in
	*_def.h)  t="def";;
	*_cdef.h) t="cdef";;
	esac
	xml="${srcdir}/xml/${header/%_${t}.h/.xml}"
	arch=$(archdir ${header})
	mkdir -p "${arch}"
	out_header="${arch}/${header}"
	echo "Generating ${out_header} from ${xml##*/}"
	xsltproc ${xsl_opts} "${srcdir}/xsl/generate-${t}-headers.xsl" "${xml}" > ${out_header}
	[[ ${arch} == *common ]] \
		&& sed -i "/^#[[:space:]]*include .*${header}/s:\".*\":\"../${out_header}\":" ${headers}
done

echo "Generating blackfin def/cdef headers"
echo "${common_footer//@LOCAL@/DEF}" >> ${def_output}
echo "${common_footer//@LOCAL@/CDEF}" >> ${cdef_output}

cat << EOF > ${output}
${common_header//@LOCAL@/GLOB}
#include "blackfin_def.h"
#ifndef __ASSEMBLY__
#include "blackfin_cdef.h"
#endif
#include "blackfin_local.h"
${common_footer//@LOCAL@/GLOB}
EOF

echo "Generating register bits headers"
mkdir "${builddir}/mach-common/bits"
cp "${srcdir}/header-frags/regbits/"* "${builddir}/mach-common/bits/"

for b in "${srcdir}/header-frags/bf"* ; do
	b=${b##*/}
	cp "${srcdir}/header-frags/${b}"/* "${builddir}/mach-${b}/"
done
