# Path & Environment
export PATH="$HOME/.dotnet/tools:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export TERM="xterm-256color"

# Non-interactive shell guard
[[ -o interactive ]] || return

# ------------------------------
# Tool Version Managers (Mise)
# ------------------------------
if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate zsh)"
fi

# ------------------------------
# Prompt (Oh My Posh)
# ------------------------------
THEME="$HOME/.theme.omp.json"
if command -v oh-my-posh >/dev/null 2>&1; then
    eval "$(oh-my-posh init zsh --config "$THEME")"
fi

# ------------------------------
# History Configurations
# ------------------------------
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# ------------------------------
# Completions & Styles
# ------------------------------
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ------------------------------
# Antidote (Plugin Manager)
# ------------------------------
# CRITICAL FIX: Antidote handles compinit for you inside 'antidote load'. 
# We call 'autoload -Uz compinit' BEFORE it so Antidote has access to it.
autoload -Uz compinit

ANTIDOTE_DIR="${ZDOTDIR:-$HOME}/.antidote"
ZPLUGINS="$HOME/.zsh_plugins.txt"

if [[ -f "$ANTIDOTE_DIR/antidote.zsh" ]]; then
    source "$ANTIDOTE_DIR/antidote.zsh"
    if [[ -f "$ZPLUGINS" ]]; then
        antidote load "$ZPLUGINS"
    fi
fi

# ------------------------------
# Keybindings & Navigation
# ------------------------------
bindkey -e

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
    [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
fi

# ------------------------------
# Aliases
# ------------------------------
alias c="clear"
alias reload="exec zsh"
alias v="code"
alias open="explorer.exe"

# ------------------------------
# Lazy-Loaded NVM (Instant Startup Speed)
# ------------------------------
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    # Creates placeholder functions that intercept node/nvm commands,
    # loads the real NVM seamlessly on first use, then passes the command through.
    nvm() {
        unset -f nvm node npm npx yarn
        \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        nvm "$@"
    }
    node() { unset -f nvm node npm npx yarn; \. "$NVM_DIR/nvm.sh"; node "$@" }
    npm()  { unset -f nvm node npm npx yarn; \. "$NVM_DIR/nvm.sh"; npm "$@"  }
    npx()  { unset -f nvm node npm npx yarn; \. "$NVM_DIR/nvm.sh"; npx "$@"  }
    yarn() { unset -f nvm node npm npx yarn; \. "$NVM_DIR/nvm.sh"; yarn "$@" }
fi
