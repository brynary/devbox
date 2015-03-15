SSH_ENV="$HOME/.ssh/environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

export CLICOLOR=1
export LSCOLORS=gxfxcxdxbxegedabagacad
export HISTCONTROL=ignoredups

export GIT_PS1_SHOWDIRTYSTATE=1

source /etc/bash_completion.d/git-prompt
export PS1='\n$(if [ $? = 0 ]; then echo "\[\033[0;32m\]☺"; else echo "\[\033[0;31m\]☹"; fi) \[\033[01;36m\]\w \[\033[01;35m\]$(__git_ps1 "(%s)")\n\[\033[01;32m\] [devbox \t] \[\033[01;36m\]$\[\033[00m\] '

if [ -f /usr/local/etc/bash_completion ]; then
  source /usr/local/etc/bash_completion
fi

complete -o default -o nospace -F _git_checkout gco

alias top="top -ocpu"
alias fsizes="du -h -d 0 ./*"

alias ..="cd .."
alias ...="cd .. && cd .."
alias ....="cd .. && cd .. && cd .."

# ls
alias ls='ls -alFG'
alias ll='ls -alFG'
alias l='ls -alFG'

alias pwgen='dd if=/dev/urandom count=1 bs=48 2>/dev/null|uuencode -m -|tail -2|head -1'

# show difference between the HEAD and the index
alias staged="git diff --cached"

# show difference between working tree and the index
alias unstaged="git diff"

alias r="rake"
alias gdi="git diff"
alias gb="git branch -v"
alias gba="git branch -av"
alias gs="git status"
alias gst="git status"
alias gpr="git pull --rebase"
alias push="git push"
alias gco="git checkout"
alias gcm="git checkout master"
alias gc="git commit -v"
alias gpc="git-pair commit -v"
alias gam="git commit -v --amend"
alias grb="git rebase -i HEAD~10"
alias gca="git commit -a -v"
alias gpca="git-pair commit -a -v"
alias gitrmall='git ls-files --deleted|xargs git rm'

alias b="bundle exec"
