# dbxtool-travis

Docker image data for the dbxtool's Travis CI.

This build includes all of the dependencies of the dbxtool build as
well as the testing infrastructure, to minimize the time spent per
Travis build of dbxtool.

dbxtool's .travis.yml will generate its own Dockerfile that will
pull from one of the images generated using this repository, and
request that the current code that Travis is testing be added to the
image as well.

The workflow for updating the Travis docker image is:

    vim build-docker.sh
    ./build-docker.sh

    cd ../project
    git checkout -b travis
    vim .travis.yml # to point to your repository and tag
    git commit -a -m "Test out my new Travis Docker image"
    git push username travis-ci-test

I'll script that better at some point, probably.
