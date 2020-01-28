# Build CI for EFI-related tools

This repo contains the tools to build images to run CI for the Red Hat
bootloader team's EFI tools.

This build includes all of the dependencies of the build as well as the
testing infrastructure, to minimize the time spent per Travis build.

Each repo has a .travis.yml will install this docker image, fetch and
build any prerequisites, and build that repo using whatever branch travis
specifies.

The workflow for updating the Travis docker image is:

    make DISTRO=f32

    cd ../project
    git checkout -b travis
    vim .travis.yml # to point to your repository and tag
    git commit -a -m "Test out my new Travis Docker image"
    git push username travis-ci-test

I'll script that better at some point, probably.
