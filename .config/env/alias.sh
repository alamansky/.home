# directory shortcuts
alias ans="cd ~/.home/.local/share/ansible/playbooks/localhost && $EDITOR"
alias nvc="cd ~/.home/.config/nvim && $EDITOR"
alias cnv="cd ~/.home/.config/env && $EDITOR"

# file shortcuts
alias zrc="$EDITOR ~/.home/.config/zsh/.zshrc"

# set interactive shell to zsh
alias zshell="chsh -s $(which zsh) $(whoami)"

# to specify config explicitly:
#alias nvim="nvim -u ${XDG_CONFIG_HOME}/nvim/init.lua"

#functions

# pretty-print json
# $1 - json string to pretty print
function pp-json() {
  echo $1 | python3 -m json.tool
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

# machine-generated appends
alias chrome="google-chrome-stable"
