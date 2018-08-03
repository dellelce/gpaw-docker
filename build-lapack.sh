#!/bin/bash
#
# File:         build-lapack.sh
# Created:      
# Description:  lapack build
#

### FUNCTIONS ###

#
# custom basename

_basename()
{
 typeset root="$1"

 awk -vroot=$root '
{
  rootlen = length(root)
  base = substr($0, rootlen + 2, length($0) - rootlen)

  if (length(base) != 0) { print base; }
}
'
}
 
_bulk_ln()
{
 typeset root="$1" 
 typeset target="$2" 

 awk -vroot=$root -vtarget=$target '
BEGIN { cnt = 0; }
{
  rootlen = length(root)
  base = substr($0, rootlen + 2, length($0) - rootlen)

  if (length(base) != 0)
  {
    print "ln -sf " $0 " "target "/" base " &&";
    cnt = cnt + 1;
    if (cnt % 100 == 0) { print "echo success for " cnt; }
  }
}
END { print " echo Success: for " cnt " links" ; }
'
}

#
# debug / more informational echo
#

decho()
{
  echo "lapack: $*"
}

### ENV ###

id="lapack"
projectdir="${GPAW}"
src="${projectdir}/libs/${id}"
target="${projectdir}/build/${id}"
install="${projectdir}/local_install"

### MAIN ###

# Sanity checks

[ ! -d "${projectdir}" ] && { echo "Project directory invalid"; exit 1; }
[ ! -d "${src}" ] && { echo "Source directory invalid"; exit 1; }
[ ! -d "${target}" ] && { mkdir -p "${target}" || exit 1; }

# Actual main
# Make links for files and re-create directories in build directory

allDirs=$(find $src  -type d | _basename ${src} )

cd ${target} || { echo "Failed changing directory to target: ${target}"; return 1; }
pwd
mkdir -p ${allDirs}

# Create symlinks for all files
find $src -type f | awk '
   !/\.git/&&!/\.out$/&&!/\.o$/&&!/\.a$/
' | _bulk_ln $src $target | sh
rc=$?

[ $rc -ne 0 ] && { echo "failed creating links"; exit 1; }

echo "Creating make.inc"
pwd

ln -sf make.inc.example make.inc

ls -lt Makefile.orig
ls -lt Makefile

echo "Starting at :"$(date)

# blaslib not built automatically by make: WHY!?
# lapack_install lib
make blaslib && make lapack_install lib
make_rc=$?

[ "$make_rc" -ne 0 ] && { echo "Make failed with return code: $make_rc"; exit $make_rc; }

libs="./liblapack.a
./librefblas.a
./libtmglib.a
"

# There is no "make install" in lapack (.......!)
for lib in $libs
do
 echo "Installing $lib"
 cp "$lib" "$install/lib" || { rc=$?; echo "Failed copying $lib: return code = $rc"; exit $rc; }
done

### EOF ###