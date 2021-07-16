#!/bin/bash

if [[ $1 == "on" ]]
then
    echo "Starting afktimer..."
    supervisord ctl start afkcron
elif [[ $1 == "off" ]]
then
    echo "Stopping afktimer..."
    supervisord ctl stop afkcron
else
    echo "Usage: afktimer.sh <on/off>"
fi
