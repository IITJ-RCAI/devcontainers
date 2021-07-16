#!/bin/bash
/usr/sbin/sshd -D -ddd -E /proc/1/fd/1 -f /scripts/sshd_config
