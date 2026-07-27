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

# Completion

mkdir -p "$HOME/.cache/zsh"

autoload -Uz compinit

ZCOMPDUMP="$HOME/.cache/zsh/.zcompdump"

if [[ ! -f "$ZCOMPDUMP" || "$ZCOMPDUMP" -nt "$HOME/.zshrc" ]]; then
    compinit -d "$ZCOMPDUMP"
else
    compinit -C -d "$ZCOMPDUMP"
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list \
    'm:{a-z}={A-Z}' \
    'r:|=*' \
    'l:|=*'

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh"

# Tool Initialization

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
