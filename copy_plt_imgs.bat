@echo off

set PLT_TOP=%1

if not exist %2 (
    echo "mkdir: %2"
    mkdir %2
)

set LOCAL_DIR=%2
set AP_IMG_PATH=%PLT_TOP%\LINUX\out_img\PLT

REM trustzone imags 
set TZ_IMG_PATH=%PLT_TOP%\TZ.BF.4.0.5\trustzone_images\build\ms\bin\ZALAANAA
call:test_then_copy %TZ_IMG_PATH%\cmnlib.mbn %2\
call:test_then_copy %TZ_IMG_PATH%\cmnlib64.mbn %2\
call:test_then_copy %TZ_IMG_PATH%\keymaster.mbn %2\
call:test_then_copy %TZ_IMG_PATH%\lksecapp.mbn %2\
call:test_then_copy %TZ_IMG_PATH%\tz.mbn %2\
call:test_then_copy %TZ_IMG_PATH%\devcfg.mbn %2\

REM BOOT imags
set BOOT_IMG_CORE=%PLT_TOP%\BOOT.BF.3.3\boot_images\core\storage\tools\ptool
set BOOT_MS_BIN=%PLT_TOP%\BOOT.BF.3.3\boot_images\build\ms\bin
call:test_then_copy %BOOT_IMG_CORE%\gpt_main0.bin %2\
call:test_then_copy %BOOT_IMG_CORE%\gpt_backup0.bin %2\
call:test_then_copy %BOOT_IMG_CORE%\gpt_both0.bin %2\
call:test_then_copy %BOOT_IMG_CORE%\patch0.xml %2\
call:test_then_copy %BOOT_IMG_CORE%\rawprogram0.xml %2\
call:test_then_copy %BOOT_IMG_CORE%\rawprogram0_BLANK.xml %2\
call:test_then_copy %BOOT_IMG_CORE%\zeros_1sector.bin %2\
call:test_then_copy %BOOT_IMG_CORE%\zeros_33sectors.bin %2\
call:test_then_copy %BOOT_MS_BIN%\FAASANAZ\sbl1.mbn %2\
call:test_then_copy %BOOT_MS_BIN%\FAADANAZ\prog_emmc_firehose_8937_ddr.mbn %2\
call:test_then_copy %BOOT_MS_BIN%\FAADANAZ\prog_emmc_firehose_8937_lite.mbn %2\
call:test_then_copy %BOOT_MS_BIN%\FAADANAZ\validated_emmc_firehose_8937_ddr.mbn %2\

REM MSM8937
set MSM8937_PATH=%PLT_TOP%\MSM8937\common
call:test_then_copy %MSM8937_PATH%\build\bin\asic\NON-HLOS.bin %2\
call:test_then_copy %MSM8937_PATH%\sectools\resources\build\fileversion2\sec.dat %2\

REM ADSP
call:test_then_copy %PLT_TOP%\ADSP.8953.2.8.2\adsp_proc\build\dynamic_signed\8937\adspso.bin %2\

REM RPM
call:test_then_copy %PLT_TOP%\RPM.BF.2.2\rpm_proc\build\ms\bin\8937\rpm.mbn %2\

REM FTM
call:test_then_copy %PLT_TOP%\FTM\out\ftm.img %2\

rem aboot
set AP_PATH=%PLT_TOP%\LINUX\out_img\PLT
call:test_then_copy %AP_PATH%\*emmc_appsboot.mbn %2\emmc_appsboot.mbn

rem userdata.img
set USERDATA_PATH=%PLT_TOP%\LINUX\android\out\target\product\PLT
call:test_then_copy %USERDATA_PATH%\userdata.img %2\userdata.img

rem other ap images 
set MODEL=%3
rem boot and cache are the same in all models 
call:test_then_copy %AP_PATH%\PLT*0001-boot.img %2\boot.img
call:test_then_copy %AP_PATH%\PLT*0001-cache.img %2\cache.img
call:test_then_copy %AP_PATH%\PLT*%MODEL%-mdtp.img %2\mdtp.img
call:test_then_copy %AP_PATH%\PLT*%MODEL%-persist.img %2\persist.img
call:test_then_copy %AP_PATH%\PLT*%MODEL%-ramdisk.img %2\ramdisk.img
call:test_then_copy %AP_PATH%\PLT*%MODEL%-ramdisk-recovery.img %2\ramdisk-recovery.img
call:test_then_copy %AP_PATH%\PLT*%MODEL%-recovery.img %2\recovery.img
call:test_then_copy %AP_PATH%\PLT*%MODEL%-system.img %2\system.img

REM copy file if the file exists
:test_then_copy
if exist %1 (
    echo copying %1
    echo f | xcopy /Q %1 %2 > nul
) else (
    echo %1 does not exist.
)
goto:eof