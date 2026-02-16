# 1. Powerlevel10k Instant Prompt
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

# 5. History Settings (Searchable terminal history)
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history
setopt sharehistory
setopt hist_ignore_dups

# 6. Keybindings (Arrow keys search through history)
bindkey -e
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# 7. Completions (Case-insensitive tab completion)
autoload -Uz compinit && compinit 2>/dev/null
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 

# 8. FZF Integration (Load if exists, silent if not)
source /usr/share/fzf/shell/key-bindings.zsh 2>/dev/null
source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null
