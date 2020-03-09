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

## commands for the Franka Panda
alias pandarecover='rostopic pub -1 /franka_control/error_recovery/goal franka_control/ErrorRecoveryActionGoal "{}"'

## commands for RQT
# rqtreset: when rqt refuses to find controller that are already installed
alias rqtreset='rm ~/.config/ros.org/rqt_gui.ini && rqt'

## CLION shortcut
alias clion='~/clion/bin/clion.sh'

## miscellanea
alias mkdir_now='date +%Y%m%d%H%M | xargs mkdir'
alias :q='echo This is not Vim you silly fool'
alias :w='echo This is not Vim you silly fool'
alias :wq='echo This is not Vim you silly fool'
alias jn='jupyter notebook'
alias svnup='svn up && svn log -l 3'
alias svnst='svn st'
alias svndiff='svn diff | colordiff'
alias devel='source devel/setup.bash && echo $ROS_PACKAGE_PATH'

## quality of life functions
# ol' good 'mkdir foo && cd foo'
mkcd() { mkdir -p "$@" && cd $_; }

## LaTeX Writing Environment ('cause I despise LaTeX IDEs)
function we() {
NAME="root"
RECURSIVE=false
FIGURE_FOLDER="figures"
FIGURE=false
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
nohup nautilus . &> /dev/null &
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
}
