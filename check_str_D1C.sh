#!/bin/bash

function sh_check () {
    awk '
        $0 ~ /[:space:]*#/ {  next }

        {  if (match($0, /[dD]1[cC]/) != 0) {
             print FILENAME, FNR, $0
           }
        }
    ' $1
}

function c_check () {
    awk '
         $0 ~ /[:space:]*\/{2}/ { next }

         {
             if (match($0, /[dD]1[cC]/) != 0) {
               print FILENAME, FNR,$0
             }
         }
    ' $1
}

function check_type () {
    case $1 in
        *.mk | *.sh | *.bash | *.py | *Makefile)
            sh_check $1 ;;
        *.java | *.h | *.c | *.cc | *.cpp | *.java)
            c_check $1 ;;
	*.pyc | *.o | *.lib | *.jar | *.zip | *.html | *.js | *.md | *.txt)
	    return ;;
	*.png)
	    return ;;
        *)
            echo "unknow file type: $1" >> ~/unknow ;;
    esac
}

function for_each() {
    for var in $(ls $1)
    do
        if test -d $1/$var
        then
	    if test -d out/target/product
	    then
		continue
	    fi
            for_each $1/$var
        else
            check_type $1/$var
        fi
    done
}

for_each $1
