#!/usr/bin/fish
#ddev-generated

if command -v fzf > /dev/null
    function git-status --description 'Get git status for a path'  --argument path
        pushd $path > /dev/null

        # Check if in git repo
        if not git -C $path rev-parse --is-inside-work-tree &>/dev/null
            return 1
        end

        # Get git branch
        set branch (git symbolic-ref --short HEAD 2>/dev/null)
        if test -n "$branch"
            set branch (echo $branch | string trim)
            set branch " $branch"
        else
            set branch (git describe --tags --always 2>/dev/null)
            if test -n "$branch"
                set branch (echo $branch | string trim)
                set branch "炙$branch"
            end
        end

        # Get git status
        set git_status (git -C $path status --porcelain=2 --branch)

        # Initialize counters
        set stashed 0
        set conflicted 0
        set deleted 0
        set renamed 0
        set modified 0
        set typechanged 0
        set staged 0
        set untracked 0
        set ahead 0
        set behind 0

        # Count changes
        for line in $git_status
            if string match -rq '^#\sbranch\.ab\s.?' $line
                if string match -rq 'branch\.ab\s\+(?<ahead_count>\d+)\s\-(?<behind_count>\d+)' $line
                    set ahead $ahead_count
                    set behind $behind_count
                end
            else if string match -rqv '^#.?' $line
                set line_parts (string split ' ' $line)
                switch $line_parts[1]
                    case 'u'  # Conflicts
                        set conflicted (math $conflicted + 1)
                    case '1' '2'
                        if test "$line_parts[1]" -eq '2'
                            set -g renamed (math $renamed + 1)
                        end

                        if string match -rq 'D' $line_parts[2]
                            set deleted (math $deleted + 1)
                        end

                        if string match -rq '.?[MA]$' $line_parts[2]
                            set modified (math $modified + 1)
                        end

                        if string match -rq '^[MAT].?' $line_parts[2]
                            set staged (math $staged + 1)
                        end

                        if string match -rq '.?[T]$' $line_parts[2]
                            set typechanged (math $typechanged + 1)
                        end
                    case '?'  # Untracked
                        set untracked (math $untracked + 1)
                end
            end
        end

        # Check for stashes
        if git -C $path rev-parse --verify refs/stash &>/dev/null
            set stashed 1
        end

        # Build status string
        set color_red "\033[0;31m"
        set color_green "\033[0;32m"
        set color_orange "\033[0;91m"
        set color_reset "\033[0m"

        set status_parts
        if test $conflicted -gt 0
            set status_parts "$status_part $color_red C:$conflicted $color_reset"
        end

        if test $stashed -gt 0
            set status_parts "$status_part $color_orange H:$stashed $color_reset"
        end

        if test $deleted -gt 0
            set status_parts "$status_parts $color_red D:$deleted $color_reset"
        end

        if test $renamed -gt 0
            set status_parts "$status_parts $color_red R:$renamed $color_reset"
        end

        if test $modified -gt 0
            set status_parts "$status_parts $color_red✎ U:$modified $color_reset"
        end

        if test $typechanged -gt 0
            set status_parts "$status_parts $color_red⇢$typechanged $color_reset"
        end

        if test $staged -gt 0
            set status_parts "$status_parts $color_green S:$staged $color_reset"
        end

        if test $untracked -gt 0
            set status_parts "$status_parts $color_red ?:$untracked $color_reset"
        end

        if test $ahead -gt 0 -a $behind -gt 0
            set status_parts "$status_parts $color_red ⇡$ahead:⇣$behind $color_reset"
        end

        if test $ahead -gt 0 -a $behind -eq 0
            set status_parts "$status_parts $color_red A:$ahead $color_reset"
        end

        if test $ahead -eq 0 -a $behind -gt 0
            set status_parts "$status_parts $color_red B:$behind $color_reset"
        end

        if test -z "$status_parts"
            set status_parts " $color_green $color_reset"
        end

        set status_parts (echo $status_parts | string trim)

        popd > /dev/null

        echo "$path,$branch,$status_parts\n"
    end

    function git-status-recurisve --description 'Outputs all git repositories with git status from current dir'
        # Find all Git repositories in the current directory and its subdirectories
        set repos (find . -type d -name '.git' | sed 's#/\.git$##')

        # Create the table rows
        set repo_lines
        for repo in $repos
            set abs_path (readlink -f "$repo")
            set status_line (git-status "$abs_path")
            set repo_lines "$repo_lines$status_line"
        end

        set repo (echo -e "$repo_lines" | column -t -N "Path,Branch/Tag,Status" -s ","  | fzf --ansi +m --header-lines=1 --preview-window=right:50% --preview='git -C {1} status | bat --color=always' --bind shift-up:preview-page-up,shift-down:preview-page-down)

        set repo_parts (string split ' ' $repo)
        if test -n "$repo_parts[1]"
            cd "$repo_parts[1]"
        end
    end

    bind \eg git-status-recurisve
end