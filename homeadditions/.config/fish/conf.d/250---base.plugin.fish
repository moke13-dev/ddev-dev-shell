#!/usr/bin/fish
# ddev-generated

# display all ip addresses for this host
function ips
    if command -v ifconfig > /dev/null
        ifconfig | awk '/inet /{ gsub(/addr:/, ""); print $2 }'
    else if command -v ip > /dev/null
        ip addr | grep -oP 'inet \K[\d.]+'
    else
        echo "You don't have ifconfig or ip command installed!"
    end
end

# displays your ip address, as seen by the internet
function myip
    set -l list "http://myip.dnsomatic.com/" "http://checkip.dyndns.com/" "http://checkip.dyndns.org/"

    for url in $list
        set res (curl -fs "$url")
        if test -n "$res"
            break
        end
    end

    set res (echo "$res" | grep -Eo '[0-9\.]+')
    echo -e "Your public IP is: \e[1;32m$res\e[0m"
end

# make one or more directories and cd into the last one
function mkcd
    if test (count $argv) -eq 0
        echo "Usage: mkcd <directory1> [directory2] ... [directoryN]"
        return 1
    end

    mkdir -p -- $argv
    cd -- (echo $argv[-1])
end

# executes command quietly
function quiet
    $argv >/dev/null 2>&1 &
end