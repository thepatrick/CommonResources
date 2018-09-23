#!/bin/bash

mkdir -p ~/Developer
cd ~/Developer
git clone git@github.com:thepatrick/CommonResources.git
pushd $HOME/Developer/CommonResources
./setup-config.sh

sudo /bin/sh -c 'echo "/usr/local/bin/fish" >> /etc/shells'
chsh -s /usr/local/bin/fish # if mac!

./setup-powerline-fonts.sh

sudo zerotier-cli join a09acf0233b8a84a
