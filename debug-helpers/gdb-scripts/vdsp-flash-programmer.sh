#!/bin/sh
#
# This script takes a VDSP flash driver, cleans it up, then
# loads it up with gdb and sets up an environment for using
# said driver.  All the commands can be found in the local
# gdb script anyways ...
#
# There are many symbols labeled as optional, but the current
# code assumes that they're pretty much all provided.
#

set -e

err() { echo "ERROR: $*" 1>&2; exit 1; }
info() { echo "INFO: $*"; }

drv=$1
cross=bfin-elf-

[ -e "${drv}" ] || err "Usage: ${0##*/} <vdsp flash driver>"

info "Cleaning up driver: ${drv}"

tmp=$(mktemp)
cp "${drv}" "${tmp}"
drv=${tmp}

# GDB barfs if there is no .text section, so rename it #4337
#${cross}objcopy --rename-section L1_code=.text "${drv}"
# Filter out all unnessary noise to avoid conflicts between VDSP's
# ELF implementation and the GNU implementation
syms=`${cross}readelf -W -s "${drv}" | awk '($NF ~ /AFP_/ || ($5 == "GLOBAL" && $4 != "NOTYPE")) { print $NF }'`
${cross}strip `printf -- '-K %s ' ${syms}` "${drv}"

info "Launching gdb"

tmp=$(mktemp)
cat << EOF > "${tmp}"

set pagination off

# Connect to the target
target remote localhost:2000
# Do it again for BF54x (hardware error needs clearing)
target remote localhost:2000

# Grab all of our gdb helper commands
source ${0%/*}/vdsp-flash-programmer
sanity_check_hwerr

# Load the Flash Driver
load

# get the mwl helper command
source ${0%/*}/u-boot

# Zero out the BSS(s)
$(eval `${cross}readelf -l "${drv}" | awk '$1 == "LOAD" && $5 != $6 { print "echo mwl $(("$3"+"$5")) 0 $((("$6"-"$5")/4))" }'`)
sanity_check_hwerr

# Clear all breakpoints
delete breakpoints

# Halt on the canonical point
hbreak *(int *)&AFP_BreakReady
commands
	silent
end

# Use hardware tracing when possible
#hbreak cpu_init_f
#commands
#	hwtrace_on
#	sanity_check_hwerr
#	continue
#end
#hbreak evt_default
#sanity_check_hwerr

# Let the driver initialize itself
continue
sanity_check_hwerr

# Dump the initial Flash Driver and Flash state
printf "\n"
fldrvinfo
printf "\n"
flinfo
printf "\n"

# Clean up the temporary files
shell rm -f "${tmp}" "${drv}"

# Tell the user what commands are available
printf "Now you can use the commands (run 'help cmd' for more info):\n"
$(awk '$1 == "define" && $2 ~ /^fl/ { print "printf \"\\t" $NF "\\n\"" }' "${0%/*}/vdsp-flash-programmer")

EOF
#cat "$tmp"

#bfin-gdbproxy bfin --reset --connect='cable gnICE+' &

exec bfin-elf-gdb --quiet -x "${tmp}" "${drv}"
