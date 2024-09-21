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

# Plugins
zcomet load romkatv/powerlevel10k
zcomet load ohmyzsh plugins/nvm
zcomet load jeffreytse/zsh-vi-mode
zcomet load ohmyzsh plugins/gitfast

# Defered Plugins
zcomet load zsh-users/zsh-syntax-highlighting
zcomet load zsh-users/zsh-autosuggestions

zcomet compinit

eval "$(zoxide init zsh)"

# Theme Stuff
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# User configuration
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.local/share/bob/nvim-bin:$PATH
export EDITOR='nvim'
export TMS_CONFIG_FILE=$XDG_CONFIG_HOME/tms/config.toml
export XDG_CONFIG_HOME=$HOME/.config
export TERM=xterm-256color


alias zshrc="nvim ~/.zshrc"
alias szshrc="source ~/.zshrc"
alias ebs-ssh="ssh -L 1521:localhost:1521  opc@ebsoci.projectgraphite.com"
alias gtmux="sh ~/Documents/work/util/publicapi.sh"
alias killGraphite="sh ~/Documents/work/util/killGraphite.sh"
alias k="sh ~/Documents/work/util/killGraphiteProcess.sh"
alias ngp=". ngp"

alias ls="eza"

[[ $TMUX ]] && alias fzf=fzf --tmux

alias ly='lazygit -ucd ~/.local/share/yadm/lazygit -w ~ -g ~/.local/share/yadm/repo.git'

export EDITOR=nvim

#GRAPHITE STUFF
export G_AUTO_WARM_UP=false
export GOOGLE_APPLICATION_CREDENTIALS="/Users/charlieplate/Documents/work/graphite/dev-env/savvy-eye-219502-ff128deb3183.json"
export JWT_TTL=1440
export LOG_LEVEL="trace"
# export EXTERNAL_INTERFACE_POLLING_ENABLED=true
# export SFTP_ADMIN_PRIVATE_KEY=$(cat /Users/charlieplate/.ssh/sftp_admin_nonprod)
# export SFTP_PGP_PRIVATE_KEY=$(cat /Users/charlieplate/Documents/work/util/keys/pgpPrivateKey)
# export SENDGRID_DEV_TO="charlie+garbage@graphiteconnect.com"

#node stuff
nvm use --silent 20
export PATH="/Users/charlieplate/.nvm/versions/node/v20.9.0/lib/node_modules/:$PATH"
export PATH="$(yarn global bin):$PATH"

# nvim
export NVIM_WORK_DIR="/Users/charlieplate/Documents/work/graphite"

# source "$HOME/.zsh_private_env"


export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
