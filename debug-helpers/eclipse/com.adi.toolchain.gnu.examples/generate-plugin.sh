#!/bin/sh

srcdir=$1

extensions=$(
find "${srcdir}" -name bfin.settings | \
(while read d ; do
	. "${d}"
	d=${d%/bfin.settings}

	rm -rf src/${id}
	cp -r "${d}" src/${id}
	find src/${id} -name .svn -print0 | xargs -0 rm -rf
	(cd src; ./generate-template-files.sh ${id})
	rm -f src/${id}/bfin.settings

	tcid=$(echo "${toolchain}" | sed 's:-:.:g')
cat <<EOF
	<extension point="org.eclipse.cdt.core.templates">
		<template
			filterPattern=".*"
			id="com.adi.toolchain.gnu.examples.${id}"
			location="src/${id}/template.xml"
			projectType="org.eclipse.cdt.build.core.buildArtefactType.exe">
		</template>
	</extension>
	<extension point="org.eclipse.cdt.core.templateAssociations">
		<template id="com.adi.toolchain.gnu.examples.${id}">
			<toolChain id="com.adi.toolchain.gnu.toolchain.${tcid}.base">
			</toolChain>
		</template>
	</extension>
EOF
done) | sed -e 's:\t:\\t:g' -e 's:$:\\n:g' -e 's:":\\":g'
)
extensions=$(echo ${extensions})

sed \
	-e "s:@EXTENSIONS@:${extensions}:" \
	plugin.xml.in > plugin.xml
