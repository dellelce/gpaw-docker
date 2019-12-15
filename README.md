# gpaw-docker

This repo provides docker containers with [GPAW](https://wiki.fysik.dtu.dk/gpaw/) (A Density Functional Theory software based on the [Projector Augmented Wave](https://en.wikipedia.org/wiki/Projector_augmented_wave_method) method and a real space grid).

## Components

It uses the following:

* Alpine Linux
* Latest  [Apache httpd](http://httpd.apache.org) available (install path: /app/httpd)
* or [uWSGI](https://uwsgi-docs.readthedocs.io/en/latest/) (image dellelce/gpaw-uwsgi)
* Latest Python 3.7 available (install path: /app/httpd)
* Latest [GPAW](https://wiki.fysik.dtu.dk/gpaw/) (install path: /app/gpaw)

## Volumes

### Datasets

* Approximation of core (non-valence) electrons (see [Specification](https://wiki.fysik.dtu.dk/gpaw/setups/pawxml.html#what-defines-a-dataset)).
* Default path: /app/gpaw/datasets

### Executions

* Contains result of GPAW executions
* Default path: /app/gpaw/executions

## Usage


So you can either use the images to run gpaw directy or use the images to develop python code to call GPAW (which is a python package).
