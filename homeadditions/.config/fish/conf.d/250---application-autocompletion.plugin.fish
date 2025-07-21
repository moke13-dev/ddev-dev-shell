#!/usr/bin/fish
# ddev-generated

set -gx PATH "${HOME}/.composer/vendor/bin" $PATH

# Source all ddev global cached completions for this project
set -l cache_dir /mnt/ddev-global-cache/qemo-app-autocompletions/$DDEV_PROJECT
if not test -d $cache_dir
    if type -q qemo-app-autocompletion
        echo "[ddev] Generating fish completions for project $DDEV_PROJECT ..."
        qemo-app-autocompletion
    end
end
if test -d $cache_dir
    for f in $cache_dir/*.fish
        if test -f $f
            source $f
        end
    end
end
