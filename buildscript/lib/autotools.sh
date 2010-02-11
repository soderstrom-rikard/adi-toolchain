# give it the log file to rip out EXEEXT
get_exeext() { eval `grep ^EXEEXT= "$@"`; }

reset_autotool_hooks()
{
	at_clean() { :; }
	at_make_args() { :; }
}

build_autotooled_pkg()
{
	local ver
	local src="$1"
	local pkg="${src##*/}"
	local build="${DIR_BUILD}/${pkg}_build"
	shift

	resume_check "${pkg}" && return 0

	change_dir "${src}"

	ver=$("${src}"/configure --version | awk '{print $NF;exit}')

	echo_date "${pkg}: cleaning (${ver})"
	find . -print0 | xargs -0 touch -r . # fix autotool timestamps
	at_clean
	[ -e Makefile ] && run_cmd $MAKE distclean

	change_clean_dir "${build}"

	echo_date "${pkg}: configuring"
	export ac_cv_path_DOXYGEN=:
	grep -qs disable-silent-rules "${src}"/configure && \
		set -- --disable-silent-rules "$@"
	run_cmd "${src}"/configure --prefix=/ $BUILD_TARGET $HOST_TARGET "$@"

	echo_date "${pkg}: building"
	run_cmd $MAKE $(at_make_args)
	get_exeext "${build}"/config.log

	echo_date "${pkg}: installing"
	at_install() {
		run_cmd $MAKE install DESTDIR="$1" program_transform_name=s,^,bfin-, $(at_make_args)
	}
	at_install "${DIR_ELF_OUTPUT}"
	if [ $KERNEL_SOURCE ] ; then
		at_install "${DIR_uC_OUTPUT}"
		at_install "${DIR_LINUX_OUTPUT}"
	fi

	# mung the local .pc files so other packages in here can find them
	run_cmd rm -f "${DIR_ELF_OUTPUT}"/lib/*.la
	run_cmd_nodie sed -i "/^prefix=/s:=.*:=${DIR_ELF_OUTPUT}:" \
		"${DIR_ELF_OUTPUT}"/lib/pkgconfig/*.pc

	run_cmd rm -rf "${build}"

	resume_save

	reset_autotool_hooks
}

reset_autotool_hooks
