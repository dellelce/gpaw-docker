#!/bin/bash
#
# Building for docker // this is only needed until mkit does not have proper testing
#
# File:         docker.sh
# Created:      250718
#

### FUNCTIONS ###

test_file()
{
 typeset f="$1"
 typeset basef="$(basename $f)"

 [ ! -f "$f" ] && { echo "File $f does not exist."; return 1; }

 echo "File ${basef} exists."
 ls -lt "$f"

 return 0
}

test_any()
{
 typeset f="$1"
 typeset basef="$(basename $f)"

 [ ! -e "$f" ] && { echo "$f does not exist."; return 1; }

 echo "File ${basef} exists."
 ls -lt "$f"

 return 0
}

test_dir()
{
 typeset d="$1"

 [ ! -d "$d" ] && { echo "Directory $d does not exist."; return 1; }
 return 0
}

### MAIN ###

set -x
prefix="$1"
sudo ./install.sh $prefix
rc=$?

echo "mkit rc: $rc"

### EOF ###
