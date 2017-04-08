REM Pull log

@echo off

echo pull mky_event_mky_error
adb pull  /data/local/tmp/MKY_LOG/.

ping -n 1 127.0.0.1>nul

echo finish
pause