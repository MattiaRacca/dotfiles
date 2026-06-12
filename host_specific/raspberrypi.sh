
# temperature of CPU -- one-liner
alias cputemp='head -n 1 /sys/class/thermal/thermal_zone0/temp | xargs -I{} awk "BEGIN {printf \"%.2f\n\", {}/1000}"'
alias start-mopidy='nohup mopidy >> /home/pi/.data/mopidy/mopidy.log 2>&1 &'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/pi/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/pi/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/pi/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/pi/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
