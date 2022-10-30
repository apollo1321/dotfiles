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
alias la="ls -a"

alias aa="arc add"
alias ab="arc branch"
alias ac="arc commit"
alias ac!="arc commit --amend --no-edit"
alias aco="arc checkout"
alias ad="arc diff"
alias aprc="arc pr create --push"
alias ast="arc status"
alias ap="arc push"
alias ap!="arc push --force"
alias ast="arc st"
alias apl="arc pull"
alias arb="arc rebase"

alias ga="git add"
alias gb="git branch"
alias gc="git commit"
alias gc!="git commit --amend --no-edit"
alias gco="git checkout"
alias gd="git diff"
alias gst="git status"
alias gp="git push"
alias gp!="git push --force"
alias gst="git st"
alias gpl="git pull"
alias grb="git rebase"

source "${HOME}/.p10k.zsh"

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt appendhistory
