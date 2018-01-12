#!/bin/bash

let fail=0
let pass=0
result=result.txt
rm -rf $result

while :
do
    adb reboot bootloader
    fastboot erase userdata
    fastboot flash persist B2N-0-127C-00CN-persist.img
    fastboot reboot
    
    echo "sleep 60s"
    sleep 60
    while :
    do
        for drive in E F G H I J K L M N O P Q R S T U V W X Y Z A B
        do
            ScsiCommandLine.exe $drive SC_ENABLE_ALL_PORT
        done
        if adb devices | grep "PL2"; then
            echo "device connected"
            break
        else
            echo "no device, sleep 3 seconds"
            sleep 3
        fi
    done
    echo "dump info"
    if adb shell dumpsys sensorservice | grep "BMI160 Accelerometer" >/dev/null; then
        let pass++
    else
        let fail++
    fi
    echo "`date`: pass: $pass, fail: $fail" >> $result
done
