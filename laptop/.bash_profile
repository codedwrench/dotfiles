# /etc/skel/.bash_profile

# This file is sourced by bash for login shells.  The following line
# runs your .bashrc and is recommended by the bash info pages.
[[ -f ~/.bashrc ]] && . ~/.bashrc
#Startx Automatically
[[ $(tty) = "/dev/tty1" ]] && exec startx


export QSYS_ROOTDIR="/home/codedwrench/altera_lite/15.1/quartus/sopc_builder/bin"

export ALTERAOCLSDKROOT="/home/codedwrench/altera_lite/15.1/hld"
