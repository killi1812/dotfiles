# exports 
export PATH=/home/fran/go/bin/:$PATH
export ZSH="/usr/share/oh-my-zsh/"
export SSH_ENV="$HOME/.ssh/ssh-agent-environment"

#functions
start_ssh_agent() {
  #  TODO add later
#  eval "$(ssh-agent -s)" > "$SSH_ENV"
}

ZSH_THEME="refined"
source $ZSH/oh-my-zsh.sh
USE_POWERLINE="true"
HAS_WIDECHARS="false"

#evals
eval "$(zoxide init --cmd cd zsh)"
eval "$(atuin init zsh)"

#if [ -f "$SSH_ENV" ]; then
#  . "$SSH_ENV" > /dev/null
#  if ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
#    start_ssh_agent
#  fi
#else
#  start_ssh_agent
#fi

# alias
alias git-push='
function _git_push_check() {
    if ! ssh-add -l | grep -q "Your SSH key comment or filename"; then
        ssh-add ~/.ssh/github_ed25519 
    fi

    git push
}; _git_push_check'

