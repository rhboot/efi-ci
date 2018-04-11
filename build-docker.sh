#!/bin/bash

USER=vathpela
DISTRO=rawhide
TAG=v0
IMAGE=$USER/efi-ci-$DISTRO:$TAG

# Generate a new image. We use versioned tags so that you can
# do updates in lockstep the image and dbxtool's .travis.yml.
sudo docker build -f Dockerfile-$DISTRO -t $IMAGE .

# Upload it to your dockerhub.
sudo docker push $IMAGE
