#!/bin/bash

set -e
set -u

. ./functions.sh

GIT_SIGNING_KEY=9EF74179
INCLUDE_ZEROTIER=false
INCLUDE_SDKMAN=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --gitkey=*) GIT_SIGNING_KEY="${1#*=}"; shift 1;;
    --zerotier) INCLUDE_ZEROTIER=true;shift 1;;
    --sdkman) INCLUDE_SDKMAN=true;shift 1;;
    --gitkey) echo "$1 requires an argument" >&2; exit 1;;

    # -*) echo "unknown option: $1" >&2; exit 1;;
    *) echo "unknown option: $1" >&2; exit 1;;
    # *) handle_argument "$1"; shift 1;;
    # *) args+="$1"; shift 1;;
  esac
done

##
 # Create some directories we always expect to exist
 ##
setup_dir $HOME/bin
setup_dir $HOME/.ssh
setup_dir $HOME/.ssh/tmp
setup_dir $HOME/.config

##
 # Create symlinks for our various dotfiles
 ##
setup_link `pwd`/config/ackrc $HOME/.ackrc
setup_link `pwd`/config/bash_login $HOME/.bash_login
setup_link `pwd`/config/bashrc $HOME/.bashrc
setup_link `pwd`/config/git-completion.sh $HOME/.git-completion.sh
setup_link `pwd`/config/inputrc $HOME/.inputrc
setup_link `pwd`/config/tmux.conf $HOME/.tmux.conf
setup_link `pwd`/config/ssh/config $HOME/.ssh/config
setup_link `pwd`/config/vimrc $HOME/.vimrc
setup_link `pwd`/vim $HOME/.vim
setup_link `pwd`/fish $HOME/.config/fish
setup_link `pwd`/fisherman $HOME/.config/fisherman

##
 # GNUPG Configuration (so we can use yubikeys for SSH keys / GPG signing)
 ##
setup_dir $HOME/.gnupg
setup_link `pwd`/config/gnupg_gpg.conf $HOME/.gnupg/gpg.conf
if [[ "$OSTYPE" = "darwin"* ]]; then
  setup_link `pwd`/config/gnupg_gpg-agent_darwin.conf $HOME/.gnupg/gpg-agent.conf
else
  setup_link `pwd`/config/gnupg_gpg-agent_linux.conf $HOME/.gnupg/gpg-agent.conf
fi

##
 # Setup git submodules (primarily for vim plugins)
 ##
git submodule init
git submodule update

##
 # Configure git
 ##
git config --global user.name "Patrick Quinn-Graham"
git config --global user.email "make-contact@pftqg.com"
git config --global user.signingkey $GIT_SIGNING_KEY
git config --global commit.gpgSign true
git config --global tag.forceSignAnnotated true

##
 # diff-so-fancy
 ##

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

##
 # tfenv (allows easily installing multiple terraform versions)
 ##
if [ ! -d $HOME/.tfenv ]; then
  git clone https://github.com/kamatama41/tfenv.git $HOME/.tfenv
fi

if [[ "$OSTYPE" = "darwin"* ]]; then
  echo "##"
  echo " # This is macOS" 
  echo " ##"
  
  if [ ! -e /usr/local/bin/brew ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  brew_if_missing mas /usr/local/bin/mas

  mas_if_missing 497799835 /Applications/Xcode.app
  
  brew_cask_if_missing 1password "/Applications/1Password 7.app"
  brew_cask_if_missing iterm2 /Applications/iTerm.app
  brew_cask_if_missing keybase /Applications/Keybase.app
  brew_cask_if_missing slack /Applications/Slack.app
  brew_cask_if_missing transmit "/Applications/Transmit.app"
  brew_cask_if_missing gpg-suite "/Applications/GPG Keychain.app"

  brew_if_missing thefuck /usr/local/bin/thefuck
  brew_if_missing hub /usr/local/bin/hub
  brew_if_missing carthage /usr/local/bin/carthage
  brew_if_missing awscli /usr/local/bin/aws
  brew_if_missing jq /usr/local/bin/jq
  brew_if_missing moreutils /usr/local/bin/ts
  brew_if_missing yarn /usr/local/bin/yarn

  brew_if_missing pam_yubico /usr/local/lib/security/pam_yubico.so

  ##
   # Setup fish shell on macOS
   ##
  brew_if_missing fish /usr/local/bin/fish
  if ! grep "fish" /etc/shells >> /dev/null; then
    sudo /bin/sh -c 'echo "/usr/local/bin/fish" >> /etc/shells'
  fi
  if [[ "$SHELL" != "/usr/local/bin/fish" ]]; then
    echo "Activating fish..."
    chsh -s /usr/local/bin/fish
  fi

  ##
   # Configure zerotier
   ##
  if [[ "$INCLUDE_ZEROTIER" = "true" ]]; then
    brew_cask_if_missing zerotier-one "/Applications/ZeroTier One.app"
    if ! sudo zerotier-cli listnetworks | grep a09acf0233b8a84a >> /dev/null; then
      sudo zerotier-cli join a09acf0233b8a84a
    fi
  else
    echo "Skipping zerotier, use --zerotier to configure"
  fi

  ##
   # Install Visual Studio Code
   ##
  brew_cask_if_missing visual-studio-code "/Applications/Visual Studio Code.app"
  mkdir -p "$HOME/Library/Application Support/Code/User/"
  setup_link `pwd`/config/visual-studio-code.json "$HOME/Library/Application Support/Code/User/settings.json"

else
  echo "This is probably linux, do things the linux way..."

  # Allow yubikeys to work in web browsers
  apt_if_missing libu2f-udev

  # Allow yubikeys to do SSH & git commit signing
  apt_if_missing gnupg2
  apt_if_missing pcscd
  apt_if_missing scdaemon

  # Vim. I mean obviously.
  apt_if_missing vim

  # Fish shell
  add_ppa_if_missing fish-shell/release-3
  apt_if_missing fish

  # Ansible
  add_ppa_if_missing ansible/ansible
  apt_if_missing ansible
 
  # The Fuck
  apt_if_missing python3-dev
  apt_if_missing python3-pip
  apt_if_missing python3-setuptools
  sudo pip3 install thefuck

  # install
  # - git
  # - keybase
  # - visual studio code
  # - slack
  # - hub (from github)
  # - yarn

  # Restart GPG agent, just in case we just configured it
  gpg-connect-agent killagent /bye
  gpg-connect-agent /bye
fi

if [[ "$INCLUDE_SDKMAN" = "true" ]]; then
  if [ ! -d ~/.sdkman/ ]; then
    curl -s "https://get.sdkman.io" | bash
  fi
else
  echo "Skipping sdkman, use --sdkman to configure"
fi

if [ ! -d $HOME/.nvm ]; then
  echo "Installing NVM"
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

  nvm i 10
fi

##
 # Visual Studio Code Extensions
 ##
if which code; then
  cache_vscode_extensions code
  add_vscode_extension_if_missing code chenxsan.vscode-standardjs
  add_vscode_extension_if_missing code mohsen1.prettify-json
  add_vscode_extension_if_missing code ms-vscode.cpptools
  add_vscode_extension_if_missing code PeterJausovec.vscode-docker
  add_vscode_extension_if_missing code silvenon.mdx
  add_vscode_extension_if_missing code artdiniz.quitcontrol-vscode
  add_vscode_extension_if_missing code christian-kohler.npm-intellisense
  add_vscode_extension_if_missing code christian-kohler.path-intellisense
  add_vscode_extension_if_missing code CoenraadS.bracket-pair-colorizer
  add_vscode_extension_if_missing code DavidAnson.vscode-markdownlint
  add_vscode_extension_if_missing code dbaeumer.vscode-eslint
  add_vscode_extension_if_missing code eamodio.gitlens
  add_vscode_extension_if_missing code EditorConfig.EditorConfig
  add_vscode_extension_if_missing code eg2.vscode-npm-script
  add_vscode_extension_if_missing code esbenp.prettier-vscode
  add_vscode_extension_if_missing code HookyQR.beautify
  add_vscode_extension_if_missing code JulioGold.vscode-smart-split-into-lines
  add_vscode_extension_if_missing code kumar-harsh.graphql-for-vscode
  add_vscode_extension_if_missing code mauve.terraform
  add_vscode_extension_if_missing code miclo.sort-typescript-imports
  add_vscode_extension_if_missing code ms-python.python
  add_vscode_extension_if_missing code ms-vscode.cpptools
  add_vscode_extension_if_missing code ms-vscode.Go
  add_vscode_extension_if_missing code ms-vscode.vscode-typescript-tslint-plugin
  add_vscode_extension_if_missing code redhat.vscode-yaml
  add_vscode_extension_if_missing code rogalmic.bash-debug
  add_vscode_extension_if_missing code stringham.move-ts
  add_vscode_extension_if_missing code torn4dom4n.latex-support
  add_vscode_extension_if_missing code gamunu.vscode-yarn
else
  echo "Visual Studio Code not installed"
fi


##
 # Visual Studio Code - Insiders Extensions
 ##
if which code-insiders; then
  cache_vscode_extensions code-insiders
  add_vscode_extension_if_missing code-insiders chenxsan.vscode-standardjs
  add_vscode_extension_if_missing code-insiders mohsen1.prettify-json
  add_vscode_extension_if_missing code-insiders ms-vscode.cpptools
  add_vscode_extension_if_missing code-insiders PeterJausovec.vscode-docker
  add_vscode_extension_if_missing code-insiders silvenon.mdx
  add_vscode_extension_if_missing code-insiders artdiniz.quitcontrol-vscode
  add_vscode_extension_if_missing code-insiders christian-kohler.npm-intellisense
  add_vscode_extension_if_missing code-insiders christian-kohler.path-intellisense
  add_vscode_extension_if_missing code-insiders CoenraadS.bracket-pair-colorizer
  add_vscode_extension_if_missing code-insiders DavidAnson.vscode-markdownlint
  add_vscode_extension_if_missing code-insiders dbaeumer.vscode-eslint
  add_vscode_extension_if_missing code-insiders eamodio.gitlens
  add_vscode_extension_if_missing code-insiders EditorConfig.EditorConfig
  add_vscode_extension_if_missing code-insiders eg2.vscode-npm-script
  add_vscode_extension_if_missing code-insiders esbenp.prettier-vscode
  add_vscode_extension_if_missing code-insiders HookyQR.beautify
  add_vscode_extension_if_missing code-insiders JulioGold.vscode-smart-split-into-lines
  add_vscode_extension_if_missing code-insiders kumar-harsh.graphql-for-vscode
  add_vscode_extension_if_missing code-insiders mauve.terraform
  add_vscode_extension_if_missing code-insiders miclo.sort-typescript-imports
  add_vscode_extension_if_missing code-insiders ms-python.python
  add_vscode_extension_if_missing code-insiders ms-vscode.cpptools
  add_vscode_extension_if_missing code-insiders ms-vscode.Go
  add_vscode_extension_if_missing code-insiders ms-vscode.vscode-typescript-tslint-plugin
  add_vscode_extension_if_missing code-insiders redhat.vscode-yaml
  add_vscode_extension_if_missing code-insiders rogalmic.bash-debug
  add_vscode_extension_if_missing code-insiders stringham.move-ts
  add_vscode_extension_if_missing code-insiders torn4dom4n.latex-support
  add_vscode_extension_if_missing code-insiders gamunu.vscode-yarn
else
  echo "Visual Studio Code - Insiders not installed"
fi

# if not run already, run ./setup-powerline-fonts.sh
