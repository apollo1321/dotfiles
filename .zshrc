if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export TERM=xterm-256color

source "${HOME}/.scripts/colors.sh"

if [[ ! -e "${HOME}/.zgenom" ]]; then
  git clone https://github.com/jandamm/zgenom.git "${HOME}/.zgenom"
fi

source "${HOME}/.zgenom/zgenom.zsh"

zgenom autoupdate

if ! zgenom saved; then
  info "Creating a zgenom save\n"
  
  zgenom load romkatv/powerlevel10k powerlevel10k
  zgenom load zdharma-continuum/fast-syntax-highlighting
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load ael-code/zsh-colored-man-pages
  zgenom load agkozak/zsh-z
  zgenom load djui/alias-tips

  zgenom save
fi

bindkey '^ ' autosuggest-accept

alias ls="ls --color=auto"

source "${HOME}/.p10k.zsh"
