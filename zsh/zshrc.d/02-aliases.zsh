alias kc="kubectl"
alias kce="kubectl get events --sort-by='{.lastTimestamp}'"
alias ky="kubectl -oyaml"
alias durl='curl -sSD- -o /dev/null -H "X-debug: true"'
alias hurl='curl -sSD- -o /dev/null'
alias ll="ls -l"

source /opt/google-cloud-cli/path.zsh.inc
source /opt/google-cloud-cli/completion.zsh.inc
