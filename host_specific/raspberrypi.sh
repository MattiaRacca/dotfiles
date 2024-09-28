
# temperature of CPU -- one-liner
alias cputemp='head -n 1 /sys/class/thermal/thermal_zone0/temp | xargs -I{} awk "BEGIN {printf \"%.2f\n\", {}/1000}"'
alias start-mopidy='nohup mopidy >> /home/pi/.data/mopidy/mopidy.log 2>&1 &'
