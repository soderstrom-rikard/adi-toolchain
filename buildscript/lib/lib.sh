if [ -z "${_BUILDTOOLCHAIN_SETUP_}" ] ; then

APP_NAME=${0##*/}
DIR_APP=$(cd "${0%/*}" && pwd)

# Assume default toolchain dir is up one directory from the build script helper
DIR_SOURCE=${DIR_APP%/*}

_LIB_DIR=${DIR_APP}/lib
source "${_LIB_DIR}/funcs.sh"
source "${_LIB_DIR}/autotools.sh"
source "${_LIB_DIR}/prereqs.sh"
source "${_LIB_DIR}/resume.sh"

export _BUILDTOOLCHAIN_SETUP_=1

fi
