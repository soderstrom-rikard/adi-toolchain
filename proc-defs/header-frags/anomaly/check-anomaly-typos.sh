#!/bin/sh
#
# convert each ANOMALY_xxx define in the header to if(...){} statements
# so that we can catch random typos in the defines that otherwise wouldnt
# so up due to the CPP aspect
#

for h in */anomaly.h ; do
	echo $h

cat <<EOF | gcc -x c - -o /dev/null -D__SILICON_REVISION__=10
#include "$h"
int main() {
$(awk '($1 == "#define" && $2 ~ /^ANOMALY_/) { print "if (" $2 ") {}" }' $h)
}
EOF

done
