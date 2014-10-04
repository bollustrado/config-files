#!/bin/bash

set -e

ROOT="/home/shark/.cf/.nwlook"
OLD="$ROOT/old"
NEW="$ROOT/new"

CMD="avahi-browse -t -a | grep --color --color=never IPv4 | grep --color -v LaserJet | grep --color -v KONICA"

if [[ $1 == "-remote" ]]; then
    # the option -n prevents ssh from using stdin,
    # allowing us to run it in the background
    CMD="ssh -n peter@sultan -t '$CMD'"
fi

aBrowse() {
    eval "$CMD" > "$NEW" 2> /dev/null
}

aBrowse

while true; do
    cp "$NEW" "$OLD"
    aBrowse
    DIFF="$(diff -q "$OLD" "$NEW")"
    if [[ ! -z $DIFF ]]; then
        gxmessage -buttons "Beenden:0,Ok:1" -center -borderless -geometry 600x400 "$(diff $OLD $NEW)"
        if [[ $? -eq 0 ]]; then
            exit
        fi
    fi
    sleep 60
done
