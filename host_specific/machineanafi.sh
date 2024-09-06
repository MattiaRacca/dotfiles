### My NLE laptop

## NLE Docker Repo
export NLEREPO=docker.int.europe.naverlabs.com:5000

## ROS2
rosup () {
    source /opt/ros/humble/setup.bash
    export ROS_DOMAIN_ID=55

    # for colcon_cd
    source /usr/share/colcon_cd/function/colcon_cd.sh
    export _colcon_cd_root=/opt/ros/$ROS_DISTRO/

    # for colcon autocompletion
    source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash

    # GAZEBO
    export GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:$HOME/elevator_ws/install/elevator_sim/share/elevator_sim/resource/models:$HOME/elevator_ws/install/around_description/share
}

## SSHFS into NLE machines
easymounts() {
    # Define default variables
    remote_user=""
    remote_host=""
    remote_dir=""
    local_mount_point=""
    
    # Parse the mount name and other options
    mount_name=""
    from_home_flag=0
    mount_points_folder="~/Mounts"
    available_mounts=("siple" "d005sarn" "huge")

    while [[ "$1" != "" ]]; do
        case $1 in
            -m| --mount)
                shift
                mount_name=$1
                ;;
            -r| --remote)
                from_home_flag=1
                ;;
            -a| --available )
                echo "Available mount names:"
                for mount in "${available_mounts[@]}"; do
                    echo "  - $mount"
                done
                return 0
                ;;
            * )
                echo "Invalid option: $1"
                return 1
                ;;
        esac
        shift
    done

    if [[ -z "$mount_name" ]]; then
        echo "No mount specified. Please specify a mount name with --mount"
        echo "Available mount names:"
        for mount in "${available_mounts[@]}"; do
            echo "  - $mount"
        done
        return 1
    fi

    # Set variables based on the mount_name
    case $mount_name in
        siple )
            remote_user="mracca"
            remote_host="siple"
            remote_dir="/home/mracca/Projects/DynamicWaitingPose"
            local_mount_point="/dwp_on_siple"
            ;;
        d005sarn )
            remote_user="around"
            remote_host="d005"
            remote_dir="/home/around/sarn_temp"
            local_mount_point="/sarn_temp"
            ;;
        huge )
            remote_user="mracca"
            remote_host="huge"
            remote_dir="/home/mracca/Projects/DynamicWaitingPose"
            local_mount_point="/dwp_on_huge"
            ;;
        * )
            echo "Unknown mount name: $mount_name"
            echo "Available mount names:"
            for mount in "${available_mounts[@]}"; do
                echo "  - $mount"
            done
            return 1
            ;;
    esac

    # Build the SSHFS command
    sshfs_cmd="sshfs ${remote_user}@${remote_host}:${remote_dir} ${mount_points_folder}${local_mount_point}"
    sshfs_extra_jump="-o ssh_command='ssh -J 10.57.0.12'"

    # Append reconnect option if -r is passed
    if [[ $from_home_flag -eq 1 ]]; then
        sshfs_cmd="${sshfs_cmd} ${sshfs_extra_jump}"
    fi

    # Execute the SSHFS command
    echo "Executing: $sshfs_cmd"
    eval "$sshfs_cmd"
}

## SSH tunnels for Tensorboard on NLE machines
tensortunnel () {
    hostname=""
    username="mracca"
    from_home_append="fromhome"
    from_home_flag=0

    # Check if the first argument is the -r flag
    if [ "$1" == "-r" ]; then
        from_home_flag=1
        shift
        # Now check for the required string (which is the next argument)
        if [ -z "$1" ]; then
            echo "Error: hostname must be specified."
            return 1
        else
            hostname="$1"
        fi
    else
        hostname="$1"
        shift
        # Now check for the required string (which is the next argument)
        if [ "$1" == "-r" ]; then
            from_home_flag=1
            shift
        fi
    fi
    
    tunnel_cmd="ssh -L 16006:127.0.0.1:6006 ${username}@${hostname}"

    if [[ $from_home_flag -eq 1 ]]; then
        tunnel_cmd=${tunnel_cmd}${from_home_append}
    fi
    echo "Running $tunnel_cmd"
    eval "$tunnel_cmd"
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
