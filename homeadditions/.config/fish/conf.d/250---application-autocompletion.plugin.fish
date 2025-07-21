#!/usr/bin/fish
#ddev-generated

set -gx PATH $HOME/.composer/vendor/bin $PATH

# Source all ddev global cached completions for this project
set -l DDEV_GLOBAL_CACHE "/mnt/ddev-global-cache"
set -l PROJECT_NAME (set -q DDEV_PROJECT; and echo $DDEV_PROJECT; or echo "project")
set -l COMPLETION_CACHE_DIR "$DDEV_GLOBAL_CACHE/qemo-app-autocompletions/$PROJECT_NAME"
set -l cache_dir "$COMPLETION_CACHE_DIR"
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
