#!/bin/bash

xcode-select --install

mkdir -p ~/Developer
cd ~/Developer
git clone https://github.com/thepatrick/CommonResources.git
pushd $HOME/Developer/CommonResources

./setup-{$HOSTNAME}.sh

# load yubikeys.asc in to gpg (put this in this repo?)
# install safari u2f extension: https://github.com/Safari-FIDO-U2F/Safari-FIDO-U2F

# brew cask install hyper\

# brew tap homebrew/cask-versions
#   


# brew install https://raw.githubusercontent.com/shtirlic/yubikeylockd/master/yubikeylockd.rb
# ... and then: sudo brew services start yubikeylockd

# git remote rm origin
# git remote add origin git@github.com:thepatrick/CommonResources.git

# Copy keybase challenges:
# cp /keybase/private/thepatrick/yubico/challenge-* ~/.yubico/
# Add to /etc/pam.d/screensaver after "account required pam_opendirectory.so"
#   auth       required       /usr/local/lib/security/pam_yubico.so mode=challenge-response
# Add to /etc/pam.d/authorization after "account required pam_opendirectory.so"
#   auth       required       /usr/local/lib/security/pam_yubico.so mode=challenge-response