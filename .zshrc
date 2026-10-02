[[ -o interactive ]] || return

# Environment

typeset -U path PATH

path=(
    "$HOME/.local/bin"
    "$HOME/.dotnet/tools"
    $path
)

export PATH
export EDITOR="code --wait"

# History

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_FIND_NO_DUPS
setopt HIST_VERIFY

# Tool Initialization

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

# Plugins

if [[ -f "$HOME/.zsh_plugins.zsh" ]]; then
    source "$HOME/.zsh_plugins.zsh"
fi

# Completion

mkdir -p "$HOME/.cache/zsh"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list \
    'm:{a-z}={A-Z}' \
    'r:|=*' \
    'l:|=*'

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh"

# fzf

if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

# zoxide

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# Prompt

if [[ -f "$HOME/.cache/omp-init.zsh" ]]; then
    source "$HOME/.cache/omp-init.zsh"
fi

# Aliases

alias c="clear"
alias reload="source ~/.zshrc"

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
