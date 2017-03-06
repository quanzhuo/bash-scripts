# This script dump meminfo of each system process
# every 2 minutes

MEMINFO_FILE=/sdcard/meminfo.txt

rm -rf $MEMINFO_FILE

# counter
let c=1

while true
do
    echo "==========date: $(date); count: $c==========\n" >> $MEMINFO_FILE
    
    dumpsys meminfo >> $MEMINFO_FILE
    
    # sleep for 2 minutes
    sleep 120

    # +1
    let c++

    echo "\n" >> $MEMINFO_FILE
done
    
