@echo off


call:prepareMonkeyEnv

echo Reboot device and Wait for 120 Sec
adb reboot


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