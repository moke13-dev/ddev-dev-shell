#!/usr/bin/fish
#ddev-generated

if command -v zoxide > /dev/null
    # set environment variable _ZO_DATA_DIR
    set -gx _ZO_DATA_DIR "/mnt/ddev-global-cache/zoxide/$HOSTNAME"

    # create the directory if it doesn't exist
    if not test -d "$_ZO_DATA_DIR"
        mkdir -p "$_ZO_DATA_DIR"
    end

    zoxide init fish | source
end