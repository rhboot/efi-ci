# Build CI for EFI-related tools

This repo contains the tools to build images to run CI for the Red Hat
bootloader team's EFI tools.

It's literally just a container definition per branch, and the branches get
built automatically.  To create a new build, do the following:
- create the branch with a Containerfile
- add it [here](https://hub.docker.com/repository/docker/vathpela/efi-ci/builds/edit)
- set the github and docker branches to the same branch name

The image should include all of the dependencies of the build as well as the
testing infrastructure, to minimize the time spent per CI build.
