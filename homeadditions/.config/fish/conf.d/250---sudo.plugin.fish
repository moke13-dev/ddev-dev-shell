#!/usr/bin/fish
# ddev-generated

function sudo-command-line-toggle
    set -l cmd (commandline)
    if test -z "$cmd"
        return
    end
    
    if string match -q 'sudo *' -- "$cmd"
        commandline -r (string replace -r '^sudo\s+' '' -- "$cmd")
    else
        commandline -r "sudo $cmd"
    end
end

# Alt+S binding
bind \es sudo-command-line-toggle
