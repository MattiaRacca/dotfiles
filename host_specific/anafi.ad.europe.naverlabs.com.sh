### My NLE laptop

## ROS2
function rosup () {
    source /opt/ros/foxy/setup.bash
    export ROS_DOMAIN_ID=25

    # for colcon_cd
    source /usr/share/colcon_cd/function/colcon_cd.sh
    export _colcon_cd_root=/opt/ros/$ROS_DISTRO/

    # for colcon autocompletion
    source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash

    # GAZEBO
    export TURTLEBOT3_MODEL=waffle
    export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:/opt/ros/$ROS_DISTRO/share/turtlebot3_gazebo/models:$HOME/elevator_ws/src/elevator_sim/navbot_simulation/models
}

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
