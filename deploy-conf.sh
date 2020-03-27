#!/bin/bash -ex

aws s3 cp --recursive ./hosted-conf s3://shattered-secret/hosted-conf

sleep 1;

aws ec2 reboot-instances --instance-ids $(aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --filters "Name=tag:shattered,Values=janus" --output text)