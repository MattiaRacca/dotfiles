# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

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

# SVN Aliases - used by the changes in prompt
parse_svn_branch() {
    parse_svn_url | sed -e 's#^'"$(parse_svn_repository_root)"'##g' | awk '{print " (SVN)" }'
}

parse_svn_url() {
  svn info 2>/dev/null | sed -ne 's#^URL: ##p'
}
parse_svn_repository_root() {
  svn info 2>/dev/null | sed -ne 's#^Repository Root: ##p'
}

# Enable tab completion
source ~/.git-completion.bash

# colors!
green="\[\033[0;32m\]"
greenbold="\[\033[1;32m\]"
blue="\[\033[0;34m\]"
bluebold="\[\033[1;34m\]"
purple="\[\033[0;35m\]"
reset="\[\033[0m\]"

__conda_ps1 ()
{
        if [ -z "$CONDA_DEFAULT_ENV" ]; then return; fi
        local conda_env=$(basename $CONDA_DEFAULT_ENV)
        local python_version=$(python -c 'import sys; print(sys.version[0]+"."+sys.version[2])')
        echo " [$conda_env|$python_version]"
}

# Change Command prompt
source ~/.git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
# '\u' adds the name of the current user to the prompt
# '\$(__git_ps1)' adds git-related stuff
# '\W' adds the name of the current directory
# export PS1="$bluebold\u$green\$(__git_ps1)$blue \W $ $reset"
export PS1="$bluebold\u$green\$(__git_ps1)\$(parse_svn_branch)$greenbold\$(__conda_ps1) $blue\W $reset"

## Set default text editor
export EDITOR='vim'

## Which computer am I using?
case $HOSTNAME in
    (tp-raccam)
        ### My Aalto laptop
        ## NAO robot configs
        export PYTHONPATH=/home/$USER/Libraries/naoqi/pynaoqi-python2.7-2.1.4.13-linux64:$PYTHONPATH
        export AL_DIR=/home/$USER/Libraries/naoqi/naoqi-sdk-2.1.4.13-linux64
        ## Care-O-bot configs
        export ROBOT=cob4-8
        export ROBOT_ENV=ipa-apartment
        ## Source ROS environments
        if [ -f /opt/ros/kinetic/setup.bash ]; then
            source /opt/ros/kinetic/setup.bash
        else
            echo "Where is ROS kinetic?"
        fi
        ## CAAL module
        # export PYTHONPATH=/home/$USER/caal:$PYTHONPATH
        ## RAL module
        export PYTHONPATH=/home/$USER/panda_ws/src/range_al:$PYTHONPATH;;
    (mrh-acer)
        ### My old personal laptop
        ;;
    (legion)
        ### My personal laptop
        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
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
        ;;
    (rli-pavilion)
        ### My Idiap laptop
        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
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
        ;;
    (mrh-pocket)
        ### My small resurrected ASUS
        ;;
    (LumiThinkCentre)
        ## Panda pc @ IR Lab
        ## Source ROS environments
        if [ -f /opt/ros/kinetic/setup.bash ]; then
            source /opt/ros/kinetic/setup.bash
        else
            echo "Where is ROS kinetic?"
        fi
        ## Export Panda IP
        export ROBOT_IP=172.16.0.2
        ## RAL module
        export PYTHONPATH=/home/$USER/panda_ws/src/range_al:$PYTHONPATH;;
    (*)
        echo "Where the fuck am I?"
        ;;
esac


