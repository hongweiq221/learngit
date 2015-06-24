#!/bin/bash
Server=192.168.192.211
Mail=jeff.qin@9street.org
LOG=/root/ping.log
b=0   
while [ true ]
        do
                [ `ping -w 3 $Server | grep 'time=' | wc -l` -ge 1 ] > /dev/null    #允许ping超时2次。
                a=$?
                if [ $a -ne 0 ]    #判断执行上面ping命令是否正常，为0则网络正常，否则提示网络中断。
                        then
                        if [ $a -ne $b ]    #解决网络中断时一直提示的问题。
                                then
                                b=$a    #给予下次判断网络是否正常。
                                date >> $LOG
                                echo "$Server 路由表：" >> $LOG
                                traceroute -n -m 10 $Server >> $LOG \ &&
                                echo '-------------------------------------------------' >> $LOG \ &&
                                echo '' >> $LOG
                                echo '' >> $LOG
                                tail -30 $LOG > /root/ping.txt
                                echo '警报警报：网络中断！！' | mail $Mail -s '网络中断' -a /root/ping.txt
                       
                        fi
                else
                        if [ $a -ne $b ]    #解决网络正常时一直提示的问题。
                                then
                                b=$a    #给予下次判断网络是否正常。
                                date >> $LOG
                                echo "$Server 路由表：" >> $LOG
                                traceroute -n -m 10 $Server >> $LOG \ &&
                                echo '-------------------------------------------------' >> $LOG \ &&
                                echo '' >> $LOG
                                echo '' >> $LOG
                                tail -30 $LOG > /root/ping.txt
                                echo '通知：网络恢复正常！！' | mail $Mail -s '网络正常' -a /root/ping.txt
                       
                         fi
               fi
done
