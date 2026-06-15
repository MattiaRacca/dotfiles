### My NLE laptop

## NLE Docker Repo
export NLEREPO=docker.int.europe.naverlabs.com:5000

## ROS2
export ROS_DISTRO=jazzy

## Tuxedo (on trial)
export TODO_DIR="$HOME/Dropbox/todo"
function todo() { ~/.cargo/bin/tuxedo "$@"; }

## Navi (on trial)
export PATH="${PATH}:~/.cargo/bin"
export NAVI_PATH="~/dotfiles/cheats"
source <(navi widget bash)


## Easy SSHFS into machines
easymounts() {
    # Define default variables
    remote_user=""
    remote_host=""
    remote_dir=""
    local_mount_point=""
    # Parse the mount name and other options
    mount_name=""
    mount_points_folder="~/Mounts"
    available_mounts=("homepi" "scratch" "fmnavdata" "fmnavout")

    while [[ "$1" != "" ]]; do
        case $1 in
            -m| --mount)
                shift
                mount_name=$1
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
        echo "No mount specified. Please specify a mount name with -m"
        echo "Available mount names:"
        for mount in "${available_mounts[@]}"; do
            echo "  - $mount"
        done
        return 1
    fi

    # Set variables based on the mount_name
    case $mount_name in
        homepi )
            remote_user="pi"
            remote_host="192.168.1.194"
            remote_dir="/home/pi/Sharedrive"
            local_mount_point="/raspberrypi_sharedrive"
            ;;
        scratch )
            remote_user="mracca"
            remote_host="chaos-06"
            remote_dir="/beegfs/scratch/user/mracca"
            local_mount_point="/scratch"
            ;;
        fmnavdata )
            remote_user="mracca"
            remote_host="chaos-06"
            remote_dir="/beegfs/scratch/data/habitat"
            local_mount_point="/home/mracca/Projects/fm-nav-habitat/data"
            mount_points_folder=""
            ;;
        fmnavout )
            remote_user="mracca"
            remote_host="chaos-06"
            remote_dir="/beegfs/scratch/user/mracca/fm-nav/out"
            local_mount_point="/fm-nav-out"
            ;;
        * )
            echo "Unknown mount name: $mount_name"
            echo "Available mount names:"
            for mount in "${available_mounts[@]}"; do
                echo "  - $mount"
            done
            echo "Otherwise: sshfs <user>@<host>:<remote_dir> <local_mount_point>"
            return 1
            ;;
    esac

    # Build the SSHFS command
    sshfs_cmd="sshfs ${remote_user}@${remote_host}:${remote_dir} ${mount_points_folder}${local_mount_point}"

    # Execute the SSHFS command
    echo "Executing: $sshfs_cmd"
    eval "$sshfs_cmd"
}

export -f easymounts

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
