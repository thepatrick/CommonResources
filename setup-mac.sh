#!/bin/bash

mkdir -p ~/Developer
cd ~/Developer
git clone git@github.com:thepatrick/CommonResources.git
pushd $HOME/Developer/CommonResources

./setup-config.sh
./setup-powerline-fonts.sh

popd

