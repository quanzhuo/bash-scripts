#!/usr/bin/python

import os
import re
import datetime

def contains_time_stamp(name):
    if re.search(r"[0-9]{13}", name):
        return True
    else:
        return False

def ls_with_pattern(files, pattern):
    result = []
    for var in files:
        if re.search(pattern, var):
            result.append(var)
    return result

def do_parse(file_list, pattern):
    files = ls_with_pattern(file_list, pattern)
    if not files:
        return
    for file_name in files:
        # print "file-name: ", file_name
        m = re.search(r"[0-9]{13}", file_name)
        unix_time = m.group(0)
        datetime_str = unix_time[:-3] + "." + unix_time[-3:]
        readable = datetime.datetime.fromtimestamp(float(datetime_str)).isoformat(' ')
        print "%-40s%15s" % (file_name, readable)
    print

def parse(file_list):
    do_parse(file_list, "FRAMEWORK_REBOOT")
    do_parse(file_list, "SYSTEM_RESTART")
    do_parse(file_list, "SYSTEM_BOOT")
    do_parse(file_list, "system_server_watchdog")
    do_parse(file_list, "system_server_crash")
    do_parse(file_list, "system_app_crash")
    do_parse(file_list, "system_app_native_crash")
    do_parse(file_list, "data_app_native_crash")
    do_parse(file_list, "data_app_crash")
    do_parse(file_list, "system_app_anr")
    do_parse(file_list, "data_app_anr")
    do_parse(file_list, "SYSTEM_TOMBSTONE")
    do_parse(file_list, "SYSTEM_LAST_KMSG")
    do_parse(file_list, "SYSTEM_RECOVERY_KMSG")
    do_parse(file_list, "SYSTEM_AUDIT")
    do_parse(file_list, "system_server_wtf")
    do_parse(file_list, "system_app_wtf")


if __name__ == "__main__":
    all_files =  os.listdir(".")
    files_with_time_stamp = filter(contains_time_stamp, all_files)
    parse(files_with_time_stamp)
