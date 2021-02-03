#!/bin/bash

# Copyright 2020 Rene Rivera, Sam Darwin
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE.txt or copy at http://boost.org/LICENSE_1_0.txt)

if [ "$DRONE_JOB_UUID" = "b6589fc6ab" ] || [ "$DRONE_JOB_UUID" = "356a192b79" ] || [ "$DRONE_JOB_UUID" = "da4b9237ba" ] || [ "$DRONE_JOB_UUID" = "77de68daec" ] ; then
    export BOOST_VERSION=1.67.0
    export BOOST_FILENAME=boost_1_67_0
    export BOOST_ROOT=${HOME}/boost
    cd ${TRAVIS_BUILD_DIR}
    touch Jamroot.jam
    cd $HOME
    echo $user_config > ~/user-config.jam
    cat ~/user-config.jam
    # Pick snapshot to use
    if [ "$TRAVIS_EVENT_TYPE" == "cron" ]
    then
        if [ "$TRAVIS_BRANCH" == "master" ]
        then
            snapshot=master
        else
            snapshot=develop
        fi
    else
        #snapshot=stable
        snapshot=master
    fi

    # Download and extract snapshot
    echo "Downloading ${download_url}"
    mkdir $HOME/download
    cd $HOME/download
    python ${TRAVIS_BUILD_DIR}/ci/download-boost-snapshot.py $snapshot
    mv * ${BOOST_ROOT}

    rm -r ${BOOST_ROOT}/boost/unordered
    cd ${BOOST_ROOT}/tools/build
    mkdir ${HOME}/opt
    bash bootstrap.sh
    ./b2 install --prefix=$HOME/opt
fi

