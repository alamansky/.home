# open a file or directory in neovim
function o() {
  local target;
  case "$1" in
    "sh"|"shell"|"env")
      target=$XDG_CONFIG_HOME/env
      ;;
    "zsh"|"z")
      target=$XDG_CONFIG_HOME/zsh/.zshrc
      ;;
    "nvim"|"neovim")
      target=$XDG_CONFIG_HOME/nvim
      ;;
    "nvchad")
      target=$XDG_DATA_HOME/nvim
      ;;
    "ans"|"ansible")
      target=$XDG_DATA_HOME/ansible/playbooks/localhost
      ;;
    "bm"|"bookmarks")
      target=$BOOKMARKS
      ;;
    *)
      echo "Not a recognized path alias: $1"
      ;;
  esac
  [ -n "$target" ] && $EDITOR $target
}

# create gzipped tarball from directory
# $1 - name of tarball
# $2 - directory to archive
function tb() {
  tar -czf $1.tar.gz $2
}

# move file from local to remote
# $1 - local path
# $2 - remote machine user
# $3 - remote machine IP address
# $4 - remote path
function up() {
  rsync -avz $1 $2@$3:$4
}

# move file from remote to local
# $1 - remote machine user
# $2 - remote machine IP address
# $3 - remote path
# $4 - local path
function down() {
  rsync -avz $1@$2:$3 $4
}

# copy ~/docs to a remote machine specified by env vars
function backup() {
  cp $XDG_CONFIG_HOME/google-chrome/Default/Bookmarks ~/docs/bookmarks/Bookmarks
  rsync -avz --delete --backup-dir=/home/$D1_USER/backups/docs  ~/docs $D1_USER@$D1_IP:/home/$D1_USER
}

# copy ~/docs from a remote machine specified by env vars
function backdown() {
  rsync -avz --delete --backup-dir=$HOME/backups/docs $D1_USER@$D1_IP:/home/$D1_USER/docs/ ~/docs
}

# set interactive shell to zsh
function zshell() {
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

# search bookmarks
function bm() {
  qq '.roots.other.children[] | .url' $BOOKMARKS | fzf | xargs -o $BROWSER
}

# look up function definition
function func() {
  cat $XDG_CONFIG_HOME/env/functions.sh | fzf | sed 's/[^^]/[&]/g; s/\^/\\^/g' | xargs -I {} awk -v RS= -v ORS='\n\n' "/{}/" $XDG_CONFIG_HOME/env/functions.sh
}

function nkb() {
  cat $XDG_CONFIG_HOME/nvim/lua/overrides/README.md | \
  fzf | \
  sed 's/[^^]/[&]/g; s/\^/\\^/g' | \
  xargs -I {} awk -v RS= -v ORS='\n\n' "/{}/" $XDG_CONFIG_HOME/nvim/lua/overrides/README.md
}


# merge JSON data into pug template and convert to HTML
# $1 - path to directory with input JSON data
# $2 - path to pug template file
# $3 - path to output directory for html files
function pugme() {
  node $XDG_CONFIG_HOME/env/scripts/pugme/pugme.js $1 $2 $3
}

# change a local commit message
# $1 - new message for commit
function amend_commit() {
  git commit --amend -m "${1}"
}

# call powershell script to restore network connectivity in WSL after connecting to a VPN
function vpn() {
  powershell.exe -c wsl-vpn
}

# machine-generated appends
alias chrome="google-chrome-stable"
