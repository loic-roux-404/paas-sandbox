#!/bin/bash
# Install dart sass embedded binary
# Deps
# - jq
# - wget
# - curl

REPO=sass/dart-sass-embedded
RELEASE=${2:-1.0.0-beta.5} # With form 0.0.1, ommit for latest
FORCE=1

parse_f() {
  [ $1 = '-f' ] && FORCE=0 || FORCE=1
}

get_release_obj() {
  jq_filter=".[0]" # Latest release
  if [[ ! -z ${RELEASE+x} ]]; then
    jq_filter=$(\
      printf '[ .[] | select( ."tag_name" | contains("%s")) ][0]'\
      ${RELEASE} )
  fi

  jq "${jq_filter}" <<<$(curl -H "Accept: application/vnd.github.v3+json" \
    --silent "https://api.github.com/repos/$REPO/releases")
}

install_dart_sass_version() {
  local platform=$1
  local dest=/usr/local/opt
  local bin=dart-sass-embedded
  local bin_dest=/usr/local/bin/${bin}
  local opt_dest=${dest}/sass_embedded/

  if [ -f $bin_dest ] && [ "$FORCE" -eq 1  ]; then return 0; fi
  [ -f $bin_dest ] && rm -rf $opt_dest || true
  echo "[ Installing Dart sass embedded ${REALEASE} ]"

  local url=$(get_release_obj \
    | grep "browser_download_url.*${platform}" \
    | cut -d : -f 2,3 \
    | tr -d \")
  wget -qO- ${url} | tar xvz - -C ${dest}
  # Symlink to bin to make it available in PATH
  ln -sf ${opt_dest}/${bin} ${bin_dest}
}

get_by_platform() {
  unameOut="$(uname -s)"
  case "${unameOut}" in
    Linux*)  install_dart_sass_version 'linux-x64' ;;
    Darwin*) install_dart_sass_version 'macos' ;;
    CYGWIN*) echo "Not available for Cygwin" ;;
    MINGW*)  echo "Not available for Mingw" ;;
    *)       machine="UNKNOWN:${unameOut}"
  esac
}

parse_f "${1:-''}"
get_by_platform
