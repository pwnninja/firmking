# firmking

# Usage:

## 1.Create a session template file

## 2.Static analysis:

   python3 scan.py template.fu scanresults/ "./tests/httpd_ac15"
   
## 3.Fuzz a single interface:

   python3 firmking.py -s 0.5 scanresults/xx.fu 192.168.0.1 –log

## 4.Fuzz all interfaces automatically:

   ./autofuzzall.sh


<br></br>
All results saved in ./scanresults
