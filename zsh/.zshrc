# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ ! -f ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh ]]; then
  command git clone https://github.com/agkozak/zcomet.git ${ZDOTDIR:-${HOME}}/.zcomet/bin
fi


source ${ZDOTDIR:-${HOME}}/.zcomet/bin/zcomet.zsh

zcomet load romkatv/powerlevel10k
zcomet load ohmyzsh plugins/nvm
zcomet load jeffreytse/zsh-vi-mode
zcomet load ohmyzsh plugins/gitfast
zcomet load zsh-users/zsh-syntax-highlighting
zcomet load zsh-users/zsh-autosuggestions
zcomet load zsh-users/zsh-history-substring-search

export ZSH_DOTENV_PROMPT=false
zcomet load ohmyzsh plugins/dotenv

zcomet compinit

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

eval "$(zoxide init zsh)"

HISTFILE=$HOME/.zsh_history  # Location of the history file
HISTSIZE=100000              # Maximum lines in a session's memory
SAVEHIST=100000              # Maximum lines saved to the history file
setopt SHARE_HISTORY         # Share history between all sessions
setopt EXTENDED_HISTORY      # Write the history file in the ':start:elapsed;command' format with timestamps
setopt INC_APPEND_HISTORY    # Append new history lines to the $HISTFILE incrementally

# Theme Stuff
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# User configuration
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.local/share/bob/nvim-bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=$HOME/Library/Python/3.9/bin:$PATH
export PATH=$HOME/.config/emacs/bin:$PATH
export PATH=$HOME/.local/share/nvim/mason/bin:$PATH
export EDITOR='nvim'
export XDG_CONFIG_HOME=$HOME/.config
export TERM=xterm-256color
# source ~/.zshrc_private
source <(fzf --zsh)

alias zshrc="nvim ~/.zshrc"
alias szshrc="source ~/.zshrc"
alias ebs-ssh="ssh -L 1521:localhost:1521  opc@ebsoci.projectgraphite.com"
alias ngp=". ngp"
alias ls="eza"
alias python="python3"
alias pip="pip3"
alias vim=nvim


[[ $TMUX ]] && alias fzf=fzf --tmux

alias ly='lazygit -ucd ~/.local/share/yadm/lazygit -w ~ -g ~/.local/share/yadm/repo.git'

export EDITOR=nvim

# #node stuff
# nvm use --silent 20
# export PATH="$HOME/.nvm/versions/node/v20.9.0/lib/node_modules/:$PATH"
# export PATH="$(yarn global bin):$PATH"

# nvim
export NVM_DIR="$HOME/.config/nvm"

export TMS_CONFIG_FILE=$XDG_CONFIG_HOME/tms/config.toml

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias :q='read "answer?Are you sure you want to exit? (y/n) "; if [[ $answer == [Yy] ]]; then exit; fi'
