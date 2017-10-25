#!/bin/bash
#
# Description: copy all images from source code to images directory
# Authot: quanzhuo
# Date: Fri, Aug 04, 2017  7:29:37 PM

function usage() {
cat <<EOF
Usage: ./copy_images.sh [options] MODELS...

supported options:

+ -src <path>:  root directory of your source code, this option is mandatory
+ -dst <path>:  destination directory, this option is optional, 'images' by default.
+ -v|-V <ver>:  specify your build version code, 4 digit, eg: 1234
+ -h|--help:    show this message and exit

examples:

+ ./copy_images.sh -src /path/to/your/source -dst /path/to/images -v 1234 00WW
+ ./copy_images.sh -v 1234 -src /path/to/your/source 00WW

supported models:
EOF

    ls 00Setting/PL2
}

function color_echo() {
    case $1 in
        red)    echo -e "\e[1;31m$2\e[0m" ;;
        green)  echo -e "\e[1;32m$2\e[0m" ;;
        yellow) echo -e "\e[1;33m$2\e[0m" ;;
        *)      echo $1 ;;
    esac
}

SRC_ROOT=
IMG_ROOT=
VERSION=
MODELS=

# parse command line options
while [ $# -ne 0 ]
do
    PARAM=$1; shift
    case $PARAM in
        -h|--help) usage; exit 1 ;;
        -src)      SRC_ROOT=$1; shift ;;
        -dst)      IMG_ROOT=$1; shift ;;
        -v|-V)     VERSION=$1; shift ;;
        *)         MODELS=(${MODELS[@]} $PARAM) ;;
    esac
done

if [ -z $SRC_ROOT ]; then
    color_echo red "You must specify the source path"
    usage
    exit 1
fi

if ! echo $VERSION | grep -E '^[0-9]{4}$' >/dev/null ; then
    color_echo red "version must be 4 digits !"
    usage
    exit 1
fi

if [ -z ${MODELS} ]; then
    color_echo red "You must specify a model"
    usage
    exit 1
fi

if [ -z $IMG_ROOT ]; then
    IMG_ROOT=$(pwd)/images
fi

declare -A IMG_ARR
IMG_ARR[$IMG_ROOT/Modem/B2N/modem/B2N-0-$VERSION-NON-HLOS.bin]=$SRC_ROOT/SDM630.LA.2.0/common/out/B2N-0-$VERSION-NON-HLOS.bin
IMG_ARR[$IMG_ROOT/Modem/B2N/modem/B2N-1-$VERSION-NON-HLOS.bin]=$SRC_ROOT/SDM630.LA.2.0/common/out/B2N-0-$VERSION-NON-HLOS.bin
IMG_ARR[$IMG_ROOT/Modem/B2N/NV_default/B2N-0-$VERSION-NV-default.mbn]=$SRC_ROOT/MPSS.AT.2.3/modem_fih_common/modem_proc/fih_default_mbn_tool/NV-default.mbn
IMG_ARR[$IMG_ROOT/BSP/B2N/abl/B2N-0-$VERSION-abl.elf]=$SRC_ROOT/LINUX/out_img/B2N/B2N-0-$VERSION-abl.elf
IMG_ARR[$IMG_ROOT/BSP/B2N/abl/B2N-0-$VERSION-abl_service.zip]=$SRC_ROOT/LINUX/out_img/B2N/B2N-0-$VERSION-abl_service.zip
IMG_ARR[$IMG_ROOT/BSP/B2N/abl/B2N-0-$VERSION-abl_service.elf]=$SRC_ROOT/LINUX/out_img/B2N/B2N-0-$VERSION-abl_service.elf
IMG_ARR[$IMG_ROOT/BSP/B2N/adspso/B2N-0-$VERSION-dspso.bin]=$SRC_ROOT/SDM630.LA.2.0/common/out/B2N-0-$VERSION-dspso.bin
IMG_ARR[$IMG_ROOT/BSP/B2N/bluetooth/B2N-0-$VERSION-BTFM.bin]=$SRC_ROOT/SDM630.LA.2.0/common/out/B2N-0-$VERSION-BTFM.bin
IMG_ARR[$IMG_ROOT/BSP/B2N/cmnlib/B2N-0-$VERSION-cmnlib.mbn]=$SRC_ROOT/TZ.BF.4.0.7/trustzone_images/out/B2N-0-$VERSION-cmnlib.mbn
IMG_ARR[$IMG_ROOT/BSP/B2N/cmnlib64/B2N-0-$VERSION-cmnlib64.mbn]=$SRC_ROOT/TZ.BF.4.0.7/trustzone_images/out/B2N-0-$VERSION-cmnlib64.mbn
IMG_ARR[$IMG_ROOT/BSP/B2N/devcfg/B2N-0-$VERSION-devcfg.mbn]=$SRC_ROOT/TZ.BF.4.0.7/trustzone_images/out/B2N-0-$VERSION-devcfg.mbn
IMG_ARR[$IMG_ROOT/BSP/B2N/FIREHOSE_IMG/B2N-0-$VERSION-prog_emmc_ufs_firehose_Sdm660_ddr.elf]=$SRC_ROOT/BOOT.XF.1.4/boot_images/out/B2N-0-$VERSION-prog_emmc_ufs_firehose_Sdm660_ddr.elf
# IMG_ARR[$IMG_ROOT/BSP/B2N/ftmboot/B2N-0-$VERSION-ftm.img]=$SRC_ROOT/FTM/out/B2N-0-$VERSION-ftm.img
IMG_ARR[$IMG_ROOT/BSP/B2N/GPT_MAIN_IMG/B2N-0-$VERSION-gpt_backup0.bin]=$SRC_ROOT/SDM630.LA.2.0/common/out/B2N-0-$VERSION-gpt_backup0.bin
IMG_ARR[$IMG_ROOT/BSP/B2N/GPT_MAIN_IMG/B2N-0-$VERSION-gpt_main0.bin]=$SRC_ROOT/SDM630.LA.2.0/common/out/B2N-0-$VERSION-gpt_main0.bin
IMG_ARR[$IMG_ROOT/BSP/B2N/hwcfg/B2N-0-$VERSION-hwcfg.img]=$SRC_ROOT/CFG/out/B2N-0-$VERSION-hwcfg.img
IMG_ARR[$IMG_ROOT/BSP/B2N/hyp/B2N-0-$VERSION-hyp.mbn]=$SRC_ROOT/TZ.BF.4.0.7/trustzone_images/out/B2N-0-$VERSION-hyp.mbn
IMG_ARR[$IMG_ROOT/BSP/B2N/keymaster/B2N-0-$VERSION-keymaster.mbn]=$SRC_ROOT/TZ.BF.4.0.7/trustzone_images/out/B2N-0-$VERSION-keymaster.mbn
IMG_ARR[$IMG_ROOT/BSP/B2N/mdtpsecapp/B2N-0-$VERSION-mdtpsecapp.mbn]=$SRC_ROOT/TZ.BF.4.0.7/trustzone_images/out/B2N-0-$VERSION-mdtpsecapp.mbn
IMG_ARR[$IMG_ROOT/BSP/B2N/partition/B2N-0-$VERSION-gpt_both0.bin]=$SRC_ROOT/SDM630.LA.2.0/common/out/B2N-0-$VERSION-gpt_both0.bin
IMG_ARR[$IMG_ROOT/BSP/B2N/PATCH0_XML/B2N-0-$VERSION-patch0.xml]=$SRC_ROOT/SDM630.LA.2.0/common/out/B2N-0-$VERSION-patch0.xml
IMG_ARR[$IMG_ROOT/BSP/B2N/pmic/B2N-0-$VERSION-pmic.elf]=$SRC_ROOT/BOOT.XF.1.4/boot_images/out/B2N-0-$VERSION-pmic.elf
IMG_ARR[$IMG_ROOT/BSP/B2N/RAWPROGRMA0_XML/B2N-0-$VERSION-rawprogram0.xml]=$SRC_ROOT/SDM630.LA.2.0/common/out/B2N-0-$VERSION-rawprogram0.xml
IMG_ARR[$IMG_ROOT/BSP/B2N/rpm/B2N-0-$VERSION-rpm.mbn]=$SRC_ROOT/RPM.BF.1.8/rpm_proc/out/B2N-0-$VERSION-rpm.mbn
IMG_ARR[$IMG_ROOT/BSP/B2N/sec/B2N-0-$VERSION-sec.dat]=$SRC_ROOT/SDM630.LA.2.0/common/out/B2N-0-$VERSION-sec.dat
IMG_ARR[$IMG_ROOT/BSP/B2N/storsec/B2N-0-$VERSION-storsec.mbn]=$SRC_ROOT/TZ.BF.4.0.7/trustzone_images/out/B2N-0-$VERSION-storsec.mbn
IMG_ARR[$IMG_ROOT/BSP/B2N/tz/B2N-0-$VERSION-tz.mbn]=$SRC_ROOT/TZ.BF.4.0.7/trustzone_images/out/B2N-0-$VERSION-tz.mbn
IMG_ARR[$IMG_ROOT/BSP/B2N/xbl/B2N-0-$VERSION-xbl.elf]=$SRC_ROOT/BOOT.XF.1.4/boot_images/out/B2N-0-$VERSION-xbl.elf
IMG_ARR[$IMG_ROOT/BSP/B2N/xbl/B2N-0-$VERSION-xbl_service.elf]=$SRC_ROOT/BOOT.XF.1.4/boot_images/out/B2N-0-$VERSION-xbl_service.elf
IMG_ARR[$IMG_ROOT/BSP/B2N/xbl/B2N-0-$VERSION-xbl_service.zip]=$SRC_ROOT/BOOT.XF.1.4/boot_images/out/B2N-0-$VERSION-xbl_service.zip
IMG_ARR[$IMG_ROOT/System/B2N/build_toolkit/B2N-0-$VERSION-build_toolkit.tar.bz]=$SRC_ROOT/LINUX/out_img/B2N/B2N-0-$VERSION-build_toolkit.tar.bz
IMG_ARR[$IMG_ROOT/BSP/B2N/e2p/B2N-0-$VERSION-e2p.sh]=$SRC_ROOT/E2P/out/B2N-0-$VERSION-e2p.sh
IMG_ARR[$IMG_ROOT/BSP/B2N/e2p/B2N-0-$VERSION-e2p.tar]=$SRC_ROOT/E2P/out/B2N-0-$VERSION-e2p.tar

if ! [ -d /mnt/ImageShelf/SYNC_FROM_TPE ] ; then
    echo ' ' | /usr/bin/sudo -S mount -t cifs -o username=H2405134,password=paulYang\*8,iocharset=utf8,file_mode=0777,dir_mode=0777 //10.195.229.37/zzdc/ImageShelf /mnt/ImageShelf
fi

# ftm image
IMG_ARR[$IMG_ROOT/BSP/B2N/ftmboot/B2N-0-0090-ftm.img]=/mnt/ImageShelf/SYNC_FROM_TPE/Customer/Infocus/PL2/temp2/B2N-0-0090-ftm.img

for m in ${MODELS[@]}
do
    IMG_ARR[$IMG_ROOT/BSP/B2N/mdtp/B2N-0-$VERSION-$m-mdtp.img]=$SRC_ROOT/LINUX/out_img/B2N/B2N-0-$VERSION-$m-mdtp.img
    IMG_ARR[$IMG_ROOT/BSP/B2N/persist/B2N-0-$VERSION-$m-persist.img]=$SRC_ROOT/LINUX/out_img/B2N/B2N-0-$VERSION-$m-persist.img
    IMG_ARR[$IMG_ROOT/System/B2N/target_files/B2N-0-$VERSION-$m-A01-target_files.zip]=$SRC_ROOT/LINUX/out_img/B2N/B2N-0-$VERSION-$m-A01-target_files.zip
done

# debug
#for index in ${!IMG_ARR[*]}
#do
#    echo src: $index
#    echo dst: ${IMG_ARR[$index]}
#done

if ! [ -d $IMG_ROOT ]; then
    mkdir $IMG_ROOT
fi

for dst in ${!IMG_ARR[*]}
do
    if ! [ -f ${IMG_ARR[$dst]} ]; then
        color_echo red "file ${IMG_ARR[$dst]} does not exist !"
        exit 1
    fi

    DST_DIR=$(dirname $dst)
    if ! [ -d $DST_DIR ]; then
        mkdir -p $DST_DIR
    fi
    echo "copy file ${IMG_ARR[$dst]} to $dst"
    cp ${IMG_ARR[$dst]} $dst
done
