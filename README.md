1. Step 1: Static Analysis

Use the following command to scan httpd_ac15 binary, and generate session files in ./scanresults.
 
python3 scan_tenda.py template1.fu ./scanresults ./tests/httpd_ac15

template1.fu: template session file

./scanresults: directory of generated session files

./tests/httpd_ac15: target binary to scan

2. Step 2: Fuzzing

python3 firmking.py -s 2 -r 1-15 xx.fu 192.168.0.1 --log 

-s: seconds to sleep between two fuzz cases

-r: min case number and max case number

--log: record all logs

If you want to fuzz all the .fu files automatically, then run ./autofuzzall.sh

Find xxRefused.txt and you can see which case crashed the target server
