#!/bin/sh

srcdir=$1

find "${srcdir}" -name bfin.settings | \
while read d ; do
	. "${d}"
	d=${d%/bfin.settings}

	files=$(
		find "${d}" \
			'(' -name .svn -prune ')' -o \
			'(' \
				'!' '(' \
					-name bfin.settings -o \
					-name template.properties -o \
					-name template.xml -o \
					-name Makefile \
				')' \
				-type f -printf '%P\n' \
			')' | \
		while read file ; do
			printf '%s' '\t\t\t<element>\n'
			printf '%s' '\t\t\t\t<simple name="source" value="'${file}'"/>\n'
			printf '%s' '\t\t\t\t<simple name="target" value="src/'${file}'"/>\n'
			printf '%s' '\t\t\t\t<simple name="replaceable" value="true"/>\n'
			printf '%s' '\t\t\t</element>\n'
		done
	)

	cat <<-EOF > "${d}"/template.properties
	${id}.label=${label}
	${id}.description=${desc}
	EOF
	sed \
		-e "s:@ID@:${id}:g" \
		-e "s:@CPU@:${cpu}:g" \
		-e "s:@FILES@:${files}:" \
		template.xml.in > "${d}"/template.xml
done
