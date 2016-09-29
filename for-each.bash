#!/bin/bash

function do_something() {
    echo "$1"
}

function for_each() {
#    echo "$PWD"
    for var in $(ls $1)
    do
	if test -d $1/$var
	then
	    echo "$var is a directory"
	    for_each $1/$var
	else
    	    do_something $1/$var
	fi
    done
}

for_each $1
