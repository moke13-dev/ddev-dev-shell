#!/usr/bin/fish
#ddev-generated

mkdir -p /mnt/ddev-global-cache/fishhistory/$HOSTNAME
# workaround to keep the history file accross restarts
# https://fishshell.com/docs/current/cmds/history.html#customizing-the-name-of-the-history-file
# I am not using $XDG_DATA_HOME as that would change a lot of things, I rather
# just keep things default and do this cp workaround.
function handler --on-event fish_postexec
    cp ~/.local/share/fish/fish_history /mnt/ddev-global-cache/fishhistory/$HOSTNAME/fish_history
end
if test -f /mnt/ddev-global-cache/fishhistory/$HOSTNAME/fish_history
  cp /mnt/ddev-global-cache/fishhistory/$HOSTNAME/fish_history ~/.local/share/fish/fish_history
end

set -g fish_color_border blue
