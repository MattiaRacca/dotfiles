### My NLE laptop

## SSHFS into NLE scratch
alias myscratch='sshfs chaos-01:/scratch/2/user/mracca ~/Mounts/scratch'
alias mybox='sshfs box-01:/home/mracca/dwp_project ~/Mounts/dwp_project'
alias myhuge='sshfs huge:/home/mracca/Projects/DynamicWaitingPose ~/Mounts/dwp_on_huge'
alias mysiple='sshfs siple:/home/mracca/Projects/DynamicWaitingPose ~/Mounts/dwp_on_siple'
alias myhugefromhome="sshfs huge:/home/mracca/Projects/DynamicWaitingPose ~/Mounts/dwp_on_huge -o ssh_command='ssh -J 10.57.0.12'"

## SSH tunnels for Tensorboard on office desktop (huge)
alias hugetb='ssh -L 16006:127.0.0.1:6006 mracca@huge'
alias hugetb_fromhome='ssh -L 16006:127.0.0.1:6006 mracca@hugefromhome'

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
