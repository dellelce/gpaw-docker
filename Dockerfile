FROM python:3.7-alpine as build

MAINTAINER Antonio Dell'Elce

ARG INSTALLDIR
ENV INSTALLDIR  /app/gpaw

ARG BUILDDIR
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

# Second Stage -- second stage comes later

#FROM alpine:latest AS final

#RUN mkdir -p ${INSTALLDIR} && \
#    apk add --no-cache libgcc ncurses-libs
#
#WORKDIR ${INSTALLDIR}
##COPY --from=build ${INSTALLDIR} .
