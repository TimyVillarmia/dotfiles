# Path & Environment
export PATH="$HOME/.local/bin:$PATH"
export TERM="xterm-256color"

# ------------------------------
# Oh My Posh (Takuya Theme)
# ------------------------------
THEME_FILE="$HOME/.takuya.omp.json"
if command -v oh-my-posh >/dev/null; then
    eval "$(oh-my-posh init zsh --config "$THEME_FILE")"
fi

# ------------------------------
# Zinit (plugin manager)
# ------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ -f "$ZINIT_HOME/zinit.zsh" ]] && source "$ZINIT_HOME/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

# ------------------------------
# History & Completion
# ------------------------------
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt sharehistory
setopt hist_ignore_dups
setopt hist_ignore_space

autoload -Uz compinit && compinit 2>/dev/null
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select

# ------------------------------
# Keybindings & FZF
# ------------------------------
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

[[ -f /usr/share/fzf/shell/key-bindings.zsh ]] && source /usr/share/fzf/shell/key-bindings.zsh

# ------------------------------
# Navigation & Aliases
# ------------------------------
eval "$(zoxide init zsh)"

alias c="clear"
alias update="sudo dnf upgrade"
alias reload="source ~/.zshrc"
alias edpro="code ~/.zshrc"
alias v="code"
alias open="kioclient exec"
alias dolphin="dolphin . & disown"


