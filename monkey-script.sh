# This file is a template for android phone
# monkey test

let i=0;
while [ $i -lt 5000 ]; do

    # 'input tap' command is used simulate
    # touch screen
    input tap 275 700
    input tap 280 280
    input tap 400 400
    input tap 300 1170
    input tap 250 1200
    input tap 360 1200

    # press back key
    input keyevent 4
    input tap 210 1180
    input keyevent 4
    input tap 500 1180
    input keyevent 4
    input keyevent 4
    input keyevent 4
    let i++
    echo $i > /sdcard/count
done
