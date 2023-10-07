fpath=($fpath autoloaded)
fpath+=($ZDOTDIR/.antidote/plugins/pure)

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
autoload -U edit-command-line

# Lazy-load antidote and generate the static load file only when needed
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  (
    source $ZDOTDIR/.antidote/antidote.zsh
    antidote bundle <${zsh_plugins}.txt >${zsh_plugins}.zsh
  )
fi
source ${zsh_plugins}.zsh

autoload -U promptinit; promptinit
prompt pure

bindkey '^ ' autosuggest-accept
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey '^H' backward-kill-word
bindkey '5~' kill-word

alias tree='tree -a -I .git'
alias update='sudo pacman -Syyu'
alias yupdate='paru -Syyu'
alias dotfiles='$(which git) --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias install='sudo pacman -S'
alias uninstall='sudo pacman -Rns'
alias yinstall='paru -S'
alias yuninstall='paru -Rnsu'
alias fb='tmuxp load fjapi'
alias fbf='tmuxp load fjfull'
alias lst='eza -T'
alias copy='pwd | tr -d "\r\n" | pbcopy'

setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu

ZSH_AUTOSUGGEST_HISTORY_IGNORE='rm*|mkdir*|mv*|unzip*|zip*|cp*|unrar*'
DISABLE_AUTO_UPDATE="true"
export EDITOR=nvim
export VISUAL=nvim
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="/home/deus/.local/share/fnm:$PATH"
export BAT_THEME="Catppuccin-mocha"
export BUN_INSTALL="$HOME/.bun" 
export PATH="$BUN_INSTALL/bin:$PATH" 
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"
# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --header 'Press CTRL-/ to toggle preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | xclip -selection clipboard)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

[ -f "/home/deus/.ghcup/env" ] && source "/home/deus/.ghcup/env" # ghcup-env
#_evalcache fnm env
#_evalcache pyenv init --path
#
# bun completions
# [ -s "/home/deus/.bun/_bun" ] && source "/home/deus/.bun/_bun"
