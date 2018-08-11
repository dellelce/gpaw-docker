#!/bin/bash
#
# File:         build-libxc.sh
# Created:      180215
# Description:  buildscript for libxc
#

### ENV ###

id="libxc"
buildid="${id}.${RANDOM}"
projectdir="${GPAW}"
src="${projectdir}/source/${id}"
target="${projectdir}/build/${id}"
install="${projectdir}/software"

### MAIN ###

# Sanity checks
[ ! -d "${projectdir}" ] && { echo "Project directory invalid: ${projectdir}"; exit 1; }
[ ! -d "${src}" ] && { echo "Source directory invalid: ${src}"; exit 1; }
[ ! -d "${target}" ] && { mkdir -p "${target}" || exit 1; }

# Actual main

cd ${target} || { echo "Failed changing directory to target: ${target}"; exit 1; }

# Step 1: Configure
log="configure.${buildid}.log"
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
log="make.${buildid}.log"
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
log="makeinstall.${buildid}.log"
make install > ${log} 2>&1
rc="$?"
[ "$rc" -ne 0 ] &&
{
 cat "${log}"
 rn -f "${log}"
 echo "Make install step failed with return code ${rc}"
 exit ${rc}
}

# extra check
ls -lt $install/lib

exit 0

### EOF ###
