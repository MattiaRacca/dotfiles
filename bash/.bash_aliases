## alias for Xresources
alias xup='xrdb ~/.Xresources'

## SSH into IDIAP workstation
# alias jurain='ssh -XC mracca@jurasix23.idiap.ch'
# alias juraout='ssh -XC mracca@login.idiap.ch'

## SSHFS into NLE scratch
alias myscratch='sshfs chaos-03:/scratch/2/user/mracca ~/Mounts/scratch'
alias mybox='sshfs box-01:/home/mracca/dwp_project ~/Mounts/dwp_project'

## Add conda kernel to jupyter, while conda kernel is active
function addjupyterkernel() {
  pip install ipykernel
  python -m ipykernel install --user --name=$CONDA_DEFAULT_ENV
}

function removejupyterkernel() {
  jupyter kernelspec uninstall $CONDA_DEFAULT_ENV
}

## Python: my minimal cookiecutter
alias mycookiecutter='cookiecutter gh:mattiaracca/python-minimal-cookiecutter'

## commands for letting know ROS where the roscore is running
alias localmaster='export ROS_MASTER_URI=http://localhost:11311'

## commands for the Franka Panda
alias pandarecover='rostopic pub -1 /franka_control/error_recovery/goal franka_control/ErrorRecoveryActionGoal "{}"'

## commands for RQT
# rqtreset: when rqt refuses to find controller that are already installed
alias rqtreset='rm ~/.config/ros.org/rqt_gui.ini && rqt'

## miscellanea
alias mkdir_now='date +%Y%m%d%H%M | xargs mkdir'
alias :q='echo This is not Vim you silly fool'
alias :w='echo This is not Vim you silly fool'
alias :wq='echo This is not Vim you silly fool'
alias jn='jupyter-notebook'
alias github='git remote get-url origin | xargs firefox'
alias re='exec bash'

## ROS "source devel/setup.bash" function that outputs a bunch of useful info
function devel() {
  orange='\033[0;33m'
  orangebold='\033[1;33m'
  reset='\033[0m'
  echo -e Sourcing the workspace $orangebold\($ROS_DISTRO\)$reset
  if [ "$ROS_VERSION" -gt 1 ]
  then
  source install/setup.bash
  echo -e ${orange}DOMAIN_ID=$ROS_DOMAIN_ID
  else
  source devel/setup.bash
  echo -e $orange$ROS_PACKAGE_PATH
  fi
}

# simple Bluetooth (dis)connect from command line
bluez () {
    declare -A list=( [sony]='04:21:44:1E:73:02' [aukey]='FC:58:FA:24:47:47' )
    pactl load-module module-bluetooth-policy &>/dev/null
    pactl load-module module-bluetooth-discover &>/dev/null

    found=false
    for value in sony aukey
    do
        if [ "$2" = $value ]; then
            found=true
        fi
    done
    if [ "$found" = true ]; then
        echo "Connecting to $2 at  ${list[$2]}..."
        if [ "$1" = con ] || [ "$1" = c ]; then
            echo -e "power on" | bluetoothctl
            sleep 3
            echo -e "connect ${list[$2]} \n exit" | bluetoothctl
        elif [ "$1" = dis ] || [ "$1" = d ]; then
            echo -e "disconnect ${list[$2]} \n power off \n exit" | bluetoothctl
        else
            echo "Unknown operation use (c)on or (d)is"
        fi
    else
        echo "Unknown device"
    fi
}

## ol' good 'mkdir foo && cd foo'
function mkcd() { mkdir -p "$@" && cd $_; }

## LaTeX Writing Environment ('cause I despise LaTeX IDEs)
function we() {
NAME="root"
RECURSIVE=false
FIGURE_FOLDER="figures"
FIGURE=false
if [ $DESKTOP_SESSION == "i3" ]; then
	i3-msg "append_layout ~/.config/i3/latex-workspace.json"
fi
for i in "$@"
do
case $i in
  -n=*|--name=*)
    NAME="${i#*=}"
    shift # past argument=value
  ;;
  -r|--recursive)
    RECURSIVE=true
    echo "Recursively opening .tex and .bib"
    shift # past argument with no value
  ;;
  -f|--figures)
    FIGURE=true
    echo "Opening .tex in $FIGURE_FOLDER"
    shift # past argument with no value
  ;;
  *)
    echo "Unknown argument $i"
    echo "Arguments are -n=main_tex (--name), -r (--recursive), and -f (--figures)"
    return
  ;;
esac
done
if [ -e "$NAME.tex" ]; then # if main tex file exists
  nohup gedit "$NAME".tex &> /dev/null &
else
  echo "$NAME.tex not found. Abort"
  return
fi
if ! [ $DESKTOP_SESSION == "i3" ]; then
	nohup nautilus . &> /dev/null &
fi
if [ -e "*.bib" ]; then
  nohup gedit "*.bib" &> /dev/null &
else
  echo "$NAME.bib not found in this folder. Maybe it is in a subfolder?"
fi
if [ -e "$NAME.pdf" ]; then # if main pdf already exists
  nohup evince "$NAME".pdf &> /dev/null &
fi
if $RECURSIVE; then # if we want to search for .tex and .bib recursively
  echo "Recursive search for .tex and .bib files (except figures)"
  find -name '*.tex' -not -path "*/$FIGURE_FOLDER/*" -exec nohup gedit {} > /dev/null +
  # + is part of 'find': it tells to execute the exec command only once for multiple finds
  find -name '*.bib' -exec nohup gedit {} > /dev/null +
fi
if $FIGURE; then # want to open .tex figures (tikz)?
  echo "Recursive search for .tex and .tikz in $FIGURE_FOLDER"
  find -name '*.tex' -path "*/$FIGURE_FOLDER/*" -exec nohup gedit {} > /dev/null +
  find -name '*.tikz' -path "*/$FIGURE_FOLDER/*" -exec nohup gedit {} > /dev/null +
fi
if [ $DESKTOP_SESSION == "i3" ]; then
  gnome-terminal &
  sleep 1
  exit
fi
}

# Override the cd builtin to do some nice things
function cd
{
	# If no arguments (change to ~)
	if [[ $# -eq 0 ]]
	then
	# Get the current repo
	local repo="$(git rev-parse --show-toplevel 2>/dev/null)"
	# If we are in a repo and we are not already in the repo root
	if [[ -n "$repo" && "$PWD" != "$repo" ]]
	then
             # Go to the repo root
             builtin cd $repo
         else
             # Pass through (go to ~)
             builtin cd "$@"
         fi
     else
         # Pass through (go to the directory specified by the argument(s))
         builtin cd "$@"
     fi
     # If we have successfully changed directory, do more magic
     if [[ $? -eq 0 ]]
     then
         # If we are now in a git repo
         if git rev-parse --show-toplevel &>/dev/null
         then
             # If the previous directory was not in the current git repo
             if ! [[ "$OLDPWD" == "$(git rev-parse --show-toplevel)"* ]]
             then
                 # We are entering a git repo: print last commit message
                 echo "Last local commit:"
                 git log -1
             fi
         fi
     fi
}

## conda styling of Command prompt
__conda_ps1 ()
{
        if [ -z "$CONDA_DEFAULT_ENV" ]; then return; fi
        local conda_env=$(basename $CONDA_DEFAULT_ENV)
        local python_version=$(python -c 'import sys; print(sys.version[0]+"."+sys.version[2:].partition(".")[0])')
        echo " [$conda_env|$python_version]"
}
