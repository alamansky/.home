# include opt
export PATH="$PATH:/opt"

# include user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# include user's private bin if it exists (XDG spec)
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# machine-generated appends (e.g. from ansible):
