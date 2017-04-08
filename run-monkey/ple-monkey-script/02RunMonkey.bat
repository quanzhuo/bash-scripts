@echo off

call:startMonkeyTesting

@pause
@pause
@pause
goto:eof


:prepareMonkeyEnv
	call:syncHostTime
	
	echo Close SetupWizard
	adb shell "settings put secure user_setup_complete 1"
	adb shell "settings put global device_provisioned 1"
	
	echo Set BlackList
    ::adb install AutoBlackList.apk
    ::timeout /t 5
    ::adb push BlacklistConfig.xml /sdcard/
    ::adb shell am start -n com.example.autoblacklist/.MainActivity
		adb push BlackList.txt /data/local/tmp/BlackList.txt
goto:eof



:startMonkeyTesting
	echo Start to Unlock Provision
	adb shell rm /data/local/tmp/presetPermission
	adb push presetPermission /data/local/tmp/
	adb shell rm /data/local/tmp/presetPermission.jar
	adb push presetPermission.jar /data/local/tmp/
	adb shell sh /data/local/tmp/presetPermission -v -v --pct-permission 100 -s 1 1

	echo Clean Records
	adb shell "mkdir /data/local/tmp/MKY_LOG"
	adb shell "rm -r /data/local/tmp/MKY_LOG/*"
	
	echo Start Monkey Testing
	set Thisday=%DATE:/=%
  adb shell "monkey --ignore-crashes --ignore-timeouts --ignore-security-exceptions --ignore-native-crashes --kill-process-after-error --pkg-blacklist-file /data/local/tmp/BlackList.txt --throttle 1000 -v -v 500000 > /data/local/tmp/MKY_LOG/mky_event.txt 2>/data/local/tmp/MKY_LOG/mky_error_%Thisday:~0,8%.txt \&"
	::adb shell "monkey --ignore-crashes --ignore-timeouts --ignore-security-exceptions --ignore-native-crashes --kill-process-after-error --pkg-blacklist-file /sdcard/BlackList.txt --throttle 1000 -v -v 500000 > /data/local/tmp/MKY_LOG/mky_event.txt 2>/data/local/tmp/MKY_LOG/mky_error_%Thisday:~0,8%.txt \&""
goto:eof



:syncHostTime
	echo Sync Time

	set DATE_Y=%date:~0,4%
	set DATE_M=%date:~5,2%
	set DATE_D=%date:~8,2%
	set TIME_H=%time:~0,2%
	set TIME_M=%time:~3,2%
	set TIME_S=%time:~6,2%
	
	adb shell setprop persist.sys.timezone Asia/Taipei
	adb shell "date %DATE_M%%DATE_D%%TIME_H%%TIME_M%%DATE_Y%"
goto:eof



:rootDevice
	echo root device
	ping 1.1.1.1 -n 1 -w 10000 > nul
	ScsiCommandLine.exe D SC_SWITCH_ROOT
	ScsiCommandLine.exe E SC_SWITCH_ROOT
	ScsiCommandLine.exe F SC_SWITCH_ROOT
	ScsiCommandLine.exe G SC_SWITCH_ROOT
	ScsiCommandLine.exe H SC_SWITCH_ROOT
	ScsiCommandLine.exe I SC_SWITCH_ROOT
	ScsiCommandLine.exe J SC_SWITCH_ROOT
	ScsiCommandLine.exe K SC_SWITCH_ROOT
	ping 1.1.1.1 -n 1 -w 10000 > nul

	echo Wait root device for 60 sec
	adb root
	ping 1.1.1.1 -n 1 -w 60000 > nul
	
	adb wait-for-device
goto:eof



:checkDevice
	echo check device

	echo Kill adb server
	adb kill-server
	ping 1.1.1.1 -n 1 -w 10000 > nul
	
	echo Restart adb server
	adb start-server
	ping 1.1.1.1 -n 1 -w 10000 > nul
	
	echo Enable All Port
	ScsiCommandLine.exe D SC_ENABLE_ALL_PORT
	ScsiCommandLine.exe E SC_ENABLE_ALL_PORT
	ScsiCommandLine.exe F SC_ENABLE_ALL_PORT
	ScsiCommandLine.exe G SC_ENABLE_ALL_PORT
	ScsiCommandLine.exe H SC_ENABLE_ALL_PORT
	ScsiCommandLine.exe I SC_ENABLE_ALL_PORT
	ScsiCommandLine.exe J SC_ENABLE_ALL_PORT
	ScsiCommandLine.exe K SC_ENABLE_ALL_PORT
	ping 1.1.1.1 -n 1 -w 10000 > nul
	
	adb wait-for-device
goto:eof
