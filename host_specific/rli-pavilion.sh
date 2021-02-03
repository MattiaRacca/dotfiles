### My Idiap laptop

export TERMINFO=/usr/share/terminfo

if [ -f /opt/ros/melodic/setup.bash ]; then
    source /opt/ros/melodic/setup.bash
else
    echo "Where is ROS melodic?"
fi

# >>> conda initialize >>>
__conda_setup="$('/home/raccam/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/raccam/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/raccam/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/raccam/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
