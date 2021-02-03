#!/bin/bash

# Copyright 2020 Rene Rivera, Sam Darwin
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE.txt or copy at http://boost.org/LICENSE_1_0.txt)

set -e
export TRAVIS_BUILD_DIR=$(pwd)
export DRONE_BUILD_DIR=$(pwd)
export TRAVIS_BRANCH=$DRONE_BRANCH
export VCS_COMMIT_ID=$DRONE_COMMIT
export GIT_COMMIT=$DRONE_COMMIT
export REPO_NAME=$DRONE_REPO
export USER=$(whoami)
export CC=${CC:-gcc}
export PATH=~/.local/bin:/usr/local/bin:$PATH

if [ "$DRONE_JOB_BUILDTYPE" == "boost" ]; then

echo '==================================> INSTALL'

if [ -n $enable_coverage ]; then pip install --user cpp-coveralls; fi

echo '==================================> BEFORE_SCRIPT'

. $DRONE_BUILD_DIR/.drone/before-script.sh

echo '==================================> SCRIPT'

cd ${TRAVIS_BUILD_DIR}/test
${HOME}/opt/bin/b2 -j 3 cxxstd=$CXXSTD -q include=${BOOST_ROOT} include=${TRAVIS_BUILD_DIR}/include
xmllint --noout ${TRAVIS_BUILD_DIR}/doc/ref.xml

echo '==================================> AFTER_SUCCESS'

if [ -n $enable_coverage ]; then coveralls -r ${TRAVIS_BUILD_DIR} -b ${TRAVIS_BUILD_DIR}/test --gcov-options '\-lp' --include include/boost/unordered/ ; fi

fi
