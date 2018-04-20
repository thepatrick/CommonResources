#!/bin/bash

function setup_link() {
  if [ -h $2 ]; then
    if [ `readlink $2` != "$1" ]; then
      echo $2 -h exists but points to `readlink $2`, remove it and run $0 again.
    fi
  elif [ -d $2 ]; then
    echo $2 -d exists, move it aside and run $0 again.
	elif [ -f $2 ]; then
    echo $2 -f exists, move it aside and run $0 again.
  else
    echo $2 linking to $1
    ln -s "$1" "$2"
	fi
}

function download_if_missing() {
  if [ ! -f $2 ]; then
    curl --silent $1 > $2
      chmod +x $2
  fi
}

setup_link `pwd`/config/ackrc ~/.ackrc
setup_link `pwd`/config/bash_login ~/.bash_login
setup_link `pwd`/config/bashrc ~/.bashrc
setup_link `pwd`/config/git-completion.sh ~/.git-completion.sh
setup_link `pwd`/config/inputrc ~/.inputrc
setup_link `pwd`/config/tmux.conf ~/.tmux.conf
setup_link `pwd`/config/ssh/config ~/.ssh/config
setup_link `pwd`/config/vimrc ~/.vimrc
setup_link `pwd`/vim ~/.vim


if [ ! -d ~/.config ]; then
  mkdir ~/.config
fi

setup_link `pwd`/fish ~/.config/fish
setup_link `pwd`/fisherman ~/.config/fisherman

git submodule init
git submodule update

download_if_missing https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy ~/bin/diff-so-fancy

git config --global core.pager "diff-so-fancy | less --tabs=2 -RFX"
git config --global color.ui true

git config --global color.diff-highlight.oldNormal    "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal    "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"

git config --global color.diff.meta       "yellow"
git config --global color.diff.frag       "magenta bold"
git config --global color.diff.commit     "yellow bold"
git config --global color.diff.old        "red bold"
git config --global color.diff.new        "green bold"
git config --global color.diff.whitespace "red reverse"

git config --bool --global diff-so-fancy.markEmptyLines false
git config --bool --global diff-so-fancy.changeHunkIndicators false

if [ ! -d ~/.tfenv ]; then
  git clone https://github.com/kamatama41/tfenv.git ~/.tfenv
fi

# install
# - git
# - nvm + node 8
# - krypt.co
# - keybase
# - visual studio code
# - slack
# - thefuck 

