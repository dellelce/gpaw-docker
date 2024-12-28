# GPAW Density Functional Theory Dockerfile

ARG BASE=python:3.12-alpine
FROM ${BASE} as build

LABEL maintainer="Antonio Dell'Elce"

WORKDIR /gpaw

# MATPLOTLIB:  needed by ase
ENV MATPLOTLIB  freetype-dev libpng-dev jpeg-dev
ENV AUTOTOOLS   autoconf automake perl
ENV COMPILERS   gcc g++ gfortran make
ENV COREDEV     libc-dev linux-headers make

ENV PACKAGES wget bash ${COMPILERS} ${MATPLOTLIB} ${AUTOTOOLS}

COPY requirements.txt Makefile ./

RUN  apk add --no-cache  $PACKAGES && pip wheel gpaw

# Second Stage
ARG BASE=python:3.12-alpine
FROM ${BASE} as build

RUN  apk add --no-cache libgfortran libstdc++

# Pre-load the gfortran shared library
ENV LD_PRELOAD /usr/lib/libgfortran.so.3

#ENV ENV   /root/.profile

WORKDIR /gpaw

COPY --from=build  /gpaw/*.whl .

RUN ls -lt && pip install *.whl
