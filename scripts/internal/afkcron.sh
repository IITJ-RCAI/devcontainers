#!/bin/bash

# Take arguments, in seconds
TIMEOUT=${AFK_TIMEOUT_SECONDS:-300}
CHECK_INTERVAL=${AFK_CHECK_INTERVAL_SECONDS:-60}

# https://stackoverflow.com/a/53122736/10027894
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure gracefull termination
# https://stackoverflow.com/a/47238538/10027894
finish() {
    echo "AFK timer stopped."
    kill $!
    exit
}
trap finish SIGINT SIGTERM

echo "AFK timer started."
while :
do
    # Check active ssh sessions
    COUNT=$(pgrep -afic "sshd: micromamba@")
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
    sleep $CHECK_INTERVAL &
    wait
done