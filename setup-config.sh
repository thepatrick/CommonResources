#!/bin/bash

ln -s `pwd`/config/ackrc ~/.ackrc
ln -s `pwd`/config/bash_login ~/.bash_login
ln -s `pwd`/config/bashrc ~/.bashrc
ln -s `pwd`/config/git-completion.sh ~/.git-completion.sh
ln -s `pwd`/config/inputrc ~/.inputrc
ln -s `pwd`/config/ssh/config ~/.ssh/config
ln -s `pwd`/config/vimrc ~/.vimrc
ln -s `pwd`/config/vim ~/.vim

git submodule init
git submodule update
