# 1. Powerlevel10k Instant Prompt
# Helps the terminal open instantly even with many plugins.
[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

# 2. Zinit Plugin Manager (Automated Setup)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ ! -d "$ZINIT_HOME" ]] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# 3. Essential Plugins (Syntax highlighting & Suggestions)
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light romkatv/powerlevel10k

# 4. Load Theme Configuration
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# 5. History Settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt sharehistory          # Share history between different terminals
setopt hist_ignore_dups      # Don't record the same command twice in a row
setopt hist_ignore_space     # Don't record commands starting with a space

# 6. Keybindings (The "npm + Up Arrow" logic)
# Standard Emacs-style keys
bindkey -e 

# Use terminfo to ensure Up/Down work correctly in Fedora Konsole
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Bind Up and Down arrows to search history based on what you've typed (e.g., 'npm')
bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
bindkey "${terminfo[kcud1]}" down-line-or-beginning-search

# 7. Completions (Case-insensitive tab completion)
autoload -Uz compinit && compinit 2>/dev/null
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 
zstyle ':completion:*' menu select # Use a visual menu for completions

# 8. FZF Integration (Fuzzy finder for Ctrl+R)
# Fedora stores fzf scripts in these locations
[[ -f /usr/share/fzf/shell/key-bindings.zsh ]] && source /usr/share/fzf/shell/key-bindings.zsh
[[ -f /usr/share/fzf/shell/completion.zsh ]] && source /usr/share/fzf/shell/completion.zsh

# 9. Directory Jumper (zoxide)
# This replaces 'cd' with 'z'. It learns where you go.
# Usage: 'z myfolder' or 'zi' for an interactive list.
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh --cmd cd)"
fi

# 10. Useful Aliases for Fedora/KDE
alias open="kioclient5 exec" # Opens files/folders in KDE default apps
alias y="yadm"               # Shortcut for your dotfiles
alias update="sudo dnf upgrade"
alias dolphin="dolphin . & disown" # Open current folder in Dolphin and let it run in background
