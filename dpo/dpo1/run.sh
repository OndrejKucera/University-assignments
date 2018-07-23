#!/bin/bash
#
#   Script must be run from its directory
#
ruby -Ku -I`pwd`/src/ test/test.rb
ruby -Ku -I`pwd`/src/ bin/main.rb
