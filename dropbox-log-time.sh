#!/bin/bash

for var in system_app_crash@*
do
    echo $var;
    echo @$var | grep -E "@[0-9]{10}" -o | xargs date -d
done
