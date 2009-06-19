#!/bin/sh

list=${1:-list}

# dewikify some stuff
sed -i \
	-e 's:⇐:<=:g' \
	-e 's:[“”]:":g' \
	${list}

while read line ; do
	a=${line%% *}
	d=${line#${a} }

	for h in */anomaly.h ; do
		awk \
			-v A="$a" \
			-v D="$d" \
		'{
			if ($1 == "/*") {
				d = $0
				next
			} else if ($1 == "#define" && $2 == A) {
				if (d && d !~ /Anomalies that don.t exist on this proc/)
					d = "/* " D " */"
			}
			if (d) {
				print d
				d = ""
			}

			print
		}' $h > $h.new
		mv $h.new $h
	done
	echo "$a"
done < ${list}
