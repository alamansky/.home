# enable vim keybindings (terminal starts in insert mode)
bindkey -v

# edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# tab completion:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# make zsh compdump XDG compliant
compinit -d $XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION
# https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#manual-git-clone
[[ -s "$XDG_DATA_HOME/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
  source ${XDG_DATA_HOME}/zsh-autosuggestions/zsh-autosuggestions.zsh

# https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#manual-git-clone
[[ -s "$XDG_DATA_HOME/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
  source ${XDG_DATA_HOME}/zsh-autosuggestions/zsh-autosuggestions.zsh

# https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#manual-git-clone
[[ -s "$XDG_DATA_HOME/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
  source ${XDG_DATA_HOME}/zsh-autosuggestions/zsh-autosuggestions.zsh

# set theme
# https://ohmyposh.dev/docs/installation/customize
export OMP_THEME="agnoster.minimal"
[[ -x "$(command -v oh-my-posh)" ]] && \
  eval "$(oh-my-posh init zsh --config ${XDG_CACHE_HOME}/oh-my-posh/themes/${OMP_THEME}.omp.json)"

# set theme
# https://ohmyposh.dev/docs/installation/customize
export OMP_THEME="agnoster.minimal"
[[ -x "$(command -v oh-my-posh)" ]] && \
  eval "$(oh-my-posh init zsh --config ${XDG_CACHE_HOME}/oh-my-posh/themes/${OMP_THEME}.omp.json)"

[[ -x "$(command -v atuin)" ]] && eval "$(atuin init zsh)" 

