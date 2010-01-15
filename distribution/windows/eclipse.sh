#!/bin/bash

release="galileo"
ver="${release}"
fetch="wget -c -nv"

set -e

mkdir -p eclipse-files
cd eclipse-files

#
# Main eclipse package
#
echo "Fetching main eclipse release ${release}"
url="http://download.eclipse.org/technology/epp/downloads/release/${release}/R/eclipse-cpp-${ver}-win32.zip"
zip=${url##*/}
[[ -e ${zip} ]] || ${fetch} ${url}

#
# plugins we want by default
#
fetch_plugins() {
	local d=$1 url=$2 filter=$3

	local f feature features
	local p plugin plugins

	echo "Fetching ${d} plugins"

	mkdir -p ${d}
	pushd ${d} >/dev/null

	if [[ ! -e site.xml ]] ; then
		${fetch} ${url}/site.xml
	fi

	mkdir -p features plugins
	features=$(xml sel -t -m site/feature -v '@url' -o ' ' site.xml);
	for feature in ${features} ; do
		f=${feature##*/}
		[[ ${f} == *"${filter}"* ]] || continue
		[[ -e ${feature} ]] || ${fetch} ${url}/${feature} -P features

		d=${f%.jar}
		mkdir -p ${d}
		pushd ${d} >/dev/null
		unzip -uq ../${feature}
		popd >/dev/null

		plugins=$(xml sel -t -m feature/plugin -v '@id' -o '_' -v '@version' -o '.jar ' ${d}/feature.xml)
		for p in ${plugins} ; do
			plugin="plugins/${p}"
			[[ -e ${plugins} ]] || ${fetch} ${url}/${plugin} -P plugins
		done
	done

	popd >/dev/null
}

fetch_plugins \
	cdt \
	http://download.eclipse.org/tools/cdt/releases/${release} \
	gdbjtag
fetch_plugins \
	adi \
	http://blackfin.uclinux.org/eclipse

#
# Now bring it all together
#
echo "creating new eclipse package"
rm -rf eclipse ../eclipse
unzip -uq eclipse-cpp-*.zip
mv eclipse ../
cp */plugins/* ../eclipse/dropins/
