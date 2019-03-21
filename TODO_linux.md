# TODO

0. apt_if_missing vim
1. sudo apt-add-repository ppa:fish-shell/release-3
  a. sudo apt update
  b. apt_if_missing fish
  c. chsh `whoami` -s `which fish`
2. Load theme: `dconf load /org/gnome/terminal/legacy/profiles:/ < panic-theme-profile.dconf`
