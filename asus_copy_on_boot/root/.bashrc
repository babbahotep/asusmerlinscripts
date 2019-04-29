sshx() {
    /usr/bin/ssh -i ~/.ssh/id_rsa "$@"
}
export -f sshx

alias ls="ls -al"
alias ll="ls -dne"
#alias sshx="ssh -i ~/.ssh/id_rsa"
alias s120="sshx root@192.168.1.120"
alias s140="sshx root@192.168.1.130"
alias s140="sshx root@192.168.1.140"
alias p="ping $1"

