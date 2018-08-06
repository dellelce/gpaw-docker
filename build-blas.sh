#!/bin/bash
#
# Created:      220215
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

 awk -vroot=$root -vtarget=$target \
'
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
 END \
 {
  print " echo Created: for " cnt " links";
 }
'
}

### ENV ###

id="blas"
buildid="${id}.${RANDOM}"
projectdir="${GPAW}"
src="${projectdir}/source/${id}"
target="${projectdir}/build/${id}"
install="${projectdir}/software"

### MAIN ###

# Sanity checks

[ ! -d "${projectdir}" ] && { echo "Project directory invalid"; exit 1; }
[ ! -d "${src}" ] && { echo "Source directory invalid"; exit 1; }
[ ! -d "${target}" ] && { mkdir -p "${target}" || exit 1; }

# Actual main
# Make links for files and re-create directories in build directory

allDirs=$(find $src  -type d | _basename ${src} )

cd ${target} || { echo "Failed changing directory to target: ${target}"; return 1; }

# Blas does not have dirs (...for now...)
[ ! -z "${allDirs}" ] && mkdir -p ${allDirs}

find $src -type f | awk '!/\.git/&&!/\.out$/&&!/\.o$/&&!/\.a$/' | _bulk_ln $src $target | sh
rc=$?

[ $rc -ne 0 ] && { echo "failed creating links"; exit 1; }

#
echo "Starting at :"$(date)

# Make it
log="/tmp/make.${buildid}.log"
make > ${log} 2>&1
rc=$?
[ $rc -eq 0 ] &&
{
 liba="blas_LINUX.a"
 libso="libblas.so"

 [ ! -f "$liba" ] && { echo "library file does not exist: $liba"; exit 1; }
 [ ! -f "$libso" ] && { echo "shared library file does not exist: $liba"; exit 1; }

 # blas Makefile does not have an install
 mkdir "$install/lib" # make sure $install/lib exists!

 cp ${liba} "${install}/lib" || { echo "Failed copying ${liba}"; exit $?; }
 cp ${libso} "${install}/lib" || { echo "Failed copying ${libso}"; exit $?; }
 ln -sf "${install}/lib/${liba}" "${install}/lib/blas.a" || exit $?
 ln -sf "${install}/lib/${liba}" "${install}/lib/libblas.a" || exit $?
} ||
{
 # show log only on failure!
 cat "${log}"
}

rm -f "${log}"
ls -lt $install/lib

exit $rc

### EOF ###
