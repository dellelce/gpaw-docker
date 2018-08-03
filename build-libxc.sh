#!/bin/bash
#
# File:         build-libxc.sh
# Created:      180215
# Description:  buildscript for libxc
#

### FUNCTIONS ###



### ENV ###

id="libxc"
projectdir="${GPAW}"
src="${projectdir}/libs/${id}"
target="${projectdir}/build/${id}"
installtmp="${projectdir}/local_install"

### MAIN ###

# Sanity checks

[ ! -d "${projectdir}" ] && { echo "Project directory invalid"; exit 1; } 
[ ! -d "${src}" ] && { echo "Source directory invalid"; exit 1; } 
[ ! -d "${target}" ] && { mkdir -p "${target}" || exit 1; }

# Actual main

# Workaround for missing expl()/fabsl()

#[ "$(uname -o)" == "Cygwin" ] && export CFLAGS="-Dexpl=exp -Dfabsl=fabs -Dlogl=log"

cd ${target} || { echo "Failed changing directory to target: ${target}"; exit 1; }

# Step 1: Configure
${src}/configure --enable-shared --prefix="${installtmp}"
rc="$?"
[ "$rc" -ne 0 ] && { echo "Configure step failed with return code ${rc}"; exit ${rc}; } 

# Step 2: Make
make
rc="$?"
[ "$rc" -ne 0 ] && { echo "Make step failed with return code ${rc}"; exit ${rc}; } 
 
# Step 3: Make Install
make install
rc="$?"
[ "$rc" -ne 0 ] && { echo "Make step failed with return code ${rc}"; exit ${rc}; } 

### EOF ###