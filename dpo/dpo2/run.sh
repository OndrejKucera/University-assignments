#!/bin/bash
#
#   Script must be run from its directory
#

if [ -z $1 ] ; then echo "Usage ./run.sh [test|dfs|bfs]"; exit
elif [ $1 = "dfs"  ] ; then ruby bin/start.rb dfs
elif [ $1 = "bfs"  ] ; then ruby bin/start.rb bfs
elif [ $1 = "test" ] ; then ruby test/test.rb
else echo "Error: wrong parameter"
fi

