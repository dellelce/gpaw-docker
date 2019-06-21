#!/bin/bash
#
# File:         docker-push.sh
# Created:      100818
# Description:
#

### FUNCTIONS ###

 docker_hub()
 {
  [ -z "$DOCKER_PASSWORD" -o -z "$DOCKER_USERNAME" ] && { echo "docker_hub: Docker environment not set-up correctly"; return 1; }
  echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
  rc=$?
  [ $rc -ne 0 ] && { echo "docker_hub: Docker hub login failed with rc = $rc"; return $rc; }

  return 0
 }

### ENV ###

 image="$1"

### MAIN ###

 docker_hub || exit $?

 # we expect an image without a version at this point
 py_version=$(docker run -it --rm "$image" python -V | awk ' { print $2 } ')
 gpaw_version=$(docker run -it --rm "$image" gpaw --version | awk -F- ' {print $2 } '(

 # build image list
 images="$image $image-${gpaw_version} $image-${gpaw_version}-py${py_version}"

 docker tag "$image" "$image-${gpaw_version}"
 docker tag "$image" "$image-${gpaw_version}-py${py_version}"

 for image in $images
 do
   docker push "$image" || exit $?
 done

### EOF ###
