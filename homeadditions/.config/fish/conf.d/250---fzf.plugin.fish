#!/usr/bin/fish
# ddev-generated

if command -v fzf > /dev/null
    set -x FZF_DEFAULT_OPTS "--ansi --border=rounded --color=border:#f1f1f1 --layout=reverse --preview-window=right:60%"
    set -x FZF_DEFAULT_COMMAND "fd --type d --hidden --follow --exclude '.git'"

    fzf --fish | source

    function grep-files
        # 1. Search for text in files using Ripgrep
        # 2. Interactively restart Ripgrep with reload action
        # 3. Open the file in Vim
        set RG_PREFIX "rg --column --line-number --no-heading --color=always --smart-case "
        set INITIAL_QUERY "$argv"

        # Use a safe default command that won't error when there's no initial query
        # The empty string is used as a placeholder, and fzf will wait for user input
        set FZF_DEFAULT_CMD "$RG_PREFIX \"\" || true"

        # If we have arguments, use them for the initial search
        if test -n "$INITIAL_QUERY"
            set FZF_DEFAULT_CMD "$RG_PREFIX $INITIAL_QUERY"
        end

        set selected (
            env FZF_DEFAULT_COMMAND="$FZF_DEFAULT_CMD" \
            fzf --ansi \
                --disabled --query "$INITIAL_QUERY" \
                --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
                --delimiter : \
                --preview 'bat --color=always {1} --highlight-line {2}' \
                --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
        )

        if test -n "$selected"
            set fields (string split ":" $selected)
            vim $fields[1] "+$fields[2]"
        end
    end

    function find-file
        set file (fd --type f --hidden --follow --color always --exclude '.git' $argv[1] | fzf --ansi +m --preview='bat --color=always {}' --bind shift-up:preview-page-up,shift-down:preview-page-down)

        if test -n "$dir"
            vim "$dir"
        end
    end

    function find-directory
        set dir (fd --type d --hidden --follow --color always --exclude '.git' $argv[1] | fzf --ansi +m --preview='eza -lAhog --color=always --total-size --time-style long-iso --group-directories-first {}' --bind shift-up:preview-page-up,shift-down:preview-page-down)

        if test -n "$dir"
            cd "$dir"
        end
    end

    # Bind the function to Ctrl+F
    bind \cf grep-files
    # Bind the function to Ctrl+T
    bind \ct find-file
    # Bind the function to Alt+C
    bind \ec find-directory
end