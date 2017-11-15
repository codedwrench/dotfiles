alias off='systemctl poweroff'
alias reb='systemctl reboot'
alias susp='systemctl suspend'
alias hiber='systemctl hibernate'

alias ls='ls --color'
alias la='ls -a'
alias ll='ls -l'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias sudo='sudo '

alias clera='clear'
alias sduo='sudo '
alias suod='sudo '

alias feh='feh --scale-down'

alias bat='upower -i $(upower -e | grep BAT) | grep --color=never -E "state|to\ full|to\ empty|percentage"'
alias tim='date +%H:%M'

alias sc="sudo systemctl"
alias scr="sudo systemctl restart"
alias sce="sudo systemctl enable"
alias scdr="sudo systemctl daemon-reload"
alias scs="sudo systemctl stop"
alias scst="sudo systemctl status -l"
alias scd="sudo systemctl disable"

alias gdiff="git difftool --dir-diff HEAD~ HEAD"
alias glog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gcheck="git checkout ."
alias gres="git reset --hard HEAD"
alias gpush="git push"
alias gpull="git pull"
alias gclone="git clone"
alias gcomm="git commit"

alias proj="cd $HOME/projects/SmartMarkers"
alias closelid='systemd-inhibit --what=handle-lid-switch sleep 1d'
alias mountusb='sudo mount /dev/sdb1 /mnt/usb -o uid=1000,gid=1000'
alias ht='sudo htop'
