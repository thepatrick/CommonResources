set -e
set -u

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

function apt_if_missing() {
  PKG_OK=$(dpkg-query -W --showformat='${Status}\n' $1|grep "install ok installed")
  #echo Checking for $1: $PKG_OK
  if [ "" == "$PKG_OK" ]; then
    echo "Installing $1"
    sudo apt-get --yes install $1
  #else
  #  echo "$1 installed already"
  fi
}

function add_ppa_if_missing() {
  SRC_LINE_COUNT=$(grep -c $1 /etc/apt/sources.list.d/*.list | grep -c -v ":0")
  if [ "0" == "$SRC_LINE_COUNT" ]; then
    echo "Adding ppa:$1"
    sudo apt-add-repository ppa:$1
  else
    echo "I think ppa:$1 is already set up"
  fi
}

function cache_vscode_extensions() {
  $1 --list-extensions > $1-extensions.txt
}

function add_vscode_extension_if_missing() {
  # PKG_COUNT=$()
  if ! chronic grep -c $2 $1-extensions.txt; then
    echo "Adding extension: $2"
    chronic $1 --install-extension $2
  fi
}

function mas_if_missing() {
  if [ ! -d "$2" ]; then
    echo "Installing from App Store: $1 to provide $2"
    mas install "$1"
  fi
}