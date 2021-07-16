#!/bin/bash
if [[ -z "${SSHD_DEBUG}" ]]; then
    /usr/sbin/sshd -D -E /proc/1/fd/1 -f /scripts/sshd_config
else
    /usr/sbin/sshd -D -ddd -E /proc/1/fd/1 -f /scripts/sshd_config
fi