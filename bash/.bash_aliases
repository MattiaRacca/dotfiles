## ssh command to the COb computers as admin
alias b1='ssh -XC robot@cob4-8-b1'
alias t1='ssh -XC robot@cob4-8-t1'
alias t2='ssh -XC robot@cob4-8-t2'
alias t3='ssh -XC robot@cob4-8-t3'
alias s1='ssh -XC robot@cob4-8-s1'
alias h1='ssh -XC robot@cob4-8-h1'

## commands for letting know ROS where the roscore is running
alias cobmaster='export ROS_MASTER_URI=http://cob4-8-b1:11311'
alias localmaster='export ROS_MASTER_URI=http://localhost:11311'

## miscellanea
alias mkdir_now='date +%Y%m%d%H%M | xargs mkdir'
alias :q='echo This is not Vim you silly fool'
alias :w='echo This is not Vim you silly fool'
alias :wq='echo This is not Vim you silly fool'
alias jn='jupyter notebook'
alias svnup='svn up && svn log -l 3'
alias clean='make clean'

## quality of life functions
mkcd() { mkdir -p "$@" && cd $_; }

## writing environment function
we()
{
nohup gedit ./*.tex ./*.bib >/dev/null &
nautilus .
evince ./*.pdf &
clear
}
