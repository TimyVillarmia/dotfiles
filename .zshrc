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

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

mkdir -p ~/.zsh/cache

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

if [[ -f "$HOME/.zsh_plugins.zsh" ]]; then
    source "$HOME/.zsh_plugins.zsh"
fi

if [[ -f "$HOME/.cache/omp-init.zsh" ]]; then
    source "$HOME/.cache/omp-init.zsh"
fi

bindkey -e

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --zsh)"
fi

alias c="clear"
alias reload="exec zsh"
alias v="code"
alias open="explorer.exe"

export NVM_DIR="$HOME/.nvm"

if [[ -s "$NVM_DIR/nvm.sh" ]]; then

    __load_nvm() {
        unset -f nvm node npm npx yarn pnpm
        source "$NVM_DIR/nvm.sh"

        [[ -s "$NVM_DIR/bash_completion" ]] && \
            source "$NVM_DIR/bash_completion"
    }

    nvm() {
        __load_nvm
        nvm "$@"
    }

    node() {
        __load_nvm
        node "$@"
    }

    npm() {
        __load_nvm
        npm "$@"
    }

    npx() {
        __load_nvm
        npx "$@"
    }

    yarn() {
        __load_nvm
        yarn "$@"
    }

    pnpm() {
        __load_nvm
        pnpm "$@"
    }
fi
