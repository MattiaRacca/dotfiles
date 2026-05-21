### NLE HRI Desktop
purplebold="\[\033[1;35m\]"
export PS1="$purplebold\u@HUGE$green\$(__git_ps1)$greenbold\$(__conda_ps1) $blue\W $reset"

## ROS2
export ROS_DOMAIN_ID=25
export ROS_DISTRO=humble
# GAZEBO
export TURTLEBOT3_MODEL=waffle
export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/opt/ros/$ROS_DISTRO/share/turtlebot3_gazebo/models:$HOME/elevator_ws/install/elevator_sim/share/elevator_sim/resource/models:$HOME/elevator_ws/install/around_description/share
    
## CONDA
# >>> conda initialize >>>
__conda_setup="$('/home/$USER/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/$USER/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/$USER/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH=$PATH:"/home/$USER/miniconda3/bin"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
