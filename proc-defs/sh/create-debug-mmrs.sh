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

#define _D(name, bits, addr, perms) debugfs_create_x##bits(name, perms, parent, (u##bits *)addr)
#define D(name, bits, addr)         _D(name, bits, addr, S_IRUSR|S_IWUSR)
#define D_RO(name, bits, addr)      _D(name, bits, addr, S_IRUSR)
#define D_WO(name, bits, addr)      _D(name, bits, addr, S_IWUSR)

extern int last_seqstat;

static inline int sport_width(void *mmr)
{
	unsigned long lmmr = (unsigned long)mmr;
	if ((lmmr & 0xff) == 0x10)
		/* SPORT#_TX has 0x10 offset -> SPORT#_TCR2 has 0x04 offset */
		lmmr -= 0xc;
	else
		/* SPORT#_RX has 0x18 offset -> SPORT#_RCR2 has 0x24 offset */
		lmmr += 0xc;
	/* extract SLEN field from control register 2 and add 1 */
	return (bfin_read16(lmmr) & 0x1f) + 1;
}
static int sport_set(void *mmr, u64 val)
{
	unsigned long flags;
	local_irq_save(flags);
	if (sport_width(mmr) <= 16)
		bfin_write16(mmr, val);
	else
		bfin_write32(mmr, val);
	local_irq_restore(flags);
	return 0;
}
static int sport_get(void *mmr, u64 *val)
{
	unsigned long flags;
	local_irq_save(flags);
	if (sport_width(mmr) <= 16)
		*val = bfin_read16(mmr);
	else
		*val = bfin_read32(mmr);
	local_irq_restore(flags);
	return 0;
}
DEFINE_SIMPLE_ATTRIBUTE(fops_sport, sport_get, sport_set, "0x%08llx\n");
/*DEFINE_SIMPLE_ATTRIBUTE(fops_sport_ro, sport_get, NULL, "0x%08llx\n");*/
DEFINE_SIMPLE_ATTRIBUTE(fops_sport_wo, NULL, sport_set, "0x%08llx\n");
#define _D_SPORT(name, addr, perms, fops) debugfs_create_file(name, perms, parent, (void *)addr, fops)
#define D_SPORT(name, bits, addr)    _D_SPORT(name, addr, S_IRUSR|S_IWUSR, &fops_sport)
#define D_SPORT_RO(name, bits, addr) _D_SPORT(name, addr, S_IRUSR, &fops_sport_ro)
#define D_SPORT_WO(name, bits, addr) _D_SPORT(name, addr, S_IWUSR, &fops_sport_wo)

static struct dentry *debug_mmrs_dentry;

static int __init bfin_debug_mmrs_init(void)
{
	struct dentry *top, *parent;

	printk(KERN_DEBUG "Setting up Blackfin MMR debugfs\n");

	top = debugfs_create_dir("blackfin", NULL);
	if (top == NULL)
		return -1;

	parent = debugfs_create_dir("Core Registers", top);
	debugfs_create_x32("SEQSTAT", S_IRUSR, parent, &last_seqstat);

EOF

for f in ../xml/ADSP-BF*-proc.xml ; do
	unset parent

	[[ ${f} == *BF535* ]] && continue

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

		if [[ -z ${mmr_name} || -z ${bits} || -z ${mmr_read}${mmr_write} ]] ; then
			[[ ${group} == "Core" ]] && continue
			echo "Broken line generated! -> $@"
		fi

		if [[ ${parent} != "${group}" ]] ; then
cat << EOF >> ${output}

		parent = debugfs_create_dir("${group}", top);
EOF
			parent=${group}
		fi

		special=
		case ${mmr_name} in
			SPORT*_[RT]X) special="_SPORT" ;;
		esac

		func=
		if [[ -z ${mmr_read} ]] ; then
			func="_WO"
		elif [[ -z ${mmr_write} ]] ; then
			func="_RO"
		elif [[ ${mmr_read} == ${mmr_write} ]] ; then
			func=""
		else
			func="_RW"
		fi
		func="D${special}${func}"

cat << EOF >> ${output}
		${func}("${mmr_name}", ${bits}, ${mmr_read:-${mmr_write:-WTF}});
EOF
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
