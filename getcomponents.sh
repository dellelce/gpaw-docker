#!/bin/bash
#
# Created:      040818
#

### FUNCTIONS ###

fileMap()
{
#automake   https://github.com/TheApacheCats/automake/archive/1.15.tar.gz
 cat << EOF
blas       https://bitbucket.org/antoniodellelce/blas/get/3.5.0-2017.tar.bz2
lapack     https://bitbucket.org/antoniodellelce/lapack/get/lapack-3.5.0-fpic.tar.bz2
libxc      https://bitbucket.org/antoniodellelce/libxc/get/libxc-3.0.0.tar.bz2
EOF
}

# download "components"
downloadComponents()
{
 typeset list=$(fileMap | awk ' { print $2 } ' )

 for url in $list
 do
  bn=$(basename $url)

  [ ! -f "$bn" ] && { wget -q $url; }
 done

 return 0 # make it explicit
}

# uncompress all components
uncompressAll()
{
 fileMap | while read name url
 do
  burl=$(basename $url)
  echo $burl $name

  xname="_${name}"

  [ ${burl} != ${burl%.gz} ] &&
  {
   mkdir -p "${xname}"
   tar xzf "${burl}" -C "${xname}"
  }

  [ ${burl} != ${burl%.bz2} ] &&
  {
   mkdir -p "${xname}"
   tar xjf "${burl}" -C "${xname}"
  }

  badPath=$(ls -1d $xname/*)

  mv "$badPath" "$name"
 done

 return 0 # make it explicit
}

### MAIN ###

downloadComponents && uncompressAll
exit $?

### EOF ###
