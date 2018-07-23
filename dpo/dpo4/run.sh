#!/bin/bash
#
#   Script must be run from its directory
#

if [ -z $1 ] ; then ruby bin/main.rb ;
elif [ $1 = "test" ] ; then ruby test/test.rb
else echo "Error: wrong parameter"
fi

