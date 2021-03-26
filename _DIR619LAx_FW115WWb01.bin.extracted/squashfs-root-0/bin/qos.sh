#!/bin/sh
#
# script file for traffic control (QoS)
#

WAN=eth1
BRIDGE=br0

eval `flash get WAN_DHCP`
eval `flash get OP_MODE`

# if wireless ISP mode , set WAN to wlan0
eval `flash get  WISP_WAN_ID`
if [ "$OP_MODE" = '2' ];then
	WAN=wlan$WISP_WAN_ID
fi

if [ $WAN_DHCP = 3 ] || [ $WAN_DHCP = 4 ]; then
  WAN=ppp0
fi 


eval `flash get QOS_ENABLED`
eval `flash get QOS_AUTO_UPLINK_SPEED`
eval `flash get QOS_MANUAL_UPLINK_SPEED`
eval `flash get QOS_RULE_TBL_NUM`


iptables -F -t mangle
iptables -X -t mangle
iptables -Z -t mangle
tc qdisc del dev $WAN root 2> /dev/null
tc qdisc del dev $BRIDGE root 2> /dev/null

## this line is in firewall.sh, run it again because mangle table is cleared before.
iptables -t mangle -I PREROUTING -i $BRIDGE -j MARK --set-mark 5


PROC_QOS="$QOS_ENABLED,"

UPLINK_SPEED=102400
DOWNLINK_SPEED=102400

if [ "$QOS_ENABLED" = '1' ];then

    #######################################################################
    ######## uplink speed
    #######################################################################
    if [ "$QOS_AUTO_UPLINK_SPEED" = '0' ];then
        UPLINK_SPEED=$QOS_MANUAL_UPLINK_SPEED
    fi


    #######################################################################
    ### using different parameter according to the WAN speed
    #######################################################################
    if [ $UPLINK_SPEED -le 1024 ]; then
        PRIO_HIGH_STR="pfifo limit 10"
        PRIO_LOW_STR="pfifo limit 1"
        
    elif [ $UPLINK_SPEED -lt 20480 ]; then
        PRIO_HIGH_STR="sfq perturb 10"
        PRIO_LOW_STR="sfq perturb 10"

    elif [ $UPLINK_SPEED -le 40960 ]; then
        PRIO_HIGH_STR="sfq perturb 10"
        PRIO_LOW_STR="pfifo limit 5"

    elif [ $UPLINK_SPEED -le 61440 ]; then
        PRIO_HIGH_STR="sfq perturb 10"
        PRIO_LOW_STR="pfifo limit 2"

    elif [ $UPLINK_SPEED -le 81920 ]; then
        PRIO_HIGH_STR="sfq perturb 10"
        PRIO_LOW_STR="pfifo limit 1"
                    
    else
        PRIO_HIGH_STR="sfq perturb 20"
        PRIO_LOW_STR="pfifo limit 1"
    fi

        

    qdisc_root_done=0
    wan_pkt_mark=13
    lan_pkt_mark=43
    wan_pkt_udp=28
    
    #######################################################################
    ######## QoS rules section
    #######################################################################    
    if [ $QOS_RULE_TBL_NUM -gt 0 ];then

        ###################################################################
        ######## find the index with enabled and highest priority
        ###################################################################    
        num=1
        tmp_highest_prio=255
        HIGHEST_PRIO_IDX=1
        
        while [ $num -le $QOS_RULE_TBL_NUM ];
        do
            
            str=`flash get QOS_RULE_TBL | grep QOS_RULE_TBL$num`
            str=`echo $str | cut -f2 -d=`
            enabled=`echo $str | cut -f1 -d,`            

            if [ $enabled -gt 0 ];then
            
                priority=`echo $str | cut -f2 -d,`
                priority=`echo $priority | cut -f2 -d" "`

                if [ $priority -lt $tmp_highest_prio ]; then
    			 tmp_highest_prio=$priority
    			 HIGHEST_PRIO_IDX=$num
                fi
            fi

            num=`expr $num + 1`
        done

        ###################################################################
        ###################################################################    

        num=1
  
        while [ $num -le $QOS_RULE_TBL_NUM ];
        do
            
            str=`flash get QOS_RULE_TBL | grep QOS_RULE_TBL$num`
            str=`echo $str | cut -f2 -d=`
            enabled=`echo $str | cut -f1 -d,`
            

            if [ $enabled -gt 0 ];then
            
                ### include leading space character
                priority=`echo $str | cut -f2 -d,`
                protocol=`echo $str | cut -f3 -d,`
                lo_ip_start=`echo $str | cut -f4 -d,`
                lo_ip_end=`echo $str | cut -f5 -d,`
                lo_port_start=`echo $str | cut -f6 -d,`
                lo_port_end=`echo $str | cut -f7 -d,`
                re_ip_start=`echo $str | cut -f8 -d,`
                re_ip_end=`echo $str | cut -f9 -d,`
                re_port_start=`echo $str | cut -f10 -d,`
                re_port_end=`echo $str | cut -f11 -d,`

                ### remove leading space character
                priority=`echo $priority | cut -f2 -d" "`
                protocol=`echo $protocol | cut -f2 -d" "`
                lo_ip_start=`echo $lo_ip_start | cut -f2 -d" "`
                lo_ip_end=`echo $lo_ip_end | cut -f2 -d" "`
                lo_port_start=`echo $lo_port_start | cut -f2 -d" "`
                lo_port_end=`echo $lo_port_end | cut -f2 -d" "`
                re_ip_start=`echo $re_ip_start | cut -f2 -d" "`
                re_ip_end=`echo $re_ip_end | cut -f2 -d" "`
                re_port_start=`echo $re_port_start | cut -f2 -d" "`
                re_port_end=`echo $re_port_end | cut -f2 -d" "`

                if [ "$protocol" = '6' ]  || [ "$protocol" = '17' ]   || [ "$protocol" = '256' ] || [ "$protocol" = '257' ]; then
    			 str="$protocol,$lo_ip_start,$lo_ip_end,$re_ip_start,$re_ip_end,"
    			 PROC_QOS="$PROC_QOS$str"
    			
    			 str="$lo_port_start,$lo_port_end,$re_port_start,$re_port_end,"
  			 PROC_QOS="$PROC_QOS$str"
                fi
                
                if [ $qdisc_root_done -eq 0 ];then
                    ### for WAN
                    tc qdisc add dev $WAN root handle 2:0 htb default 2                    
                    TC_CMD="tc class add dev $WAN parent 2:0 classid 2:1 htb rate ${UPLINK_SPEED}kbit ceil ${UPLINK_SPEED}kbit"
                    $TC_CMD
                    TC_CMD="tc class add dev $WAN parent 2:1 classid 2:2 htb rate 1kbit ceil ${UPLINK_SPEED}kbit prio 256"
                    $TC_CMD
                    TC_CMD="tc qdisc add dev $WAN parent 2:2 handle 102: ${PRIO_LOW_STR}"
                    $TC_CMD

                    ### for LAN
                    tc qdisc add dev $BRIDGE root handle 1:0 htb default 2
                    TC_CMD="tc class add dev $BRIDGE parent 1:0 classid 1:1 htb rate ${DOWNLINK_SPEED}kbit ceil ${DOWNLINK_SPEED}kbit"
                    $TC_CMD
                    TC_CMD="tc class add dev $BRIDGE parent 1:1 classid 1:2 htb rate 1kbit ceil ${DOWNLINK_SPEED}kbit prio 256"
                    $TC_CMD
                    TC_CMD="tc qdisc add dev $BRIDGE parent 1:2 handle 102: sfq perturb 10"
                    $TC_CMD
                    
                    qdisc_root_done=1
                fi

                
                ################################### for WAN ###########################
                if [ "$protocol" = '256' ]; then
                    IPT_CMD="iptables -A PREROUTING -t mangle -m iprange --src-range ${lo_ip_start}-${lo_ip_end} --dst-range ${re_ip_start}-${re_ip_end} -j MARK --set-mark $wan_pkt_mark"
                
                elif [ "$protocol" = '6' ]  || [ "$protocol" = '17' ]; then
                    IPT_CMD="iptables -A PREROUTING -t mangle -p ${protocol} --sport ${lo_port_start}:${lo_port_end} --dport ${re_port_start}:${re_port_end} -m iprange --src-range ${lo_ip_start}-${lo_ip_end} --dst-range ${re_ip_start}-${re_ip_end} -j MARK --set-mark $wan_pkt_mark"

                elif [ "$protocol" = '257' ]; then
                    IPT_CMD="iptables -A PREROUTING -t mangle -p tcp --sport ${lo_port_start}:${lo_port_end} --dport ${re_port_start}:${re_port_end} -m iprange --src-range ${lo_ip_start}-${lo_ip_end} --dst-range ${re_ip_start}-${re_ip_end} -j MARK --set-mark $wan_pkt_mark"
##                    $IPT_CMD
##                    IPT_CMD="iptables -A PREROUTING -t mangle -p udp --sport ${lo_port_start}:${lo_port_end} --dport ${re_port_start}:${re_port_end} -m iprange --src-range ${lo_ip_start}-${lo_ip_end} --dst-range ${re_ip_start}-${re_ip_end} -j MARK --set-mark $wan_pkt_mark"
                    
                else
                    IPT_CMD="iptables -A PREROUTING -t mangle -p ${protocol} -m iprange --src-range ${lo_ip_start}-${lo_ip_end} --dst-range ${re_ip_start}-${re_ip_end} -j MARK --set-mark $wan_pkt_mark"
                fi
                $IPT_CMD
                    
                TC_CMD="tc class add dev $WAN parent 2:1 classid 2:$wan_pkt_mark htb rate 1kbit ceil ${UPLINK_SPEED}kbit prio $priority"
                $TC_CMD

                if [ $num -eq $HIGHEST_PRIO_IDX ]; then
                    TC_CMD="tc qdisc add dev $WAN parent 2:$wan_pkt_mark handle 1$wan_pkt_mark: ${PRIO_HIGH_STR}"
                else
                    TC_CMD="tc qdisc add dev $WAN parent 2:$wan_pkt_mark handle 1$wan_pkt_mark: ${PRIO_LOW_STR}"
                fi
                $TC_CMD

                TC_CMD="tc filter add dev $WAN parent 2:0 protocol ip prio 100 handle $wan_pkt_mark fw classid 2:$wan_pkt_mark"
                $TC_CMD
            
                wan_pkt_mark=`expr $wan_pkt_mark + 1`            


                ################### for WAN-UDP, add another classid ###########################

                if [ "$protocol" = '17' ]   || [ "$protocol" = '256' ] || [ "$protocol" = '257' ]; then
                
                  if [ "$protocol" = '256' ]; then
                    IPT_CMD="iptables -A PREROUTING -t mangle -p udp -m iprange --src-range ${lo_ip_start}-${lo_ip_end} --dst-range ${re_ip_start}-${re_ip_end} -j MARK --set-mark $wan_pkt_udp"                
                  else
                    IPT_CMD="iptables -A PREROUTING -t mangle -p udp --sport ${lo_port_start}:${lo_port_end} --dport ${re_port_start}:${re_port_end} -m iprange --src-range ${lo_ip_start}-${lo_ip_end} --dst-range ${re_ip_start}-${re_ip_end} -j MARK --set-mark $wan_pkt_udp"
                  fi
                  $IPT_CMD
                    
                  TC_CMD="tc class add dev $WAN parent 2:1 classid 2:$wan_pkt_udp htb rate 1kbit ceil ${UPLINK_SPEED}kbit prio $priority"
                  $TC_CMD

                  TC_CMD="tc qdisc add dev $WAN parent 2:$wan_pkt_udp handle 1$wan_pkt_udp: sfq perturb 10"
                  $TC_CMD

                  TC_CMD="tc filter add dev $WAN parent 2:0 protocol ip prio 100 handle $wan_pkt_udp fw classid 2:$wan_pkt_udp"
                  $TC_CMD
            
                  wan_pkt_udp=`expr $wan_pkt_udp + 1`            
                fi




                ################################### for LAN ###########################
                if [ "$protocol" = '256' ]; then
                    IPT_CMD="iptables -A POSTROUTING -t mangle -m iprange --src-range ${re_ip_start}-${re_ip_end} --dst-range ${lo_ip_start}-${lo_ip_end} -j MARK --set-mark $lan_pkt_mark"
                
                elif [ "$protocol" = '6' ]  || [ "$protocol" = '17' ]; then
                    IPT_CMD="iptables -A POSTROUTING -t mangle -p ${protocol} --sport ${re_port_start}:${re_port_end} --dport ${lo_port_start}:${lo_port_end} -m iprange --src-range ${re_ip_start}-${re_ip_end} --dst-range ${lo_ip_start}-${lo_ip_end} -j MARK --set-mark $lan_pkt_mark"

                elif [ "$protocol" = '257' ]; then
                    IPT_CMD="iptables -A POSTROUTING -t mangle -p tcp --sport ${re_port_start}:${re_port_end} --dport ${lo_port_start}:${lo_port_end} -m iprange --src-range ${re_ip_start}-${re_ip_end} --dst-range ${lo_ip_start}-${lo_ip_end} -j MARK --set-mark $lan_pkt_mark"
                    $IPT_CMD
                    IPT_CMD="iptables -A POSTROUTING -t mangle -p udp --sport ${re_port_start}:${re_port_end} --dport ${lo_port_start}:${lo_port_end} -m iprange --src-range ${re_ip_start}-${re_ip_end} --dst-range ${lo_ip_start}-${lo_ip_end} -j MARK --set-mark $lan_pkt_mark"
                    
                else
                    IPT_CMD="iptables -A POSTROUTING -t mangle -p ${protocol} -m iprange --src-range ${re_ip_start}-${re_ip_end} --dst-range ${lo_ip_start}-${lo_ip_end} -j MARK --set-mark $lan_pkt_mark"
                fi
                $IPT_CMD
                    
                TC_CMD="tc class add dev $BRIDGE parent 1:1 classid 1:$lan_pkt_mark htb rate 1kbit ceil ${DOWNLINK_SPEED}kbit prio $priority"
                $TC_CMD

                TC_CMD="tc qdisc add dev $BRIDGE parent 1:$lan_pkt_mark handle 1$lan_pkt_mark: sfq perturb 10"
                $TC_CMD

                TC_CMD="tc filter add dev $BRIDGE parent 1:0 protocol ip prio 100 handle $lan_pkt_mark fw classid 1:$lan_pkt_mark"
                $TC_CMD

                lan_pkt_mark=`expr $lan_pkt_mark + 1`            
    
            fi

            num=`expr $num + 1`
        done
    
    fi

fi

echo "$PROC_QOS"> /proc/qos


### old_0
#    WAN speed: 0 ~ 100Mbps
#        prio 1:         sfq perturb 10
#        prio others:    sfq perturb 10
#        

### old
#    WAN speed <= 17Mbps: (17408k)
#        prio 1:         pfifo limit 10
#        prio others:    pfifo limit 1
#        
#    17M < WAN speed <= 40Mbps: (40960)
#        prio 1:         sfq perturb 10
#        prio others:    pfifo limit 5      
#        
#    40M < WAN speed <= 60Mbps: (61440k)
#        prio 1:         sfq perturb 10
#        prio others:    pfifo limit 2      
#
#    60M < WAN speed <= 80Mbps: (81920k)
#        prio 1:         sfq perturb 10
#        prio others:    pfifo limit 1        
#        
#    80M < WAN speed <= 100Mbps:
#        prio 1:         sfq perturb 20
#        prio others:    pfifo limit 1        
#

### new
#    WAN speed <= 1Mbps: (1024k)
#        prio 1:         pfifo limit 10
#        prio others:    pfifo limit 1
#
#    1M < WAN speed < 20Mbps: (20480)
#        prio 1:         sfq perturb 10
#        prio others:    sfq perturb 10      
#
#    20M <= WAN speed <= 40Mbps: (40960)
#        prio 1:         sfq perturb 10
#        prio others:    pfifo limit 5      
#        
#    40M < WAN speed <= 60Mbps: (61440k)
#        prio 1:         sfq perturb 10
#        prio others:    pfifo limit 2      
#
#    60M < WAN speed <= 80Mbps: (81920k)
#        prio 1:         sfq perturb 10
#        prio others:    pfifo limit 1        
#        
#    80M < WAN speed <= 100Mbps:
#        prio 1:         sfq perturb 20
#        prio others:    pfifo limit 1        
#

