declare -i i

for((i=1;i<100;i++))
do
    # reboot to bootloader
    while true
    do
	adb reboot bootloader
	if test $?
	then
	    echo "reboot to bootloader"
	    sleep 3
	    break
	else
	    echo "no device found, wait a while"
	    sleep 3
	fi
    done

    # reboot
    while true
    do
	fastboot reboot
	if test $?
	then
	    echo "reboot"
	    sleep 60
	    break
	else
	    echo "fastboot failed"
	    sleep 5
	fi
    done
    echo "succed: $i" > $DESK/count
done
