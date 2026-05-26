source /etc/proxyrc

yellow="\[\e[1;93m\]"
export PS1="$yellow\u@\h$green\$(__git_ps1)$greenbold\$(__conda_ps1) $blue\W $reset"

alias sls='/usr/bin/PYTHON314 /home/$USER/dotfiles/submodules/slurm-tools/status.py'
tb() {
    conda activate tb
    tensorboard serve --port=0 --host=$FULL_HOSTNAME "$@"
    conda deactivate
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
