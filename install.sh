#!/bin/bash
#
# File:         install.sh
# Created:      200517
# Description:  description for install.sh
#

### FUNCTIONS ###


# libxc files:
#local_install/bin/xc-info.exe
#local_install/include/libxc_funcs_m.mod
#local_install/include/xc.h
#local_install/include/xc_config.h
#local_install/include/xc_f03_lib_m.mod
#local_install/include/xc_f90_lib_m.mod
#local_install/include/xc_f90_types_m.mod
#local_install/include/xc_funcs.h
#local_install/include/xc_unconfig.h
#local_install/include/xc_version.h
#local_install/lib/libxc.a
#local_install/lib/libxc.la
#local_install/lib/libxcf03.a
#local_install/lib/libxcf03.la
#local_install/lib/libxcf90.a
#local_install/lib/libxcf90.la
#local_install/lib/pkgconfig
#local_install/lib/pkgconfig/libxc.pc

automake_install()
{
 $GPAW/sh/build-automake.sh
 return $?
}

libxc_install()
{
 $GPAW/sh/build-libxc.sh
 return $?
}

blas_install()
{
 $GPAW/sh/build-blas.sh
 return $?
}

libxc_test()
{
 typeset _l="$GPAW/local_install"
 typeset uninstalled=0

 [ ! -f "$_l/include/xc.h" -o ! -f "$_l/lib/libxc.a" ] && uninstalled=1

 [ "$uninstalled" -ne 0 ] && { echo "building and installing libxc"; libxc_install; return $?; }

 echo "libxc already installed."
 return 0
}

automake_test()
{
 typeset _l="$GPAW/local_install"
 typeset uninstalled=0

 [ ! -f "$_l/bin/aclocal" ] && uninstalled=1

 [ "$uninstalled" -eq 1 ] && { automake_install; return $?; }

 echo "automake already installed."
 return 0
}

blas_test()
{
 typeset _l="$GPAW/local_install"
 typeset uninstalled=0

 [ ! -f "$_l/lib/libblas.so" ] && uninstalled=1

 [ "$uninstalled" -eq 1 ] && { blas_install; return $?; }

 echo "blas already installed."
 return 0
}



#
#
lapack_test()
{
 typeset libs="liblapack.a librefblas.a libtmglib.a"
 typeset _l="$GPAW/local_install/lib"
 typeset fp=""
 typeset uninstalled=0

 for lib in $libs
 do
  fp="${_l}/${lib}"

  [ ! -f "$fp" ] && { uninstalled=1; break; }
 done

 [ "$uninstalled" -eq 1 ] &&
 {
  $GPAW/sh/build-lapack.sh
  return $?
 }

 echo "lapack already installed."
 return 0
}

### ENV ###

 export GPAW="$1"
 [ -z "$GPAW" ] && { echo "usage: $0 instal path";  exit 1; }

 # this is temporary... for real!
 mkdir -p $GPAW/sh
 cp *.sh $GPAW/sh

 export workDir="$GPAW/software"
 export PATH="$workDir/bin:$PATH"
 export virtualenv="$GPAW/venv"
 export activate="$virtualenv/bin/activate"

### MAIN ###

 python3 -m venv $virtualenv || { echo "Python virtualenv creation failed!"; exit 1; }
 [ ! -f "$activate" ] && { echo "virtualenv activate does not exist!"; exit 1; }

 . "$activate"

# test if libxc is installed if not build/install

 automake_test || exit $?
 blas_test || exit $?
 lapack_test || exit $?
 libxc_test || exit $?
 echo

# work-around to non working requirements.txt

 pip install -U numpy   &&
 pip install -U ase     &&
 CFLAGS="-I${workDir}/include"  \
 LDFLAGS="-L${workDir}/lib"     \
 pip install -U gpaw	&&
 pip install -U setuptools_scm	&&
 pip install -U -r $GPAW/requirements.txt

### EOF ###
