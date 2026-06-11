### Git aliases and functions
alias workgit='git config --local user.name "mattia-racca" && git config --local user.email "mattia.racca@naverlabs.com" && git config --local --list'
alias mygit='git config --local user.name "MattiaRacca" && git config --local user.email "mattia.rh@gmail.com" && git config --local --list'
gst() {
  # Recursively run git status on all git repos under current directory
  local depth="${1:-2}"

  # Find directories up to given depth containing a .git folder
  while IFS= read -r repo; do
    echo -e "\n\033[1;34m=== $(basename "$repo") ===\033[0m"
    (cd "$repo" && git status -s)
  done < <(find . -maxdepth "$depth" -type d -name ".git" -prune | sed 's|/.git||')
}

### Conda aliases and functions
alias cel='conda env list'
addjupyterkernel() {
  pip install ipykernel
  python -m ipykernel install --user --name=$CONDA_DEFAULT_ENV
}
removejupyterkernel() {
  jupyter kernelspec uninstall $CONDA_DEFAULT_ENV
}

### Python aliases and functions
alias newpythonproject='cookiecutter gh:mattiaracca/python-minimal-cookiecutter'

### Miscellanea aliases and functions
alias mkdir_now='date +%Y%m%d%H%M | xargs mkdir'
alias :q='echo This is not Vim you silly fool'
alias :w='echo This is not Vim you silly fool'
alias :wq='echo This is not Vim you silly fool'
alias re='exec bash'
alias clear='clear -x'
function mkcd() { mkdir -p "$@" && cd $_; }
function psgrep() {
  ps aux | grep $1
}
function duh() {
  ## pretty disk usage function
  local dir=${1:-.}
  local blue='\033[0;34m'
  local green='\033[0;32m'
  local nc='\033[0m' # No Color

  # Get the disk usage and format it
  du -ah --max-depth=1 "$dir" | while read size item; do
    if [ -d "$item" ]; then
      echo -e "${blue}${size}\t${item}${nc}"
    else
      echo -e "${green}${size}\t${item}${nc}"
    fi
  done
}

# dyslexia helpers
alias clera=clear
alias celar=clear
alias sl='ls'
alias exot='exit'

## ROS aliases and functions
function devel() {
  # "source devel/setup.bash" function that outputs a bunch of useful info
  orange='\033[0;33m'
  orangebold='\033[1;33m'
  reset='\033[0m'
  echo -e Sourcing the workspace $orangebold\($ROS_DISTRO\)$reset
  if [ "$ROS_VERSION" -gt 1 ]
  then
  source install/setup.bash
  echo -e ${orange}DOMAIN_ID=$ROS_DOMAIN_ID
  echo -e ${orange}RMW_IMPLEMENTATION=$RMW_IMPLEMENTATION
  else
  source devel/setup.bash
  echo -e $orange$ROS_PACKAGE_PATH
  fi
}

function rosup () {
  source /opt/ros/$ROS_DISTRO/setup.bash

  # for colcon_cd
  source /usr/share/colcon_cd/function/colcon_cd.sh
  export _colcon_cd_root=/opt/ros/$ROS_DISTRO/

  # for colcon autocompletion
  source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash

  # echo to confirm
  orange='\033[0;33m'
  orangebold='\033[1;33m'
  reset='\033[0m'
  echo -e $orangebold$ROS_DISTRO$reset ACTIVE
}

alias cbd='colcon build && devel'

function viewtf() {
  # ros2 run tf2_tools viewframes
  orangebold='\033[1;33m'
  reset='\033[0m'
  if [ -z "$ROS_DISTRO" ]
  then
    echo -e $orangebold\ROS is not up!$reset
  else
    cd /tmp
    ros2 run tf2_tools view_frames -o frames
    evince frames.pdf >/dev/null &
    cd - >/dev/null
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
