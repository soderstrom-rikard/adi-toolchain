#!/bin/sh
# turn copy & paste list from anomaly list into header
awk '{
if (NF < 1) {
	print "goodby"
	exit 0
}
num = $1
sub(/^[^ ]* /, "")
print "/* " $0 " */"
print "#define ANOMALY_" num " (1)"
}' "$@"
