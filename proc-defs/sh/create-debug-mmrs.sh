#!/bin/bash
# Generate the Linux kernel debug-mmrs.c file based on Blackfin proc XML files

set -e

output="debug-mmrs.c"

cd "$(dirname "${0}")"

cat << EOF > ${output}
/* DO NOT EDIT THIS FILE
 * Automatically generated by toolchain/trunk/proc-defs/sh/create-debug-mmrs.sh
 * DO NOT EDIT THIS FILE
 */

#include <linux/debugfs.h>
#include <linux/fs.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <asm/blackfin.h>

static struct dentry *debug_mmrs_dentry;

static int __init bfin_debug_mmrs_init(void)
{
	struct dentry *top, *parent;

	printk(KERN_DEBUG "Setting up Blackfin MMR debugfs\n");

	top = debugfs_create_dir("blackfin", NULL);
	if (top == NULL)
		return -1;
EOF

for f in ../xml/ADSP-BF*-proc.xml ; do
	unset parent

	echo "Processing ${f}"

	procnum=${f}
	procnum=${procnum#*/ADSP-}
	procnum=${procnum%-proc.xml}

	# dont bother outputting code for procs we dont support
	#if ! grep -qs "^config ${procnum}" ../Kconfig ; then
	#	echo "   ... skipping ${procnum}"
	#	continue
	#fi

cat << EOF >> ${output}

#ifdef __ADSP${procnum}__
# define USE_${procnum} 1
#else
# define USE_${procnum} 0
#endif
	if (USE_${procnum}) {
EOF

	xsltproc ../xsl/debug-mmrs.xsl ${f} | LC_ALL="C" sort -u | \
	while read line ; do
		IFS=";"
		set -- ${line}
		unset IFS
		group=$1 mmr_name=$2 mmr_read=$3 mmr_write=$4 bits=$5

		if [[ -z ${mmr_name} || -z ${bits} || -z ${mmr_read} ]] ; then
			[[ ${group} == "Core" ]] && continue
			echo "Broken line generated! -> $@"
		fi

		if [[ ${parent} != "${group}" ]] ; then
cat << EOF >> ${output}

		parent = debugfs_create_dir("${group}", top);
EOF
			parent=${group}
		fi

		if [[ ${mmr_read} == ${mmr_write} ]] ; then
cat << EOF >> ${output}
		debugfs_create_x${bits}("${mmr_name}", 0600, parent, (u${bits} *)${mmr_read});
EOF
		else
cat << EOF >> ${output}
		debugfs_create_rw_x${bits}("${mmr_name}", 0600, parent, (u${bits} *)${mmr_read}, (u${bits} *)${mmr_write});
EOF
		fi
	done

cat << EOF >> ${output}

	}	/* ${procnum} */
EOF
done

cat << EOF >> ${output}

	debug_mmrs_dentry = top;

	return 0;
}
module_init(bfin_debug_mmrs_init);

static void __exit bfin_debug_mmrs_exit(void)
{
	debugfs_remove_recursive(debug_mmrs_dentry);
}
module_exit(bfin_debug_mmrs_exit);

MODULE_LICENSE("GPL");
EOF
