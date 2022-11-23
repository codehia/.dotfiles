zmodload zsh/zprof
[ -f "$HOME/.local/share/zap/zap.zsh" ] && source "$HOME/.local/share/zap/zap.zsh"
fpath=($fpath autoloaded)

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
autoload -U edit-command-line
# Example install plugins
plug "codehia/supercharge"
plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-syntax-highlighting"
plug "Tarrasch/zsh-autoenv"
plug "agkozak/zsh-z"
plug "mroth/evalcache"
# Example theme
plug "codehia/async-prompt"
# Example install completion
plug "zsh-users/zsh-completions"


bindkey '^ ' autosuggest-accept
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey '^H' backward-kill-word
bindkey '5~' kill-word

ZSH_AUTOSUGGEST_HISTORY_IGNORE='rm*|mkdir*|mv*|unzip*|zip*|cp*|unrar*'

export PATH=/home/deus/.fnm:$PATH
export PATH="$HOME/.pyenv/bin:$PATH"

alias tree='tree -a -I .git'
alias update='sudo pacman -Syyu'
alias yupdate='yay -Syyu'
alias dotfiles='$(which git) --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
alias install='sudo pacman -S'
alias uninstall='sudo pacman -Rns'
alias yinstall='yay -S'
alias yuninstall='yay -Rnsu'

[ -f "/home/deus/.ghcup/env" ] && source "/home/deus/.ghcup/env" # ghcup-env

# timezsh() {
#   shell=${1-$SHELL}
#   for i in $(seq 1 10); do time $shell -i -c exit; done
# }
