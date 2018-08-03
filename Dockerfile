FROM python:3.7-alpine as build

MAINTAINER Antonio Dell'Elce

ARG BUILDDIR
ENV BUILDDIR  /app/gpaw/build

ARG INSTALLDIR
ENV INSTALLDIR  /app/gpaw

# gcc             most of the source needs gcc
# bash            busybox does not support some needed features of bash like "typeset"
# wget            builtin wget does not work for us
# perl            I'll pass...
# file            no magic inside
# xz              xz is the "best"
# libc-dev        headers
# linux-headers   more headers
ARG PACKAGES
ENV PACKAGES gcc bash ncurses ncurses-libs wget perl file xz make libc-dev linux-headers g++

WORKDIR $BUILDDIR
COPY . $BUILDDIR

RUN  apk add --no-cache  $PACKAGES &&  \
     bash ${BUILDDIR}/docker.sh $INSTALLDIR

# Second Stage -- second stage comes later

#FROM alpine:latest AS final

#RUN mkdir -p ${INSTALLDIR} && \
#    apk add --no-cache libgcc ncurses-libs
#
#WORKDIR ${INSTALLDIR}
##COPY --from=build ${INSTALLDIR} .
