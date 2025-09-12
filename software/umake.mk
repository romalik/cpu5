export FILESYSTEM_DIR="$(pwd)/../build/fs"


export APP_BIN_DIR=$FILESYSTEM_DIR
export ROM_DIR="$(pwd)/../build/bin/fw/"

export FS_IMAGE="$(pwd)/../build/fs.img"

mkdir -p $FILESYSTEM_DIR
mkdir -p $ROM_DIR


cp -r fs_static/* $FILESYSTEM_DIR


include_subdir "apps/src"
include_subdir "kernel"

cpu5mkfs $FILESYSTEM_DIR $FS_IMAGE


