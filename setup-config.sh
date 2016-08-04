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

setup_link `pwd`/atom ~/.atom

git submodule init
git submodule update
