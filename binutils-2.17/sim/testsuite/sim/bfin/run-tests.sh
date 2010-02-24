#!/bin/sh

usage() {
	cat <<-EOF
	Usage: $0 [-rs] [-rh <board ip>] [tests]

	If no tests are specified, all tests are processed.

	Options:
	  -rs        Run on simulator
	  -rh <ip>   Run on board ip
	EOF
	exit ${0:-1}
}

: ${MAKE:=make}
boardip=
run_sim=false
run_host=false
while [ -n "$1" ] ; do
	case $1 in
		-rs) run_sim=true;;
		-rh) boardip=$2; shift; run_host=true;;
		-*)  usage;;
		*)   break;;
	esac
	shift
done
! ${run_host} && ! ${run_sim} && run_sim=true

if ${run_host} && [ -z "${boardip}" ] ; then
	usage
fi

dorsh() {
	# rsh sucks and does not pass up its exit status, so we have to:
	#  on board:
	#    - send all output to stdout
	#    - send exit status to stderr
	#  on host:
	#    - swap stdout and stderr
	#    - pass exit status to `exit`
	#    - send stderr back to stdout and up
	(exit \
		$(rsh -l root $boardip \
			'(/tmp/'$1') 2>&1; ret=$?; echo $ret 1>&2; [ $ret -eq 0 ] && rm -f /tmp/'$1 \
			3>&1 1>&2 2>&3) \
		2>&1) 2>&1
}

pf() {
	if [ $? -eq 0 ] ; then
		echo "PASS"
	else
		echo "FAIL! $*"
		exit 1
	fi
}

[ $# -eq 0 ] && set -- *.[Ss]
bins_sim=$(${run_sim} && printf '%s.x ' "$@")
bins_host=$(${run_host} && printf '%s.X ' "$@")
bins_all="${bins_sim} ${bins_host}"

printf 'Compiling tests: '
${MAKE} -s -j ${bins_all}
pf

if ${run_host} ; then
	printf 'Uploading tests to board "%s": ' "${boardip}"
	rcp ${bins_host} root@${boardip}:/tmp/
	pf
fi

ret=0
for s in "$@" ; do
	if ${run_sim} ; then
		x=${s}.x
		printf '%-5s %-30s' SIM ${x}
		out=`bfin-elf-run ${x}`
		(pf "${out}")
		: $(( ret += $? ))
	fi

	if ${run_host} ; then
		x=${s}.X
		printf '%-5s %-30s' HOST ${x}
		out=`dorsh ${x}`
		(pf "${out}")
		: $(( ret += $? ))
	fi
done

if [ ${ret} -eq 0 ] ; then
	${MAKE} -s clean &
	exit 0
else
	exit 1
fi
