export PATH="$HOME/.local/bin:$PATH"
export TERM="xterm-256color"

[[ -o interactive ]] || return

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

THEME="$HOME/.theme.omp.json"

if command -v oh-my-posh >/dev/null 2>&1; then
  eval "$(oh-my-posh init zsh --config "$THEME")"
fi

ANTIDOTE_DIR="${ZDOTDIR:-$HOME}/.antidote"
ZPLUGINS="$HOME/.zsh_plugins.txt"

if [[ -f "$ANTIDOTE_DIR/antidote.zsh" ]]; then
  source "$ANTIDOTE_DIR/antidote.zsh"

   if [[ -f "$ZPLUGINS" ]]; then
    antidote load "$ZPLUGINS"
  fi
fi

autoload -Uz compinit

if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

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

alias c="clear"
alias reload="exec zsh"
alias v="code"
alias open="explorer.exe"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
