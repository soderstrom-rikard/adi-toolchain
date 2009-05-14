#!/usr/bin/awk -f
{
anomaly = $1
if (anomaly == "")
	next;
sub(/^[[:digit:]]* /, "");
print "/* " $0 " */"
print "#define ANOMALY_" anomaly " ()"
}
