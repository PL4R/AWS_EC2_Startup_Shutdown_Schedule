#!/bin/bash

#######################################
# AWS EC2 Automated start/stop script #
#######################################
#
# Requires a tag of "Runwindow" to be allocated to the EC2 instance
# Value for tag needs to be expressed in 24Hr notation as starthour-stophour:
# e.g. 01-22 means start @ 1AM and stop @ 10PM
#
# If you want to only manage the stopping of an instance, use xx for the starthour field.
# If you want to only manage the starting of an instance, use xx for the stophour field.



# Start Instances

for i in `aws ec2 describe-instances --filters "Name=tag-key,Values=Runwindow" "Name=instance-state-name,Values=stopped" | grep -i instanceid | awk '{print $2}'| sed 's/\"//g;s/\,//g'`

do
echo ${i}

ec2hour=`aws ec2 describe-instances  --instance-ids ${i} | grep -i -C 1 Runwindow | grep -i value | awk '{print $2}' | sed 's/\"//g;s/\,//g' | awk -F "-" '{print $1}'`

echo  instance ready for startup ${i} at hour "$ec2hour"

if ! [[ $ec2hour =~ ([0-2][0-9]) ]];then
   echo start hour is not a valid time > /dev/null
elif [ $ec2hour == `date +%H` ];then
   aws ec2 start-instances --instance-ids ${i}
   echo starting instance ${i}
else
 echo > /dev/null
fi
done


#Stop Instances

for i in `aws ec2 describe-instances --filters "Name=tag-key,Values=Runwindow" "Name=instance-state-name,Values=running" | grep -i instanceid | awk '{print $2}'| sed 's/\"//g;s/\,//g'`

do

ec2hour=`aws ec2 describe-instances  --instance-ids ${i} | grep -i -C 1 Runwindow | grep -i value | awk '{print $2}' | sed 's/\"//g;s/\,//g' | awk -F "-" '{print $2}'`

echo  instance ready for shutdown ${i} at hour "$ec2hour"

if ! [[ $ec2hour =~ ([0-2][0-9]) ]];then
   echo stop hour is not a valid time > /dev/null
elif [ $ec2hour == `date +%H` ];then
   aws ec2 stop-instances --instance-ids ${i}
   echo stopping instance ${i}
else
 echo > /dev/null
fi
done
