FROM dellelce/mkit:latest as build

LABEL maintainer="Antonio Dell'Elce"

ENV GPAW         /app/gpaw
ENV BUILDDIR     ${GPAW}/build
ENV GPAWINSTALL  ${GPAW}/software

# Packages description here
# MATPLOTLIB:  needed by ase
ENV MATPLOTLIB  freetype-dev libpng-dev
ENV AUTOTOOLS   autoconf automake perl
ENV COMPILERS   gcc g++ gfortran make
ENV COREDEV     libc-dev linux-headers make

ENV PACKAGES wget bash ${COMPILERS} ${MATPLOTLIB} ${AUTOTOOLS}

WORKDIR $BUILDDIR
COPY *.sh $BUILDDIR/

# these three directories are prepared by "getcomponents.sh"
COPY blas   $GPAW/source/blas
COPY lapack $GPAW/source/lapack
COPY libxc  $GPAW/source/libxc

COPY requirements.txt $INSTALLDIR

RUN  apk add --no-cache  $PACKAGES &&  \
     bash ${BUILDDIR}/docker.sh $INSTALLDIR

# Second Stage
FROM dellelce/mkit:latest AS final

ENV GPAWDIR   /app/gpaw/software
ENV HTTPDDIR  /app/httpd

RUN mkdir -p "${GPAWDIR}"

COPY --from=build ${GPAWDIR} ${GPAWDIR}
