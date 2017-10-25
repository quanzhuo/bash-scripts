#!/bin/bash

PROJ=PL2
VERSION=
MAJOR=
MINOR=
MODELS=
SRC_PATH=
IMG_PATH=
PACK_ROOT=$(pwd)
IMG_SHELF=$PACK_ROOT/../ImageShelf/${PROJ}_DailyRelease
ALL_MODELS=$(ls 00Setting/$PROJ)

MAJOR=${VERSION:1:1}
MINOR=${VERSION:3:3}

function usage() {
cat <<EOF
Usage: start.sh [options]... MODEL

This is the entry point for packing tool and it's a wrapper for file CollectionFile.sh.
All the options and params must be appear before the models on cmdline. And this
script must be executed as root. For example:

  sudo ./start.sh -v 1234 -img /path/to/your/images 00WW
    or
  sudo ./start.sh -v 1234 -src /path/to/your/src 00WW

**options**
-img <path>:      root path to your images, if you have not copy all the images
                  to a directory, you can specify your source code path, see
                  blew for more information.
-src <path>:      root path of your source code. with this option, the script
                  will copy all the required images(AP, BP) to images directory. If
                  you have copyed all the images to another place. Please use -img
                  option. These two options can not be used together.
-v|-V <version>:  version code, must be 4 digits, eg: 1234.
-o <image-shelf>: path to your image shelf.
-h|--help:        show this message and exit.

**Examples**
+ sudo ./start.sh --help
+ sudo ./start.sh -img /path/to/your/images -v 0001 00WW
+ sudo ./start.sh -v 0001 -src /path/to/your/source 00WW 

**MODELS**
current supported models are:
EOF

    ls 00Setting/$PROJ
}

function color_echo() {
    case $1 in
        red)    echo -e "\e[1;31m$2\e[0m" ;;
        green)  echo -e "\e[1;32m$2\e[0m" ;;
        yellow) echo -e "\e[1;33m$2\e[0m" ;;
        *)      echo $1 ;;
    esac
}

function gen_mlf () {
    MODEL=$1	
	if ! [ -d "$PACK_ROOT/SwPackInfo/$PROJ" ];then
        mkdir -p $PACK_ROOT/SwPackInfo/$PROJ
    fi
	
	# mlf file
    cp -f $PACK_ROOT/mlf_file/$PROJ/${MODEL}.mlf \
	    $PACK_ROOT/SwPackInfo/${PROJ}/$PROJ-$MAJOR$MINOR-0-${MODEL}-A01.mlf

    sed -i "s/SW-VER/$MAJOR$MINOR/"  \
	    $PACK_ROOT/SwPackInfo/$PROJ/$PROJ-$MAJOR$MINOR-0-${MODEL}-A01.mlf
    sed -i "s/MODELV/${MODEL}/" \
	    $PACK_ROOT/SwPackInfo/$PROJ/$PROJ-$MAJOR$MINOR-0-${MODEL}-A01.mlf

    # Packing table
    cp -f $PACK_ROOT/00Setting/${PROJ}/${MODEL}/${PROJ}_${MODEL}.txt  \
	    $PACK_ROOT/SwPackInfo/${PROJ}/${PROJ}_${MODEL}.txt
    sed -i "s/AUTOPACK-VER/$MAJOR$MINOR/"  \
	    $PACK_ROOT/SwPackInfo/${PROJ}/${PROJ}_${MODEL}.txt

    # Copy rm list, collection and project settings
	cp -f $PACK_ROOT/00Setting/${PROJ}/${MODEL}/${PROJ}_${MODEL}_rmlist.txt  \
	    $PACK_ROOT/SwPackInfo/${PROJ}/${PROJ}_${MODEL}_rmlist.txt
    cp -f $PACK_ROOT/00Setting/${PROJ}/${MODEL}/collection.conf  \
	    $PACK_ROOT/SwPackInfo/${PROJ}/collection.conf
    cp -f $PACK_ROOT/00Setting/${PROJ}/${MODEL}/proj_settings.txt  \
	    $PACK_ROOT/SwPackInfo/${PROJ}/proj_settings.txt
	
	# sku_info
    if [ -f "$PACK_ROOT/00Setting/$PROJ/$MODEL/${MODEL}_sku_info.txt" ];then
        cp -f $PACK_ROOT/00Setting/$PROJ/$MODEL/${MODEL}_sku_info.txt \
          $PACK_ROOT/SwPackInfo/$PROJ/${MODEL}_sku_info.txt
    fi
}

function auto_packO () { 
    test -d /mnt/ImageShelf/SYNC_FROM_TPE || echo ' ' | sudo -S mount -t cifs -o \
      username=H2405134,password=paulYang\*8,iocharset=utf8,file_mode=0777,dir_mode=0777 \
      //10.195.229.37/zzdc/ImageShelf /mnt/ImageShelf
    ./CollectionFile.sh $PROJ --ENABLE_REL_TOOL=true --SUPPORTS_ENG_OTA=true --CHECKSUM_OPTION=md4 --send-package-info=true
}

function copyImage() {
    MODEL=00WW
    if ! [ -d $IMG_SHELF/V$MAJOR.$MINOR ];then
	    mkdir -p $IMG_SHELF/V$MAJOR.$MINOR
    fi
	cp -r RELEASETOOL_OUT/$PROJ/$MODEL $IMG_SHELF/V$MAJOR.$MINOR
}

# process command line params
while [ $# -ne 0 ]
do
    PARAM=$1
    shift
    case $PARAM in
        -h|--help) usage; exit ;;
        -img)      IMG_PATH=$1; shift ;;
        -src)      SRC_PATH=$1; shift ;;
        -v|-V)     VERSION=$1; shift ;;
        -o)        IMG_SHELF=$1; shift ;;
        *)         MODELS=(${MODELS[@]} $PARAM) ;;
    esac
done

# must be run by root
if [ $UID -ne 0 ]; then
    color_echo red "This script must be executed as root !!!"
    exit
fi

# verify version code
if ! echo $VERSION | grep -E "^[0-9]{4}$" >/dev/null ; then
    color_echo red "bad version code, version code must be 4 digits"
    usage
    exit
else
    MAJOR=${VERSION:0:1}
    MINOR=${VERSION:1:3}
fi

# verify models
for var in ${MODELS[@]}
do
    if ! echo $ALL_MODELS | grep $var >/dev/null ; then
        color_echo red "$var is not a valid model name"
        usage
        exit
    fi
done

# verify whether the image path is valid
if [ -n "$IMG_PATH" -a -z "$SRC_PATH" ]; then
    if ! [ -d $IMG_PATH/BSP -a -d $IMG_PATH/Modem -a -d $IMG_PATH/System ]; then
        color_echo red "Bad image path, Please specify image path with -img option or in config file"
        usage
        exit
    else
        # configure image path
        CONFIG_FILE=${PROJ,,}_env.ini
        sed -i "s@BSP_FILE_FOLDER.*@BSP_FILE_FOLDER=\"$IMG_PATH\"@" \
          $PACK_ROOT/config/Oreo/$CONFIG_FILE
        sed -i "s@MODEM_FILE_FOLDER.*@MODEM_FILE_FOLDER=\"$IMG_PATH\"@" \
          $PACK_ROOT/config/Oreo/$CONFIG_FILE
        sed -i "s@SYSTEM_FILE_FOLDER.*@SYSTEM_FILE_FOLDER=\"$IMG_PATH\"@" \
          $PACK_ROOT/config/Oreo/$CONFIG_FILE
    fi
elif [ -n "$SRC_PATH" -a -z "$IMG_PATH" ]; then
    ./copy_images.sh -src $SRC_PATH -v $VERSION ${MODELS[@]}
    EXIT_CODE=$?
    if [ $EXIT_CODE -eq 1 ] ; then
        exit
    fi
    CONFIG_FILE=${PROJ,,}_env.ini
    IMG_PATH=$PACK_ROOT/images
    sed -i "s@BSP_FILE_FOLDER.*@BSP_FILE_FOLDER=\"$IMG_PATH\"@" \
          $PACK_ROOT/config/Oreo/$CONFIG_FILE
    sed -i "s@MODEM_FILE_FOLDER.*@MODEM_FILE_FOLDER=\"$IMG_PATH\"@" \
          $PACK_ROOT/config/Oreo/$CONFIG_FILE
    sed -i "s@SYSTEM_FILE_FOLDER.*@SYSTEM_FILE_FOLDER=\"$IMG_PATH\"@" \
          $PACK_ROOT/config/Oreo/$CONFIG_FILE
elif [ -n "$SRC_PATH" -a -n "$IMG_PATH" ]; then
    echo "can not use -img and -src together"
    exit
fi

gen_mlf 00WW
auto_packO
copyImage
