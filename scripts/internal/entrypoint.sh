#!/bin/bash

# Fork for afktimer env. config
afktimer_config() {
   sleep 5
   if [[ -z "${AFK_TIMER_DISABLE}" ]]; then
        source /scripts/afktimer.sh on
    else
        source /scripts/afktimer.sh off
   fi
}
afktimer_config &

# Run supervisord
/usr/bin/supervisord
