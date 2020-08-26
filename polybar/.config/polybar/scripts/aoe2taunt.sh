#!/bin/bash

## Created By Mattia Racca
# Taunts from https://ageofempires.fandom.com/wiki/Taunts

TAUNT="$(rofi -dmenu -i -p '' -location 2 -width 3 -lines 0)"

if [[ "$TAUNT" == "h" ]]; then
  HELP="Available taunts: "

  IFS=$'\t'  # to use the tab of ls as a
  AVAILABLE=`ls ~/.config/polybar/sounds/aoe2taunts/ | xargs -n 1 basename -s ".ogg" | sort -g`
  AVAILABLE="${AVAILABLE//$'\n'/  }"
  rofi -e "$HELP$AVAILABLE"
fi

TAUNTFILE=~/.config/polybar/sounds/aoe2taunts/"$TAUNT".ogg
if [[ -f $TAUNTFILE ]]; then
    mpv $TAUNTFILE &> /dev/null
fi
