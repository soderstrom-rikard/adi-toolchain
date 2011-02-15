#!/bin/bash

pushd dists >/dev/null

for d in */ ; do
	d=${d%/}
	pushd $d >/dev/null
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
