#!/bin/bash
/usr/sbin/sshd -D -ddd
read -n 1 -s -r -p "Press any key to continue"
