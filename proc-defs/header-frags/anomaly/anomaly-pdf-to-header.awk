#!/usr/bin/awk -f
{
anomaly = $1
if (anomaly == "")
	next;
sub(/^[[:digit:]]* /, "");

if (NF == 1) {
	getline
	print "/* " $0 " */"
	print "#define ANOMALY_" anomaly " ()"
} else {
	print "/* " $0 " */"
	print "#define ANOMALY_" anomaly " ()"
}
}
