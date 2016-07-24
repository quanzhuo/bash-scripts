#!/bin/bash
#
# Desc: sync all my repositories with remote
#

function usage(){
    echo "Usage: ./sync-repos.bash [OPTION] [DIR]"
    echo "Sync all the repositories under dir with remote ."
    echo
    echo "  -h, --help    Show this help and exit ."
}

function is_git_repo() {
    if ls $1/.git &> /dev/null
    then
	return 0
    else
	return 1
    fi
}

DIR=$1
DEFAULT_DIR=/home/quuo/workspace/repos


case $1 in
    -h|--help)
	usage
	exit 0
	;;
    *)
	;;
esac

if test -z $DIR
then
    DIR=$DEFAULT_DIR
    echo "NO directory supplied, use $DIR "
elif ! test -d $DIR
then
    echo "$DIR is not a direcotry !"
    exit 1
fi

if ls $DIR/.git &> /dev/null
then
    cd $DIR
    git pull
    exit 0
fi

for path in $(ls $DIR)
do
    if is_git_repo path
    then
	cd $DIR/path
	git pull
	if test $? -eq 0
	then
	    echo "SYNC repo $path done."
	fi
    fi
done
	
