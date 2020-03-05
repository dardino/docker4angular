#!/bin/sh

if [ "${1}" == "build" ]; then
    docker build --rm -f "Dockerfile" -t docker4angular:test "."
fi

if [ "${1}" == "attach" ]; then
  docker run --name docker4angular_test -v /$PWD/volume:/app -it docker4angular:test
fi
