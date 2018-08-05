#!/bin/bash
#
# File:         build-libxc.sh
# Created:      180215
# Description:  buildscript for libxc
#

### ENV ###

id="libxc"
projectdir="${GPAW}"
src="${projectdir}/source/${id}"
target="${projectdir}/build/${id}"
install="${projectdir}/software"
build_id="libxc.${RANDOM}"

### MAIN ###

# Sanity checks

[ ! -d "${projectdir}" ] && { echo "Project directory invalid"; exit 1; }
[ ! -d "${src}" ] && { echo "Source directory invalid"; exit 1; }
[ ! -d "${target}" ] && { mkdir -p "${target}" || exit 1; }

# Actual main

cd ${target} || { echo "Failed changing directory to target: ${target}"; exit 1; }

# Step 1: Configure
log="configure.${build_id}.log"
${src}/configure --enable-shared --prefix="${install}" > ${log} 2>&1
rc="$?"
[ "$rc" -ne 0 ] &&
{
 cat "${log}"
 rn -f "${log}"
 echo "Configure step failed with return code ${rc}"
 exit ${rc}
}

# Step 2: Make
log="make.${build_id}.log"
make > ${log} 2>&1
rc="$?"
[ "$rc" -ne 0 ] &&
{
 cat "${log}"
 rn -f "${log}"
 echo "Make step failed with return code ${rc}"
 exit ${rc}
}

# Step 3: Make Install
log="makeinstall.${build_id}.log"
make install > ${log} 2>&1
rc="$?"
[ "$rc" -ne 0 ] &&
{
 cat "${log}"
 rn -f "${log}"
 echo "Make install step failed with return code ${rc}"
 exit ${rc}
}

exit 0

### EOF ###
