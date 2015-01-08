#!/bin/bash

# use 'source build_runtime.sh' from this project's root to update the runtime.

# export SG_RUNTIME_PATH to point to your smartgraphs runtime project
# a good place for this export might be in your rvmrc file. eg:
# export SG_RUNTIME_PATH=/Users/npaessel/lab/cc/Smartgraphs

# TODO: It would be great to automatically update the SC.buildNumber
# in smartgraphs-runtime.html  (possibly using sed?)

build_in_path=${SG_RUNTIME_PATH}/tmp/build/static
here=`pwd`
copy_to_path=${here}/public/

cd $SG_RUNTIME_PATH
if [ -e $build_in_path ]; then
  rm -r $build_in_path;
fi

./bin/sc-build smartgraphs -r
cp -r $build_in_path $copy_to_path
cd $here
