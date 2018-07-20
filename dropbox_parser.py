#!/usr/bin/env python3

"""A simple dropbox parser

This is a simple tool that can parse errors in android dropbox and
print errors on stardand output, The errors are stored in a global
dict variable named "result".
"""

import os
import sys
import re
import gzip
import shutil
import time

from datetime import datetime

# 'result' variable has the following structure:
#
# {"UNKNOWN_RESET" : [time, ...],
# "FRAMEWORK_REBOOT" : [time ...],
# "SYSTEM_RESTART" : [time, ...],
# "SYSTEM_BOOT" : [time, ...],
# "system_server_watchdog" : [time ...],
# "system_server_crash" : [time ...],
# "SYSTEM_FSCK" : [time, ...],
# "system_server_anr" : [time ...],
# "system_app_crash" : {"packagename" : [time ...], ...},
# "system_app_native_crash" : {"packagename" : [time ...], ...},
# "data_app_native_crash" : {"packagename" : [time ...], ...},
# "data_app_crash" : {"packagename" : [time ...], ...},
# "system_app_anr" : {"packagename" : [time, ...], ...},
# "data_app_anr" : {"packagename" : [time, ...], ...},
# "SYSTEM_TOMBSTONE" : {"packagename" : [time, ...], ...},
# "system_app_wtf" : {"packagename" : [time, ...], ...},
# "SYSTEM_LAST_KMSG" : [time, ...],
# "SYSTEM_RECOVERY_KMSG" : [time, ...],
# "SYSTEM_AUDIT" : [time, ...],
# "system_server_wtf" : [time, ...]
# }
result = {}
verbose = False
dropboxpath = ""


def usage():
    print("Usage: python " + sys.argv[0] + " [-v] <dropbox folder>\n")
    print("  [-v]:              Verbose output, default not")
    print("  <dropbox folder>:  Path to the dropbox, which is Mandatory")


def has_timestamp(filename):
    pathname = os.path.join(dropboxpath, filename)
    if os.path.isdir(pathname):
        return False
    if re.search(r"[0-9]{1,}", filename):
        return True
    else:
        return False


def gettime_readable(filename):
    """return a human readable time string"""
    unix_time = gettime_unix(filename)
    return datetime.fromtimestamp(int(unix_time[:-3])).isoformat(" ")


def gettime_unix(filename):
    m = re.search(r"[0-9]{1,}", filename)
    return m.group(0)


def unix_to_readable(unix_time):
    time_local = time.localtime(int(unix_time[:-3]))
    return time.strftime("%Y-%m-%d %H:%M:%S", time_local)


def get_pkgname_sys_app_crash(pathname):
    f = open(pathname, errors='ignore')
    firstline = f.readline()
    return firstline.split(":")[1].strip()


def get_pkgname_sys_app_anr(filepath):
    return get_pkgname_sys_app_crash(filepath)


def get_pkgname_data_app_anr(filepath):
    return get_pkgname_sys_app_crash(filepath)


def get_pkgname_data_app_crash(filepath):
    return get_pkgname_sys_app_crash(filepath)


def get_pkgname_sys_app_native_crash(filepath):
    return get_pkgname_sys_app_crash(filepath)


def get_pkgname_data_app_native_crash(filepath):
    return get_pkgname_sys_app_crash(filepath)


def get_pkgname_system_tombstone(filepath):
    f = open(filepath, errors='ignore')
    pkgname = "UNKNOWN"
    for line in f:
        if ">>> " in line:
            pkgname = line.split(">>>")[1].strip().split()[0]
            break
    return pkgname


def get_pkgname_sys_app_strictmode(filepath):
    return get_pkgname_sys_app_crash(filepath)


def get_pkgname_sys_app_wtf(filepath):
    return get_pkgname_sys_app_crash(filepath)


def ungzip(filename):
    """extract gzip file"""
    subdir = filename[:-3]
    abs_filename = os.path.join(dropboxpath, filename)
    extract_to = os.path.join(dropboxpath, subdir)
    if os.path.exists(extract_to):
        shutil.rmtree(extract_to)
    uncompressfilename = os.path.join(extract_to, subdir)
    gzfile = gzip.GzipFile(mode='rb', fileobj=open(abs_filename, 'rb'))
    os.mkdir(extract_to)
    open(uncompressfilename, 'wb').write(gzfile.read())
    return uncompressfilename


def parse_time(filename):
    """get time of the error"""
    pattern = filename.split("@", 1)[0]
    times = []
    time = gettime_unix(filename)
    if pattern in result:
        times = result[pattern]
        times.append(time)
    else:
        times = [time]

    result[pattern] = times


def parse_pkgname(filename):
    """get time and package name of the error event"""
    unix_time = gettime_unix(filename)
    if filename.endswith(".gz"):
        filepath = ungzip(filename)
    else:
        filepath = os.path.join(dropboxpath, filename)
    pattern = filename.split("@", 1)[0]
    if pattern == "system_app_crash":
        packagename = get_pkgname_sys_app_crash(filepath)
    elif pattern == "system_app_anr":
        packagename = get_pkgname_sys_app_anr(filepath)
    elif pattern == "data_app_crash":
        packagename = get_pkgname_data_app_crash(filepath)
    elif pattern == "data_app_anr":
        packagename = get_pkgname_data_app_anr(filepath)
    elif pattern == "system_app_native_crash":
        packagename = get_pkgname_sys_app_native_crash(filepath)
    elif pattern == "data_app_native_crash":
        packagename = get_pkgname_data_app_native_crash(filepath)
    elif pattern == "SYSTEM_TOMBSTONE":
        packagename = get_pkgname_system_tombstone(filepath)
    elif pattern == "system_app_strictmode":
        packagename = get_pkgname_sys_app_strictmode(filepath)
    elif pattern == "system_app_wtf":
        packagename = get_pkgname_sys_app_wtf(filepath)

    if pattern not in result:
        result[pattern] = {}

    if packagename not in result[pattern]:
        result[pattern][packagename] = []

    if unix_time not in result[pattern][packagename]:
        result[pattern][packagename].append(unix_time)


def parse(filename):
    pattern = filename.split("@", 1)[0]
    if pattern == "UNKNOWN_RESET" or \
            pattern == "FRAMEWORK_REBOOT" or \
            pattern == "SYSTEM_RESTART" or \
            pattern == "SYSTEM_BOOT" or \
            pattern == "system_server_watchdog" or \
            pattern == "system_server_crash" or \
            pattern == "SYSTEM_FSCK" or \
            pattern == "system_server_anr" or \
            pattern == "SYSTEM_LAST_KMSG" or \
            pattern == "SYSTEM_RECOVERY_KMSG" or \
            pattern == "SYSTEM_AUDIT" or \
            pattern == "system_server_wtf":
        parse_time(filename)
    elif pattern == "system_app_crash" or \
            pattern == "data_app_crash" or \
            pattern == "system_app_strictmode" or \
            pattern == "system_app_anr" or \
            pattern == "data_app_anr" or \
            pattern == "system_app_native_crash" or \
            pattern == "data_app_native_crash" or \
            pattern == "SYSTEM_TOMBSTONE" or \
            pattern == "system_app_wtf":
        parse_pkgname(filename)
    else:
        #print("UNKNOW TYPE: ", pattern)
        pass


def print_result(result):
    """print the result"""
    if result == {}:
        print("NO DROPBOX ERROR LOG FOUND!")
        return
    format = "%-50s%-30s%-10s"
    print(format % ("PACKAGE NAME", "TIME", "COUNT"))
    print()
    for key, value in result.items():
        print(key.center(90, '-'))
        if type(value) == list:
            if not verbose:
                print(format % (key, unix_to_readable(value[-1]), len(value)))
            else:
                for i in range(len(value)):
                    print(format % (key, unix_to_readable(value[i]), i+1))
        elif type(value) == dict:
            for p, t in value.items():
                if not verbose:
                    print(format % (p, unix_to_readable(t[-1]), len(t)))
                else:
                    for i in range(len(t)):
                        print(format % (p, unix_to_readable(t[i]), i+1))
        print()


def main():
    if len(sys.argv) > 3:
        usage()
        sys.exit(-1)

    for arg in sys.argv[1:]:
        if arg == "-v":
            global verbose
            verbose = True
        elif os.path.isdir(arg):
            global dropboxpath
            dropboxpath = arg
        else:
            usage()
            sys.exit(-1)

    if dropboxpath == "":
        usage()
        sys.exit(-1)

    all_items = os.listdir(dropboxpath)
    files_with_timestamp = [x for x in all_items if has_timestamp(x)]

    for f in files_with_timestamp:
        parse(f)

    print_result(result)


if __name__ == "__main__":
    main()
