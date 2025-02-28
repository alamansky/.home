# XDG base directory specification

# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# set env vars for programs that follow XDG spec
# https://wiki.archlinux.org/title/XDG_Base_Directory
# https://github.com/b3nj5m1n/xdg-ninja
export LESSHISTFILE="$XDG_STATE_HOME"/less/history
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history

# create aliases to supply XDG dirs as args for certain tools
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget/.wget-hsts"
alias mvn=mvn -Dmaven.repo.local="$XDG_DATA_HOME/.m2"

# Docker Desktop creates .aws, .azure and .docker dirs in the home directory when WSL2 integration + cloud experience is enabled
# If/when Docker Desktop becomes XDG-compliant, these env vars will put those dirs in the correct place
# https://github.com/docker/for-win/issues/9503
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
export AZURE_CONFIG_DIR="$XDG_DATA_HOME/azure"

# general env vars

export EDITOR="nvim"
export BROWSER="firefox"
