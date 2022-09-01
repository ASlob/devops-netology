#!/usr/bin/bash

array_ip=("192.168.0.3 192.168.0.5 192.168.0.7")
port=80
while ((1==1))
do
for i in ${array_ip[@]}
  do
    nc -zv $i $port &>> ip.log
    if (($? != 0))
    then
      echo $i > error
      exit 1
    fi
  done
done
cat -n error








#array_ip=("192.168.0.3 192.168.0.5 192.168.0.7")
#port=80
#a=5
#while (($a > 0))
#do
#  for i in ${array_ip[@]}
#    do
#      date >> ip.log
#      nc -zv $i $port &>> ip.log
#    done
#    let "a=a-1"
#done
#cat -n ip.log







#while ((1==1))
#do
#	curl http://192.168.0.202:22
#	if (($? != 0))
#	then
#		date >> curl.log
#	fi
#done
