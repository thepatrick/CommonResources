# TODO

1. sudo apt-add-repository ppa:fish-shell/release-3
  c. chsh `whoami` -s `which fish`
2. Load theme: `dconf load /org/gnome/terminal/legacy/profiles:/ < panic-theme-profile.dconf`
3. Download visual studio code:
  a. curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  b. sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
  c. sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  d. sudo apt-get install apt-transport-https
  e. sudo apt-get update
  f. sudo apt-get install code # or code-insiders
