#!/bin/sh

# use at to execute this file in midnight
# the exact command is: at -f /path/to/sync-and-merge.sh 23:55

# unset proxy in case of proxy server error
unset http_proxy
unset https_proxy

LOGDIR=/home/quan/Documents/synccode
LOGFILE=/home/quan/Documents/synccode/log-$(date "+%Y-%m-%d")
if ! [ -d $LOGFILE ];then
    mkdir -p $LOGDIR
fi

if ! [ -f $LOGFILE ]; then
    touch $LOGFILE
fi


# 1. sync the code
cd /home/quan/workspace/repos/d1c

while true
do
    date | tr '\n' ' ' > $LOGFILE
    echo "--> start to sync code from tb" >> $LOGFILE
    tbrepo sync
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
if [ -d /home/quan/workspace/repos/ple ];then
    date | tr '\n' ' ' >> $LOGFILE
    echo "--> remove old directory /home/quan/workspace/repos/ple" >> $LOGFILE
    rm -rf /home/quan/workspace/repos/ple
fi

if [ -f /home/quan/workspace/repos/ple ];then
    rm -rf /home/quan/workspace/repos/ple
fi

mkdir /home/quan/workspace/repos/ple

cd /home/quan/workspace/repos/ple

zzrepo init -u ssh://H2404689@10.195.229.38:29418/QC/manifest.git \
       -b dev/MSM89xx -m 2012000_BUILD.xml

while true
do
    date | tr '\n' ' ' >> $LOGFILE
    echo "--> sync code from zz" >> $LOGFILE
    zzrepo sync
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
cd /home/quan/workspace/repos
date | tr '\n' ' ' >> $LOGFILE
echo "--> start merge use rsync" >> $LOGFILE
rsync -av --exclude=.repo/ --exclude=.git/ --exclude=prevHEAD \
      --exclude=.gitignore --exclude=MSM8940/ --exclude=MPSS.TA.2.3/ \
      -c -i --no-times --no-perms --delete d1c/ ple/ \
      > $LOGDIR/rsync-$(date "+%Y-%m-%d") \
      2 > $LOGDIR/rsync-error-$(date "+%Y-%m-%d")

if [ $? -eq 0 ];then
    date | tr '\n' ' ' >> $LOGFILE
    echo "--> merge successfully" >> $LOGFILE
else
    date | tr '\n' ' ' >> $LOGFILE
    echo "--> merge failed" >> $LOGFILE
fi
