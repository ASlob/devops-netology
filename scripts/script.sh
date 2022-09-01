#!/usr/bin/bash
while ((1==1))
do
	curl http://192.168.0.202:22
	if (($? != 0))
	then
		date >> curl.log
	fi
done
