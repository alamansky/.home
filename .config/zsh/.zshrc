# source login shell profile
source $HOME/.profile

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

# machine-generated appends (e.g. from ansible):
# https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#manual-git-clone
[[ -s "$XDG_DATA_HOME/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && \
  source ${XDG_DATA_HOME}/zsh-autosuggestions/zsh-autosuggestions.zsh

[[ -x "$(command -v atuin)" ]] && eval "$(atuin init zsh)"

# set theme
# https://ohmyposh.dev/docs/installation/customize
[[ -x "$(command -v oh-my-posh)" ]] && \
  eval "$(oh-my-posh init zsh --config $XDG_CONFIG_HOME/omp/themes/amro.omp.json)"
# make claude XDG compliant
export CLAUDE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/claude"

