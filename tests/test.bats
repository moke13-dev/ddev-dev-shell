setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-addon-template
  mkdir -p $TESTDIR
  export PROJNAME=test-addon-template
  export DDEV_NONINTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  ddev start -y >/dev/null
}

health_checks() {
  # Checks if core shell tools are available and the container is responsive
  ddev exec "curl -s https://localhost:443/"
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev add-on get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev add-on get ${DIR}
  ddev restart
  health_checks
}

# bats test_tags=release
@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev add-on get moke13-dev/ddev-dev-shell with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev add-on get moke13-dev/ddev-dev-shell
  ddev restart >/dev/null
  health_checks
}

# Tool availability checks
@test "fish is installed" {
  run ddev ssh -c "fish --version"
  [ "$status" -eq 0 ]
}

@test "starship is installed" {
  run ddev ssh -c "starship --version"
  [ "$status" -eq 0 ]
}

@test "nvim is installed" {
  run ddev ssh -c "nvim --version"
  [ "$status" -eq 0 ]
}

@test "lazygit is installed" {
  run ddev ssh -c "lazygit --version"
  [ "$status" -eq 0 ]
}

@test "eza is installed" {
  run ddev ssh -c "eza --version"
  [ "$status" -eq 0 ]
}

@test "bat is installed" {
  run ddev ssh -c "bat --version"
  [ "$status" -eq 0 ]
}

@test "fd is installed" {
  run ddev ssh -c "fd --version"
  [ "$status" -eq 0 ]
}

@test "fzf is installed" {
  run ddev ssh -c "fzf --version"
  [ "$status" -eq 0 ]
}

@test "glow is installed" {
  run ddev ssh -c "glow --version"
  [ "$status" -eq 0 ]
}

@test "btop is installed" {
  run ddev ssh -c "btop --version"
  [ "$status" -eq 0 ]
}

@test "duf is installed" {
  run ddev ssh -c "duf --version"
  [ "$status" -eq 0 ]
}

@test "zoxide is installed" {
  run ddev ssh -c "zoxide --version"
  [ "$status" -eq 0 ]
}

@test "direnv is installed" {
  run ddev ssh -c "direnv --version"
  [ "$status" -eq 0 ]
}

@test "grex is installed" {
  run ddev ssh -c "grex --version"
  [ "$status" -eq 0 ]
}

@test "navi is installed" {
  run ddev ssh -c "navi --version"
  [ "$status" -eq 0 ]
}

@test "ouch is installed" {
  run ddev ssh -c "ouch --version"
  [ "$status" -eq 0 ]
}

@test "rustscan is installed" {
  run ddev ssh -c "rustscan --version"
  [ "$status" -eq 0 ]
}

@test "tailspin is installed" {
  run ddev ssh -c "tspin --version"
  [ "$status" -eq 0 ]
}

@test "diskusage is installed" {
  run ddev ssh -c "diskusage --version"
  [ "$status" -eq 0 ]
}

@test "difft is installed" {
  run ddev ssh -c "difft --version"
  [ "$status" -eq 0 ]
}

@test "gitleaks is installed" {
  run ddev ssh -c "gitleaks --version"
  [ "$status" -eq 0 ]
}

@test "has is installed" {
  run ddev ssh -c "has --version"
  [ "$status" -eq 0 ]
}

@test "lazysql is installed" {
  run ddev ssh -c "lazysql --version"
  [ "$status" -eq 0 ]
}

@test "oha is installed" {
  run ddev ssh -c "oha --version"
  [ "$status" -eq 0 ]
}

@test "qemo-github-installer is available and shows help" {
  run ddev ssh -c "/usr/local/bin/qemo-github-installer --help"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage"* || "$output" == *"usage"* ]]
}

@test "application autocompletion script is present and executable" {
  run ddev ssh -c "test -x /usr/local/bin/qemo-app-autocompletion"
  [ "$status" -eq 0 ]
}

@test "application autocompletion shows help" {
  run ddev ssh -c "/usr/local/bin/qemo-app-autocompletion --help"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Usage"* || "$output" == *"usage"* ]]
}
