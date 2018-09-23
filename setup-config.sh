#!/bin/bash

function setup_link() {
  if [ -h "$2" ]; then
    if [ `readlink "$2"` != "$1" ]; then
      echo $2 -h exists but points to `readlink "$2"`, remove it and run $0 again.
    fi
  elif [ -d "$2" ]; then
    echo "$2" -d exists, move it aside and run $0 again.
	elif [ -f "$2" ]; then
    echo "$2" -f exists, move it aside and run $0 again.
  else
    echo "$2" linking to "$1"
    ln -s "$1" "$2"
	fi
}

function setup_dir() {
  if [ ! -d $1 ]; then
    mkdir -p $1
  fi
}

function download_if_missing() {
  if [ ! -f $2 ]; then
    curl --silent $1 > $2
    chmod +x $2
  fi
}

function brew_if_missing() {
  if [ ! -e "$2" ]; then
    brew install "$1"
  fi
}

function brew_cask_if_missing() {
  if [ ! -d "$2" ]; then
    brew cask install "$1"
  fi
}

setup_dir $HOME/.ssh
setup_dir $HOME/.ssh/tmp

setup_link `pwd`/config/ackrc $HOME/.ackrc
setup_link `pwd`/config/bash_login $HOME/.bash_login
setup_link `pwd`/config/bashrc $HOME/.bashrc
setup_link `pwd`/config/git-completion.sh $HOME/.git-completion.sh
setup_link `pwd`/config/inputrc $HOME/.inputrc
setup_link `pwd`/config/tmux.conf $HOME/.tmux.conf
setup_link `pwd`/config/ssh/config $HOME/.ssh/config
setup_link `pwd`/config/vimrc $HOME/.vimrc
setup_link `pwd`/vim $HOME/.vim

setup_dir $HOME/.config
setup_dir $HOME/bin

setup_link `pwd`/fish $HOME/.config/fish
setup_link `pwd`/fisherman $HOME/.config/fisherman

setup_dir $HOME/.gnupg
setup_link `pwd`/config/gnupg_gpg.conf $HOME/.gnupg/gpg.conf
if [[ "$OSTYPE" = "darwin"* ]]; then
  setup_link `pwd`/config/gnupg_gpg-agent_darwin.conf $HOME/.gnupg/gpg-agent.conf
else
  setup_link `pwd`/config/gnupg_gpg-agent_linux.conf $HOME/.gnupg/gpg-agent.conf
fi


git submodule init
git submodule update

git config --global user.name "Patrick Quinn-Graham"
git config --global user.email "make-contact@pftqg.com"
git config --global user.signingkey "9EF74179"
git config --global commit.gpgSign true
git config --global tag.forceSignAnnotated true

download_if_missing https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy $HOME/bin/diff-so-fancy

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

if [ ! -d $HOME/.tfenv ]; then
  git clone https://github.com/kamatama41/tfenv.git $HOME/.tfenv
fi

if [[ "$OSTYPE" = "darwin"* ]]; then
  echo "This is macOS" 
  if [ ! -e /usr/local/bin/brew ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  
  brew_cask_if_missing 1password "/Applications/1Password 7.app"
  brew_cask_if_missing iterm2 /Applications/iTerm.app
  brew_cask_if_missing visual-studio-code "/Applications/Visual Studio Code.app"
  brew_cask_if_missing keybase /Applications/Keybase.app
  brew_cask_if_missing slack /Applications/Slack.app
  brew_cask_if_missing zerotier-one "/Applications/ZeroTier One.app"
  brew_cask_if_missing transmit "/Applications/Transmit.app"
  brew_cask_if_missing gpg-suite "/Applications/GPG Keychain.app"

  brew_if_missing fish /usr/local/bin/fish
  brew_if_missing thefuck /usr/local/bin/thefuck
  brew_if_missing hub /usr/local/bin/hub
  brew_if_missing carthage /usr/local/bin/carthage
  brew_if_missing awscli /usr/local/bin/aws
  brew_if_missing jq /usr/local/bin/jq

  mkdir -p "$HOME/Library/Application Support/Code/User/"
  setup_link `pwd`/config/visual-studio-code.json "$HOME/Library/Application Support/Code/User/settings.json"

  if ! grep "fish" /etc/shells >> /dev/null; then
    sudo /bin/sh -c 'echo "/usr/local/bin/fish" >> /etc/shells'
  fi

  if [[ "$SHELL" != "/usr/local/bin/fish" ]]; then
    echo "Activating fish..."
    chsh -s /usr/local/bin/fish
  fi

  if ! sudo zerotier-cli listnetworks | grep a09acf0233b8a84a >> /dev/null; then
    sudo zerotier-cli join a09acf0233b8a84a
  fi
else
  echo "This is probably linux, do things the linux way..."
  # install
  # - gpg & configure it ala https://github.com/dainnilsson/scripts/blob/master/base-install/gpg.sh
  # - git
  # - nvm + node 8
  # - keybase
  # - visual studio code
  # - slack
  # - thefuck 
  # - hub (from github)
  # - fish
fi

# if not run already, run ./setup-powerline-fonts.sh
