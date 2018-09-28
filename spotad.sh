#!/bin/bash
IFS=$'\n'
windows=($(wmctrl -l -p))
program="spotify"
music_token=" - " #as oppose to ad_token
current_state=$(amixer get Master | egrep 'Playback.*?\[o' | egrep -o '\[o.+\]')

#Find card number with `arecord -l`. Using 0 by default.
#open mode
open_sound () {
    if [[ $current_state != '[on]' ]]; then
        sleep 1 #wait for ad to finish
        amixer set Master unmute
        amixer set Front unmute
        amixer set Headphone unmute
        amixer set Speaker unmute
    fi
}

#close mode
close_sound () {
    if [[ $current_state == '[on]' ]]; then
        amixer set Master mute
    fi
}

for i in "${windows[@]}"
do
    :
    #Get program name from pid
    pid=$(echo $i | awk '{ print $3 }')
    pid_result=$(ps -o cmd= -p $pid)

    #Check if spotify is used
    if [[ $pid_result = *"$program"* ]]; then
        #Check spotify window name for ads
        if [[ ($i = *"$music_token"*) || ($i != "Spotify") ]]; then
            open_sound
        else
            close_sound
        fi
        break
    fi 
done
