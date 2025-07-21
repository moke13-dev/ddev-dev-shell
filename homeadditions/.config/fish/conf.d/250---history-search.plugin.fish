#!/usr/bin/fish
#ddev-generated

function fish_user_key_bindings
    # default-Mode (auch in multi-line Kommandos)
    bind -M default  Up   up-or-search
    bind -M default  Down down-or-search

    # insert-Mode (z.B. vi insert)
    bind -M insert   Up   up-or-search
    bind -M insert   Down down-or-search
end