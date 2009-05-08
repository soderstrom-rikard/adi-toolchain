#!/bin/sh

if [ -z "$*" ] ; then
	echo "Usage: stub-it.sh <anomalies to stub>"
	exit 1
fi

stubs=""
for s in "$@" ; do
	s=$(echo ${s} | sed \
		-e 's:ANOMALY_::' \
		-e 's:^05::' \
		-e 's:^0*::')
	stubs="${stubs} ${s}"
done
stubs=$(echo $(echo ${stubs} | tr ' ' '\n' | sort -u -n))
echo "Stubbing out: ${stubs}"

stub_marker="/* Anomalies that don't exist on this proc */"

for h in */anomaly.h ; do
	awk \
		-v STUB_MARKER="${stub_marker}" \
		-v SSTUBS="${stubs}" \
	'BEGIN {
		state = 0
		split(SSTUBS, STUBS)
	}
	{
		if ($1 == "#define" && $2 ~ /^ANOMALY_/) {
			a = $2
			sub(/^ANOMALY_/, "", a)
			sub(/^050*/, "", a)

			for (stub in STUBS)
				if (a == STUBS[stub])
					delete STUBS[stub]
		}

		if (state == 0 && $0 == STUB_MARKER) {
			state = 1
		} else if (state == 1 && NF == 0) {
			state = 2
			for (stub in STUBS)
				printf "#define ANOMALY_05%06i (0)\n", STUBS[stub]
		} else if (state == 1) {
			for (stub in STUBS)
				if (a > STUBS[stub]) {
					printf "#define ANOMALY_05%06i (0)\n", STUBS[stub]
					delete STUBS[stub]
				}
		}
		print
	}' ${h} > ${h}.new
	mv ${h}.new ${h}
done
