#!/bin/bash

xcode-select --install

mkdir -p ~/Developer
cd ~/Developer
git clone https://github.com/thepatrick/CommonResources.git
pushd $HOME/Developer/CommonResources

./setup-{$HOSTNAME}.sh

# load yubikeys.asc in to gpg (put this in this repo?)
# install safari u2f extension: https://github.com/Safari-FIDO-U2F/Safari-FIDO-U2F

# brew tap homebrew/cask-versions

# brew install https://raw.githubusercontent.com/shtirlic/yubikeylockd/master/yubikeylockd.rb
# ... and then: sudo brew services start yubikeylockd

# git remote rm origin
# git remote add origin git@github.com:thepatrick/CommonResources.git

# Pair required smart cards
# install RequireSmartcard.mobileconfig

# sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
# sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on
# sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
# sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsigned off
# sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setallowsignedapp off
# if changed any of the above:
# sudo pkill -HUP socketfilterfw
# brew install lulu
# brew cask install bitbar
# brew install dnscrypt-proxy
# sudo brew services start dnscrypt-proxy
# bitbar://openPlugin?title=dnscrypt-proxy%20switcher&src=https://github.com/matryer/bitbar-plugins/raw/master/Network%2fdnscrypt-proxy-switcher.10s.sh
# bitbar://openPlugin?title=Brew%20Services&src=https://github.com/matryer/bitbar-plugins/raw/master/Dev%2fHomebrew%2fbrew-services.10m.rb
