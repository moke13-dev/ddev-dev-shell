#!/usr/bin/fish
# ddev-generated

if command -v navi > /dev/null
    if not test -d "/mnt/ddev-global-cache/navi"
        mkdir -p "/mnt/ddev-global-cache/navi"
        git clone https://github.com/denisidoro/cheats.git /mnt/ddev-global-cache/navi/cheats
        git clone https://github.com/denisidoro/navi-tldr-pages.git /mnt/ddev-global-cache/navi/navi-tldr-pages
        git clone https://github.com/denisidoro/dotfiles.git /mnt/ddev-global-cache/navi/dotfiles
        git clone https://github.com/papanito/cheats.git /mnt/ddev-global-cache/navi/cheats
    end

    navi widget fish | source
end

