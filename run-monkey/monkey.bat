@echo on

echo "Creat MKY_LOG:"

set LogFolder=/data/sdcard/MKY_LOG

adb shell mkdir -p %LogFolder%
adb shell chmod 777 %LogFolder%
adb shell setprop persist.sys.strictmode.visual true

echo "push blacklist to %LogFolder%"
adb push blacklist.txt %LogFolder%/blacklist.txt
adb shell chmod 777 %LogFolder%/blacklist.txt
pause

adb shell "monkey --pkg-blacklist-file %LogFolder%/blacklist.txt --ignore-crashes --ignore-timeouts --ignore-security-exceptions --pct-trackball 0 --throttle 1000 -v -s 750 --bugreport 300000> %LogFolder%/mky_event.txt 2>%LogFolder%/mky_error.txt"

pause

