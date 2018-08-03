#!/bin/bash
#
# File:         build-automake
# Created:      250916
# Description:  buildscript for automake
#
# 130817 Converting to GPAW use
#

### ENV ###

id="automake"
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

cd ${target} || { echo "Failed changing directory to target: ${target}"; exit 1; }

# workaround
(
 cd "$src"
 tar cf - .
) |
 tar xf -

# Step 1: Configure
${src}/configure --srcdir="$src" --prefix="${installtmp}" MAKEINFO=:
rc="$?"
[ "$rc" -ne 0 ] && { echo "Configure step failed with return code ${rc}"; exit ${rc}; } 

# Step 2"alpha": Make bootstrap
make bootstrap
rc="$?"
[ "$rc" -ne 0 ] && { echo "Make for bootstrap step failed with return code ${rc}"; exit ${rc}; } 

# Step 2: Make
make
rc="$?"
[ "$rc" -ne 0 ] && { echo "Make step failed with return code ${rc}"; exit ${rc}; } 
 
# Step 3: Make Install
make install
rc="$?"
[ "$rc" -ne 0 ] && { echo "Make step failed with return code ${rc}"; exit ${rc}; } 

exit 0

### EOF ###
