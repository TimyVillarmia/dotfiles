# 1. Powerlevel10k Instant Prompt (MUST be at the top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Silence the p10k warning box permanently
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# 2. Zinit Plugin Manager Setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# 3. Essential Plugins (Syntax Highlighting & Suggestions)
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light romkatv/powerlevel10k

# 4. Load the Theme Configuration (Your p10k settings)
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# 5. History Settings (Fast and efficient)
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history
setopt appendhistory
setopt sharehistory
setopt hist_ignore_dups

# 6. Optimized Aliases
alias c='clear'
alias ..='cd ..'
alias reload='source ~/.zshrc'
alias edpro='nano ~/.zshrc'
alias win='explorer.exe .'

# Windows File System Shortcuts (Fastest way to navigate)
# Replace 'timy' with your actual Windows username
alias cdc='cd /mnt/c/Users/timyv'
alias desk='cd /mnt/c/Users/timyv/Desktop'
alias docs='cd /mnt/c/Users/timyv/Documents'
alias dl='cd /mnt/c/Users/timyv/Downloads'
alias od='cd /mnt/c/Users/timyv/OneDrive'

# 7. Safe FZF Integration (No 'unknown option' errors)
if [ -f "/usr/share/doc/fzf/examples/key-bindings.zsh" ]; then
    source "/usr/share/doc/fzf/examples/key-bindings.zsh"
    source "/usr/share/doc/fzf/examples/completion.zsh"
fi

# 8. Completion Styling (Windows-style Case Insensitivity)
autoload -Uz compinit && compinit 2>/dev/null
zinit cdreplay -q
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
