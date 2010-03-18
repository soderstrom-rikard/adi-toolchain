#!/bin/sh

usage() {
	cat <<-EOF
	Usage: $0 [-rs] [-rj <board>] [-rh <board ip>] [tests]

	If no tests are specified, all tests are processed.

	Options:
	  -rs          Run on simulator
	  -rj <board>  Run on board via JTAG
	  -rh <ip>     Run on board ip
	EOF
	exit ${0:-1}
}

: ${MAKE:=make}
boardip=
boardjtag=
run_sim=false
run_jtag=false
run_host=false
while [ -n "$1" ] ; do
	case $1 in
		-rs) run_sim=true;;
		-rj) boardjtag=$2; shift; run_jtag=true;;
		-rh) boardip=$2; shift; run_host=true;;
		-*)  usage;;
		*)   break;;
	esac
	shift
done
${run_jtag} || ${run_host} || ${run_sim} || run_sim=true

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

dojtag() {
	if grep -q CHECKREG ${1%.x} ; then
		echo "DBGA does not work via JTAG"
		exit 77
	fi

	cat <<-EOF > commands
	target remote localhost:2000
	load
	b *_pass
	commands
	exit 0
	end
	b *_fail
	commands
	exit 1
	end
	c
	EOF
	bfin-elf-gdb -x commands "$1"
	ret=$?
	rm -f commands
	exit ${ret}
}

testit() {
	local name=$1 x=$2 out
	shift; shift
	printf '%-5s %-40s' ${name} ${x}
	out=`"$@" ${x}`
	(pf "${out}")
	: $(( ret += $? ))
}

pf() {
	local ret=$?
	if [ ${ret} -eq 0 ] ; then
		echo "PASS"
	elif [ ${ret} -eq 77 ] ; then
		echo "SKIP $*"
	else
		echo "FAIL! $*"
		exit 1
	fi
}

[ $# -eq 0 ] && set -- *.[Ss]
bins_hw=$( (${run_sim} || ${run_jtag}) && printf '%s.x ' "$@")
bins_host=$(${run_host} && printf '%s.X ' "$@")
bins_all="${bins_hw} ${bins_host}"

printf 'Compiling tests: '
${MAKE} -s -j ${bins_all}
pf

if ${run_jtag} ; then
	printf 'Setting up gdbproxy (see gdbproxy.log): '
	killall -q bfin-gdbproxy
	bfin-gdbproxy -q bfin --reset --board=${boardjtag} --init-sdram >gdbproxy.log 2>&1 &
	t=0
	while [ ${t} -lt 5 ] ; do
		if netstat -nap 2>&1 | grep -q ^tcp.*:2000.*gdbproxy ; then
			break
		else
			: $(( t += 1 ))
			sleep 1
		fi
	done
	pf
fi

if ${run_host} ; then
	printf 'Uploading tests to board "%s": ' "${boardip}"
	rcp ${bins_host} root@${boardip}:/tmp/
	pf
fi

ret=0
for s in "$@" ; do
	${run_sim}  && testit SIM  ${s}.x bfin-elf-run
	${run_jtag} && testit JTAG ${s}.x dojtag
	${run_host} && testit HOST ${s}.X dorsh
done

killall -q bfin-gdbproxy
if [ ${ret} -eq 0 ] ; then
	rm -f gdbproxy.log
	${MAKE} -s clean &
	exit 0
else
	exit 1
fi
