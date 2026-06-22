[[ -o interactive ]] || return

typeset -U path PATH

path=(
    "$HOME/.local/bin"
    "$HOME/.dotnet/tools"
    $path
)

export PATH

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

mkdir -p ~/.zsh/cache

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

if [[ -f "$HOME/.zsh_plugins.zsh" ]]; then
    source "$HOME/.zsh_plugins.zsh"
fi

if [[ -f "$HOME/.cache/omp-init.zsh" ]]; then
    source "$HOME/.cache/omp-init.zsh"
fi

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

export EDITOR="code --wait"

alias c="clear"
alias reload="exec zsh"
alias v="code"
alias open="explorer.exe"

alias ll="ls -lah"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"

alias d="docker"
alias dc="docker compose"

alias k="kubectl"


