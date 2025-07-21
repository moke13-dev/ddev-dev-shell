#!/bin/bash

# update_github_installer_urls.sh
# Searches all Dockerfiles for github-installer calls, fetches current download URLs, and replaces the calls.

set -euo pipefail

# ENTRY_* definitions (extend as needed)
declare -A ENTRY_1=(
  [dockerfile]="Dockerfile.200---neovim"
  [user]="neovim"
  [repo]="neovim"
  [file]="nvim-linux-$(uname -m).tar.gz"
  [bin]="bin/nvim"
)
declare -A ENTRY_2=(
  [dockerfile]="Dockerfile.250---bat"
  [user]="sharkdp"
  [repo]="bat"
  [file]="bat-(.*)-$(uname -m)-unknown-linux-gnu.tar.gz"
  [bin]="bat"
)
declare -A ENTRY_3=(
  [dockerfile]="Dockerfile.250---btop"
  [user]="aristocratos"
  [repo]="btop"
  [file]="btop-$(uname -m)-linux-musl.tbz"
  [bin]="bin/btop"
)
declare -A ENTRY_4=(
  [dockerfile]="Dockerfile.250---diskusage"
  [user]="chenquan"
  [repo]="diskusage"
  [file]="diskusage-v(.*)linux-amd64\.tar\.gz"
  [bin]="diskusage"
)
declare -A ENTRY_5=(
  [dockerfile]="Dockerfile.250---difft"
  [user]="Wilfred"
  [repo]="difftastic"
  [file]="difft-$(uname -m)-unknown-linux-gnu.tar.gz"
  [bin]="difft"
)
declare -A ENTRY_6=(
  [dockerfile]="Dockerfile.250---direnv"
  [user]="direnv"
  [repo]="direnv"
  [file]="direnv.linux-amd64"
  [bin]="direnv"
)
declare -A ENTRY_7=(
  [dockerfile]="Dockerfile.250---eza"
  [user]="eza-community"
  [repo]="eza"
  [file]="eza_$(uname -m)-unknown-linux-gnu.tar.gz"
  [bin]="eza"
)
declare -A ENTRY_8=(
  [dockerfile]="Dockerfile.250---fd"
  [user]="sharkdp"
  [repo]="fd"
  [file]="fd-(.*)-$(uname -m)-unknown-linux-gnu.tar.gz"
  [bin]="fd"
)
declare -A ENTRY_9=(
  [dockerfile]="Dockerfile.250---glow"
  [user]="charmbracelet"
  [repo]="glow"
  [file]="glow_(.*)_Linux_$(uname -m).tar.gz"
  [bin]="glow"
)
declare -A ENTRY_10=(
  [dockerfile]="Dockerfile.250---gitleaks"
  [user]="gitleaks"
  [repo]="gitleaks"
  [file]="gitleaks_(.*)8.24.0_linux_x64.tar.gz"
  [bin]="gitleaks"
)
declare -A ENTRY_11=(
  [dockerfile]="Dockerfile.250---grex"
  [user]="pemistahl"
  [repo]="grex"
  [file]="grex-v(.*)-$(uname -m)-unknown-linux-musl.tar.gz"
  [bin]="grex"
)
declare -A ENTRY_12=(
  [dockerfile]="Dockerfile.250---fzf"
  [user]="junegunn"
  [repo]="fzf"
  [file]="fzf-(.*)-linux_amd64\.tar\.gz"
  [bin]="fzf"
)
declare -A ENTRY_13=(
  [dockerfile]="Dockerfile.250---lazygit"
  [user]="jesseduffield"
  [repo]="lazygit"
  [file]="lazygit_(.*)_Linux_$(uname -m).tar.gz"
  [bin]="lazygit"
)
declare -A ENTRY_14=(
  [dockerfile]="Dockerfile.250---lazysql"
  [user]="jorgerojas26"
  [repo]="lazysql"
  [file]="lazysql_Linux_$(uname -m).tar.gz"
  [bin]="lazysql"
)
declare -A ENTRY_15=(
  [dockerfile]="Dockerfile.250---navi"
  [user]="denisidoro"
  [repo]="navi"
  [file]="navi-v(.*)-$(uname -m)-unknown-linux-musl.tar.gz"
  [bin]="navi"
)
declare -A ENTRY_16=(
  [dockerfile]="Dockerfile.250---oha"
  [user]="hatoo"
  [repo]="oha"
  [file]="oha-linux-amd64"
  [bin]="oha"
)
declare -A ENTRY_17=(
  [dockerfile]="Dockerfile.250---ouch"
  [user]="ouch-org"
  [repo]="ouch"
  [file]="ouch-$(uname -m)-unknown-linux-gnu.tar.gz"
  [bin]="ouch"
)
declare -A ENTRY_18=(
  [dockerfile]="Dockerfile.250---rustscan"
  [user]="bee-san"
  [repo]="RustScan"
  [file]="$(uname -m)-linux-rustscan.tar.gz.zip"
  [bin]="rustscan"
)
declare -A ENTRY_19=(
  [dockerfile]="Dockerfile.250---tailspin"
  [user]="bensadeh"
  [repo]="tailspin"
  [file]="tailspin-$(uname -m)-unknown-linux-musl.tar.gz"
  [bin]="tspin"
)
declare -A ENTRY_20=(
  [dockerfile]="Dockerfile.250---duf"
  [user]="muesli"
  [repo]="duf"
  [file]="duf_(.*)_linux_$(uname -m).tar.gz"
  [bin]="duf"
)
declare -A ENTRY_21=(
  [dockerfile]="Dockerfile.250---zoxide"
  [user]="ajeetdsouza"
  [repo]="zoxide"
  [file]="zoxide-(.*)-$(uname -m)-unknown-linux-musl.tar.gz"
  [bin]="zoxide"
)


# Automatically collect all ENTRY_* variables into the ENTRIES array
ENTRIES=()
for var in $(compgen -A variable | grep '^ENTRY_'); do
  ENTRIES+=("$var")
done



# Determine the absolute project root directory (one level above the script directory) without using cd
SCRIPT_DIR="$(realpath "$(dirname -- "${BASH_SOURCE[0]}")")"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"



for entry_name in "${ENTRIES[@]}"; do
  declare -n entry="$entry_name"
  dockerfile="${entry[dockerfile]}"
  user="${entry[user]}"
  repo="${entry[repo]}"
  file="${entry[file]}"
  bin="${entry[bin]}"
  # Resolve dockerfile path relative to the project root
  dockerfile_path="$PROJECT_ROOT/web-build/$dockerfile"
  if [[ ! -f "$dockerfile_path" ]]; then
    echo "WARN: $dockerfile_path not found, skipping."
    continue
  fi
  URL=$(curl -sL "https://api.github.com/repos/$user/$repo/releases/latest" \
    | jq -r --arg file "$file" '.assets[] | select(.name | test($file)) | .browser_download_url' \
    | head -n 1)
  if [[ -z "$URL" ]]; then
    echo "WARN: No URL found for $user/$repo ($file) in $dockerfile_path" >&2
    continue
  fi
  # Replace any line starting with RUN (optional) and qemo-github-installer (robust replacement)
  ESCAPED_URL=$(printf '%s\n' "$URL" | sed 's/[&/]/\\&/g')
  REPLACEMENT="RUN qemo-github-installer -u $user -r $repo -U $ESCAPED_URL"
  [[ -n "$bin" ]] && REPLACEMENT="$REPLACEMENT -b $bin"
  sed -i -E "/^\s*RUN\s+qemo-github-installer/ s|^.*$|$REPLACEMENT|" "$dockerfile_path"
  echo "Updated: $dockerfile_path: $REPLACEMENT"
done

echo "All Dockerfiles have been updated."
