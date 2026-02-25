# --- Path & Environment ---
export PATH="$HOME/.local/bin:$HOME/.bun/bin:$PATH"
export TERM="xterm-256color"

# --- Oh My Posh (Takuya Theme) ---
# We use the version tracked in your yadm dotfiles
THEME_FILE="$HOME/.takuya.omp.json"

if command -v oh-my-posh >/dev/null; then
    eval "$(oh-my-posh init zsh --config "$THEME_FILE")"
fi

# --- Plugin Manager (Zinit) ---
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ ! -d "$ZINIT_HOME" ]] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

# --- History & Completion ---
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt sharehistory
setopt hist_ignore_dups
setopt hist_ignore_space

autoload -Uz compinit && compinit 2>/dev/null
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 
zstyle ':completion:*' menu select

# --- Keybindings & FZF ---
bindkey -e
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

[[ -f /usr/share/fzf/shell/key-bindings.zsh ]] && source /usr/share/fzf/shell/key-bindings.zsh

# --- Navigation & Aliases ---
# Initializing zoxide for the 'z' command
eval "$(zoxide init zsh)"

alias y="yadm"
alias v="code"
alias c="clear"
alias update="sudo dnf upgrade"
alias reload="source ~/.zshrc"
alias edpro="code ~/.zshrc"
alias open="kioclient exec"
alias dolphin="dolphin . & disown"

