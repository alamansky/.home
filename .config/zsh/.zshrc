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
