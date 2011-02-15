#!/bin/bash
set -ex

#
# First sync the repo files from svn
#

u="svn://localhost/svn/toolchain/trunk/distribution/deb/skel-repo"
d="/var/lib/gforge/filesystem/distros/debian"

t=`mktemp -d -p /var/tmp/`
rm -rf "${t}"

svn export -q --force ${u} "${t}/"
rsync -a --inplace --exclude=.project "${t}/" "${d}/"

rm -rf "${t}"

#
# Then see if any files need rebuilding
#

pushd "${t}/dists" >/dev/null

for d in */ ; do
	d=${d%/}
	pushd $d >/dev/null

	for m in $(find . -name Makefile) ; do
		make -C "${m%/*}"
	done

	(
	cat <<-EOF
	Suite: $d
	Architectures: $(echo $(awk '$1 == "Architecture:" { print $NF }' `find . -name Release`))
	Components: main
	EOF
	apt-ftparchive release $PWD
	) > Release
	rm -f Release.gpg
	gpg --output Release.gpg -ba Release

	popd >/dev/null
done
