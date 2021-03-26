dir="/home/user/firmking/scanresults/"
dir2="*_logs"
rm -rf $dir$dir2
for file in `ls $dir | grep .fu`
do
  echo $dir$file
  python3 firmking.py -s 2 -r 1-10 --log $dir$file 192.168.0.1
    
done
find . -name "*Refused.txt*"
