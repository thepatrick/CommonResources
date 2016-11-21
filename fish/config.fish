# Snippet setting git branch and git dirty helper
# Commit at the end kept from original snippet, I added the rev-parse stuff and the proper redirection.

# set fish_git_dirty_color red
# set fish_git_clean_color brown
# function parse_git_dirty
#          if test (git status 2> /dev/null ^&1 | tail -n1) != "nothing to commit (working directory clean)"
#             echo (set_color $fish_git_dirty_color)
#          else
#             echo (set_color $fish_git_clean_color)
#          end
# end
# function fish_prompt --description 'Write out the prompt'
#     # Just calculate these once, to save a few cycles when displaying the prompt
#     if not set -q __fish_prompt_hostname
#         set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
#     end
#     if not set -q __fish_prompt_normal
#         set -g __fish_prompt_normal (set_color normal)
#     end
#     if not set -q __git_cb
#         if test (git rev-parse --is-inside-work-tree 2> /dev/null | tail -n 1) = 'true' 2> /dev/null
#             set __git_cb " ("(parse_git_dirty)(git branch ^/dev/null | grep \* | sed 's/* //')(set_color normal)") "
#         else
#             set __git_cb ""
#         end
#     end
#
#     switch $USER
#         case root
#         if not set -q __fish_prompt_cwd
#             if set -q fish_color_cwd_root
#                 set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
#             else
#                 set -g __fish_prompt_cwd (set_color $fish_color_cwd)
#             end
#         end
#         printf '%s@%s:%s%s%s%s# ' $USER $__fish_prompt_hostname "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal" $__git_cb
#
#         case '*'
#         if not set -q __fish_prompt_cwd
#             set -g __fish_prompt_cwd (set_color $fish_color_cwd)
#         end
#         printf '%s@%s:%s%s%s%s$ ' $USER $__fish_prompt_hostname "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal" $__git_cb
#     end
# end

# Credit to: http://notsnippets.tumblr.com/post/894091013/fish-function-of-the-day-prompt-with-git-branch for showing the branch
# and http://stackoverflow.com/a/9334733/1165146 for coloring the branch name depending on dirty status.
# http://herdrick.tumblr.com/post/24563032599/display-git-branch-and-dirty-status-in-fish-shell can go and die for posting
# code where " is replaced with ” and - with –. Now half of my repos have a branch called –quiet...

# function fish_prompt
#     set_color purple
#     date "+%m/%d/%y"
#     set_color FF0
#     echo (pwd) '>'
#     set_color normal
# end
# DEFAULT_COLOR=yellow
# if [ "$OSTYPE" == "darwin"* ] white
# if [ -f /etc/redhat-release ] red
# if [ -f /etc/debian_version ] green
# PS1={YELLOW}[{DEFAULT_COLOR}{$USER}@{$HOST}{YELLOW}] $PWD$
# #Back Up and date
# function bkdate() {
#   cp $1 $1.`date +%Y%m%d`;
# }


function add_to_path
  if test -e $argv[1]
    if not contains $argv[1] $PATH
      set -x PATH $argv[1] $PATH 
    end
  end
end

add_to_path /usr/bin
add_to_path /usr/sbin
add_to_path /usr/local/bin
add_to_path /usr/local/sbin
add_to_path /Library/PostgreSQL8/bin
add_to_path /usr/local/lib/erlang/lib/rabbitmq_server-1.4.0/sbin
add_to_path ~/dev/from-svn/depot_tools
add_to_path ~/bin
add_to_path ~/etc
add_to_path /usr/local/heroku/bin # Added by the Heroku Toolbelt
add_to_path $HOME/.rvm/bin        # Add RVM to PATH for scripting

if test -e "/usr/bin/nano"
  set -x EDITOR nano
end

function lsl
  ls -lFh $argv
end

function lsa
  ls -laFh $argv
end

if test -e "/usr/bin/xcrun"
  function getinfo
    xcrun GetFileInfo $argv
  end
end

# function tag-genocide()
#   for tag in $(git tag | tr "\n" " "); do git tag -d $tag; done
# end

function http
  curl http://httpcode.info/$argv[1]
end

set -x HOMEBREW_NO_ANALYTICS 1

if test -e ~/.nvm
  set -x NVM_DIR ~/.nvm
  if test -e ~/.nvm/nvm.sh
    set NVM_SH ~/.nvm/nvm.sh
  else
    set BREW_SH (which brew)
    if test -e $BREW_SH
      set NVM_SH (brew --prefix nvm)/nvm.sh
    end
  end
  if test -e $NVM_SH
    bass source $NVM_SH
    function nvm
       bass source $NVM_SH --no-use ';' nvm $argv
    end
  else
    echo "Could not find nvm.sh (best guess $NVM_SH), disabling nvm helpers"
  end
else
  echo No ~/.nvm, disabling nvm helpers
end

if test -e ~/.config/fish/config_local.fish
  source ~/.config/fish/config_local.fish
end

#func docker-cleanup
#  docker rm (docker ps -qa --no-trunc --filter "status=exited")
#  docker rmi (docker images --filter "dangling=true" -q --no-trunc)
#end

# code () {
#     if [[ $# = 0 ]]
#     then
#         open -a "Visual Studio Code"
#     else
#         [[ $1 = /* ]] && F="$1" || F="$PWD/${1#./}"
#         open -a "Visual Studio Code" --args "$F"
#     fi
# }
#
# # added by travis gem
