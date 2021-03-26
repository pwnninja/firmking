#/bin/sh
COUNT_R=0
date > /var/run/boa_dog.rlt
echo "*************************** ">>/var/run/boa_dog.rlt
while [ 1 ];
do
        status=`ps aux |grep " boa " | grep -v grep |head -n 1|sed -e 's/^[ ]\{1,\}//g' | sed -e 's/[ \t]\{1,\}/ /g' | cut -d" " -f4 | cut -c1`
        if [ "$COUNT_R" -gt 10 -o "$status" = "" ]; then
                if [ "$status" != "" ]; then
                        pid=`ps aux |grep " boa " | grep -v grep |head -n 1|sed -e 's/^[ ]\{1,\}//g' | sed -e 's/[ \t]\{1,\}/ /g' | cut -d" " -f1 `
                        echo kill boa >> /var/run/boa_dog.rlt
                        kill -9 $pid
                fi
                echo start boa >> /var/run/boa_dog.rlt
                boa &
                date >> /var/run/boa_dog.rlt
                echo COUNT_T=$COUNT_R, status=$status >>/var/run/boa_dog.rlt
                echo "*************************** ">>/var/run/boa_dog.rlt
                COUNT_R=0
        fi
        if [ "$status" != "S" ]; then
                COUNT_R=`expr $COUNT_R + 1`
        elif [ "$COUNT_R" -gt "0" ]; then
                COUNT_R=`expr $COUNT_R - 1`
        fi
        sleep 15
        #echo status=$status, COUNT_R=$COUNT_R
done

