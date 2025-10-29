# directory shortcuts
alias ans="cd ~/.home/.local/share/ansible/playbooks/localhost && $EDITOR"
alias nvc="cd ~/.home/.config/nvim && $EDITOR"
alias cnv="cd ~/.home/.config/env && $EDITOR"

# file shortcuts
alias zrc="$EDITOR ~/.home/.config/zsh/.zshrc"

# to specify config explicitly:
# alias nvim="nvim -u ${XDG_CONFIG_HOME}/nvim/init.lua"

# functions

# set interactive shell to zsh
function zshell {
  chsh -s $(which zsh) $(whoami)
}

# copy stdout to Windows clipboard
# e.g. `echo 'hello world' | copy`
function copy() {
  clip.exe
}

# paste Windows clipboard to stdout
# e.g. `paste > hello_world.txt`
function paste() {
  powershell.exe -c Get-Clipboard
}

# pretty-print json
# e.g. `cat unformatted.json | pp-json`
function pp-json() {
  python3 -m json.tool
}

# pretty-print json in Windows clipboard
pp-json-cb() {
  paste | pp-json | copy
}

# download repo subdirectory with git
# $1 - git username/repo, e.g.
# $2 - subdirectory name
function git-clone-sparse() {
# clone root folder and top-level files only
  git clone --filter=blob:none --sparse git@github.com:$1.git
  local username="${1%%/*}"
  local repo="${1##*/}"
  cd $repo
  # download subdirectory into root
  git sparse-checkout add $2
  mv $2 ..
  cd ..
  rm -rf $repo
}

# serve files in current directory
# $1 - port to which the server should listen
function serve() {
  python3 -m http.server $1
}

# machine-generated appends
alias chrome="google-chrome-stable"
