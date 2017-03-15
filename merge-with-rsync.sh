#!/bin/sh

# use at to execute this file in midnight
# the exact command is: at -f /path/to/sync-and-merge.sh 23:55

# unset proxy in case of proxy server error
unset http_proxy
unset https_proxy

LOGDIR=/home/quan/Documents/synccode
LOGFILE=/home/quan/Documents/synccode/log-$(date "+%Y-%m-%d")

rm -rf $LOGFILE

if ! [ -d $LOGFILE ];then
    mkdir -p $LOGDIR
fi

# 1. sync the code
D1C=/home/quan/workspace/repos/d1c
PLE=/home/quan/workspace/repos/ple

cd $D1C

while true
do
    date | tr '\n' ' ' >> $LOGFILE
    echo "--> start to sync code from tb" >> $LOGFILE
    tbrepo sync -c
    if [ $? -eq 0 ];then
	date | tr '\n' ' ' >> $LOGFILE
	echo "--> sync successfully" >> $LOGFILE
	break
    else
	date | tr '\n' ' ' >> $LOGFILE
	echo "--> sync failed" >> $LOGFILE
    fi
done

# 2. get ple code
if [ -d $PLE ];then
    date | tr '\n' ' ' >> $LOGFILE
    echo "--> remove old directory $PLE" >> $LOGFILE
    rm -rf $PLE
fi

if [ -f $PLE ];then
    rm -rf $PLE
fi

mkdir $PLE

cd $PLE

zzrepo init -u ssh://H2404689@10.195.229.38:29418/QC/manifest.git \
       -b dev/MSM89xx -m 2012000_BUILD.xml

while true
do
    date | tr '\n' ' ' >> $LOGFILE
    echo "--> sync code from zz" >> $LOGFILE
    zzrepo sync -c
    if [ $? -eq 0 ];then
	date | tr '\n' ' ' >> $LOGFILE
        echo "--> sync from zz successfully" >> $LOGFILE
	break
    else
	date | tr '\n' ' ' >> $LOGFILE
	echo "--> sync from zz failed" >> $LOGFILE
    fi
done

# 3. merge code
date | tr '\n' ' ' >> $LOGFILE
echo "--> start merge use rsync" >> $LOGFILE
rsync -av --exclude=.repo/ --exclude=.git/ --exclude=prevHEAD \
      --exclude=.gitignore --exclude=MSM8940/ --exclude=MPSS.TA.2.3/ \
      -c -i --no-times --no-perms --delete $D1C/ $PLE/ \
      >$LOGDIR/rsync-$(date "+%Y-%m-%d") \
      2>$LOGDIR/rsync-error-$(date "+%Y-%m-%d")

# we can use the following commands to speed up
# rsync -av --exclude=.git/ --exclude=prevHEAD --exclude=.gitignore -c -i --no-times --no-perms  --delete d1c/LINUX/android/external/ ple/LINUX/android/external/
# rsync -av --exclude=.git/ --exclude=prevHEAD --exclude=.gitignore -c -i --no-times --no-perms  --delete d1c/LINUX/android/system/ ple/LINUX/android/system/
# rsync -av --exclude=.git/ --exclude=prevHEAD --exclude=.gitignore -c -i --no-times --no-perms  --delete d1c/LINUX/android/packages/ ple/LINUX/android/packages/
# rsync -av --exclude=.git/ --exclude=prevHEAD --exclude=.gitignore -c -i --no-times --no-perms  --delete d1c/LINUX/android/vendor/ ple/LINUX/android/vendor/
# rsync -av --exclude=.git/ --exclude=prevHEAD --exclude=.gitignore --exclude=external/ --exclude=system/ --exclude=packages/ --exclude=vendor/ -c -i --no-times --no-perms --delete d1c/LINUX/ ple/LINUX/
# rsync -av --exclude=.repo/ --exclude=.git/ --exclude=prevHEAD --exclude=.gitignore --exclude=LINUX/ --exclude=MPSS.TA.2.3/ --exclude=MSM8940/ -c -i --no-times --no-perms --delete d1c/ ple/

if [ $? -eq 0 ];then
    date | tr '\n' ' ' >> $LOGFILE
    echo "--> merge successfully" >> $LOGFILE
else
    date | tr '\n' ' ' >> $LOGFILE
    echo "--> merge failed" >> $LOGFILE
fi

