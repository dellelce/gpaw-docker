FROM dellelce/mkit:latest as build

MAINTAINER Antonio Dell'Elce

ENV INSTALLDIR  /app/gpaw
ENV BUILDDIR  ${INSTALLDIR}/build

# gcc             most of the source needs gcc
# bash            busybox does not support some needed features of bash like "typeset"
# wget            builtin wget does not work for us
# perl            I'll pass...
# file            no magic inside
# xz              xz is the "best"
# libc-dev        headers
# linux-headers   more headers

ENV MATPLOTLIB  freetype-dev libpng-dev
ENV AUTOTOOLS   autoconf automake
ENV COMPILERS   gcc g++ gfortran

ARG PACKAGES
ENV PACKAGES ncurses ncurses-libs wget perl file xz make ${COMPILERS} \
             bash libc-dev linux-headers ${MATPLOTLIB} ${AUTOTOOLS}

WORKDIR $BUILDDIR
COPY *.sh $BUILDDIR/

# these three directories are prepared by "getcomponents.sh"
COPY blas $INSTALLDIR/source/blas
COPY lapack $INSTALLDIR/source/lapack
COPY libxc $INSTALLDIR/source/libxc

COPY requirements.txt $INSTALLDIR

RUN  apk add --no-cache  $PACKAGES &&  \
     bash ${BUILDDIR}/docker.sh $INSTALLDIR

# Second Stage
FROM dellelce/mkit:latest AS final

ENV GPAWDIR   /app/gpaw/software
ENV HTTPDDIR  /app/httpd

RUN mkdir -p "${GPAWDIR}"

COPY --from=build ${GPAWDIR} ${GPAWDIR}
