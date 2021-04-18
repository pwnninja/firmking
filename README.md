1. Step 1: Static Analysis


2. Step 2: Fuzzing
python3 firmking.py -s 2 -r 1-15 xx.fu 192.168.0.1 --log 
-s: seconds to sleep between two fuzz cases
-r: min case number and max case number
--log: record all logs
If you want to fuzz all the .fu files automatically, then run ./autofuzzall.sh
