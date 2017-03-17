#!/bin/bash

function parse() {

    if ! ls $1 &> /dev/null
    then
       return
    fi

    for var in `ls -d $1`
    do
	echo $var | grep -E "@[0-9]{10}" -o | xargs date -d | tr '\n' ' '

	if [ -f $var ]
	then
	    t=
	else
	    t=/
	fi
	echo "-->> $var$t"
    done
    echo
}

parse 'FRAMEWORK_REBOOT@*'
parse 'SYSTEM_RESTART@*'
parse 'SYSTEM_BOOT@*'
parse 'system_server_watchdog@*'
parse 'system_server_crash@*'
parse 'system_app_crash@*'
parse 'system_app_native_crash@*'
parse 'data_app_native_crash@*'
parse 'data_app_crash@*'
parse 'system_app_anr@*'
parse 'data_app_anr@*'
parse 'SYSTEM_TOMBSTONE@*'
parse 'SYSTEM_LAST_KMSG@*'
parse 'SYSTEM_RECOVERY_KMSG@*'
parse 'SYSTEM_AUDIT@*'
parse 'system_server_wtf@*'
parse 'system_app_wtf@*'
