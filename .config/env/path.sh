# include opt
PATH="$PATH:/opt"

# include user's private bin if it exists
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

# include user's private bin if it exists (XDG spec)
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

# include yarn global install directory
# https://github.com/yarnpkg/yarn/issues/1321#issuecomment-256488275
[ -d "$(yarn global bin)" ] && PATH="$(yarn global bin):$PATH"

# machine-generated appends (e.g. from ansible):
