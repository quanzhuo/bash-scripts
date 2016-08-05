#!/bin/bash
#
# Desc: change your default java package in a debian based distribution. 
#

function usage()
{
    echo "Usage: "
    echo "./alter_java dir:  make cmds under dir/bin as default"
    echo "./alter_java -h | --help:"
    echo "                   show this message and exit"
}

function should_add_to_path()
{
    temp=$1
    
    if ! test -x $1
    then
	return 1
    fi
    if test -h $1
    then
	return 1
    fi
    
    return 0
}

function alter_java()
{
    bins_path=$1/bin

    for exe in $(ls $bins_path)
    do
	if should_add_to_path $bins_path/$exe
	then
	    update-alternatives --install /usr/bin/$exe \
				$exe $bins_path/$exe 100
	    if test $? -eq 0
	    then
		update-alternatives --set $exe $bins_path/$exe
		if test $? -eq 0
		then
		    echo "make $bins_path/$exe as the default $exe cmds successfully !"
		fi
	    else
		echo "make $bins_path/$exe as the default $exe cmds failed !"
	    fi
	fi
    done	   
}

if test $UID -ne 0
then
    echo "must run as root"
    exit 1
fi

if test $# -ne 1
then
    usage
    exit 1
else
    case $1 in
	-h|--help)
	    usage
	    exit 0
	    ;;
	*)
	    BASENAME=$(basename $1)
	    DIRNAME=$(dirname $1)
	    PATHNAME=$DIRNAME/$BASENAME
	    if test -d $PATHNAME/bin
	    then
		alter_java $PATHNAME
	    else
		usage
		exit 1
	    fi
	    ;;
    esac
fi
