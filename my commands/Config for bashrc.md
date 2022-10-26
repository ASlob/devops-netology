# System-wide .bashrc file for interactive bash(1) shells.
if [ -z "$PS1" ]; then
   return
fi

git_branch() {
  git branch 2>/dev/null | grep '^*' | colrm 1 2
}

shopt -s checkwinsize

PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\] \D{%H:%M:%S}\[\033[0;36m\] @ \[\033[0;36m\]\w\[\033[0;32m\] [$(git_branch)]\n\[\033[0;32m\]└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\] \[\033[0m\] '

[ -r "/etc/bashrc_$TERM_PROGRAM" ] && . "/etc/bashrc_$TERM_PROGRAM"