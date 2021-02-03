# Use, modification, and distribution are
# subject to the Boost Software License, Version 1.0. (See accompanying
# file LICENSE.txt)
#
# Copyright Rene Rivera 2020.

# For Drone CI we use the Starlark scripting language to reduce duplication.
# As the yaml syntax for Drone CI is rather limited.
#
#
globalenv={}
linuxglobalimage="cppalliance/droneubuntu1404:1"
windowsglobalimage="cppalliance/dronevs2019"

def main(ctx):
  return [
  linux_cxx("label=gcc C++03/11; user_config=using gcc  Job 0", "g++", packages="libxml2-utils g++-multilib", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'label': 'gcc C++03/11', 'user_config': 'using gcc : : g++-4.8 --coverage -fsanitize=address ;', 'enable_coverage': '1', 'CXXSTD': '03,11', 'DRONE_JOB_UUID': 'b6589fc6ab'}, globalenv=globalenv),
  linux_cxx("label=gcc 32 bit C++11; user_config=using  Job 1", "g++", packages="libxml2-utils g++-multilib", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'label': 'gcc 32 bit C++11', 'user_config': 'using gcc : : g++-4.8 -m32 -fsanitize=address ;', 'CXXSTD': '11', 'DRONE_JOB_UUID': '356a192b79'}, globalenv=globalenv),
  linux_cxx("label=clang C++11/17; user_config=using cl Job 2", "clang++", packages="libxml2-utils g++-multilib", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'label': 'clang C++11/17', 'user_config': 'using clang : : clang++ -fsanitize=address ;', 'CXXSTD': '11,17', 'DRONE_JOB_UUID': 'da4b9237ba'}, globalenv=globalenv),
  linux_cxx("label=clang 32 bit; user_config=using clan Job 3", "clang++", packages="libxml2-utils g++-multilib", buildtype="boost", buildscript="drone", image=linuxglobalimage, environment={'label': 'clang 32 bit', 'user_config': 'using clang : : clang++ -m32 ;', 'CXXSTD': '03', 'DRONE_JOB_UUID': '77de68daec'}, globalenv=globalenv),
    ]

# from https://github.com/boostorg/boost-ci
load("@boost_ci//ci/drone/:functions.star", "linux_cxx","windows_cxx","osx_cxx","freebsd_cxx")
