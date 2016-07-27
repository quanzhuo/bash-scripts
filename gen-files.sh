let suffix=0
let sum=0

mkdir gen-files &> /dev/null
rm -rf /sdcard/gen-files/* &> /dev/null

while true
do
    if dd if=/dev/zero of=/sdcard/gen-files/data$suffix \
	  bs=1m count=200 &> /dev/null
    then
	let suffix++
	echo "create file data$suffix done, size: 200 MB"
	let sum=$sum+200
    else
	echo "no enough space left !"
	echo "sum: $sum MB"
	echo "quit"
	break
    fi
done
