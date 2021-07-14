#!/bin/bash

# Take arguments, in seconds
TIMEOUT=${1:-300}
CHECK_INTERVAL=${2:-60}

# https://stackoverflow.com/a/53122736/10027894
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

while :
do
    # Check active tmux sessions
    COUNT=$(tmux ls | wc -l)
    if [[ $COUNT == 0 ]]
    then
        # Check if elapsed time greater than timeout
        # https://unix.stackexchange.com/a/314372
        if (( $SECONDS > $TIMEOUT ))
        then
            echo Idle timeout of $TIMEOUT seconds reached. Shutting down.
            source ${__dir}/shutdown.sh
        fi
    else
        # Reset timer since some tmux session is active
        SECONDS=0
    fi
    sleep $CHECK_INTERVAL
done