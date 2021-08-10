#!/bin/bash

# Install go environment with go modules
# =======
# Target : vps / container / CI

# Dependencies
# - curl
# - jq
# - brew (mac) / apt (ubuntu / debian)

# Defaults, we use env and gopackages list
PKG_MANAGER=${PKG_MANAGER:-apt}
SH_PATH=$(dirname "$0")
GO_VERSION=${GO_VERSION:-'latest'}
# Reexport an already set go env (used by g)
export GOPATH=${GOPATH:-'/opt/go/packages'}
export GOROOT=${GOROOT:-"/opt/go/go-$GO_VERSION"}
export GO111MODULE=${GO111MODULE:-'on'}
export CGO_ENABLED=1
# Source hugo site env
if [ ! -z ${ENV_FILE+x} ]; then source ${ENV_FILE}; fi

# Install g (simple go version manager)
install_g() {
  local script=/tmp/g-install
  echo '[ Install g : the go version manager ]';

  mkdir -p ${GOPATH} ${GOROOT};

  if command -v g &> /dev/null; then echo '[ Already configured g ]';
  else
    curl -sSL https://git.io/g-install > ${script} && chmod +x ${script};
    NON_INTERACTIVE=true ${script} -y fish bash zsh;
    rm -rf ${script};
  fi
}

# Install go
install_go() {
  CURRENT_GO_VERSION="$(go version | awk '{ print $3 }';)"
  CURRENT_GO_VERSION=${CURRENT_GO_VERSION#go}

  echo "[ Go version asked : ${GO_VERSION} ]"

  if command -v go &> /dev/null; then echo '[ go already installed ]';
  else
    g install -y ${GO_VERSION};
  fi

  if [ "$CURRENT_GO_VERSION" != "$GO_VERSION" ]; then
    g install -y ${GO_VERSION};
  fi
}

# Arg 1 : json of packages
# @Example :
# {
#    "name": "github.com/gohugoio/hugo",
#    "version": "$HUGO_VERSION", // If shell / env variable exist it will be used
#    "flags": "--tags extended,other-tag",
#    "deps": [
#      "gcc",
#      "g++",
#      "dart-sass-embedded.sh" // (Custom script to install a binary)
#    ],
#    "state": "present" // absent to uninstall
# }
install_single_gopackage() (
    # Use environment variable if it exists
    # Return empty if version is invalid
    function set_version() {
      local version=${1#'$'}
      local final_v="${!version:-$version}"
      [[ $final_v =~ ^[0-9]+\.[0-9]+ ]] && echo $final_v
    }

    function install_single_build_dep() {
      local dep=${1#.sh}
      local manager=$2
      echo "[ Processing associated dependency : $dep]";

      if $(eval command -v ${dep} &>/dev/null;); then
        echo "[ Already installed dependency : $dep]";
        return 0
      fi

      local script_dep=$(eval printf "%s/%s" ${SH_PATH} ${dep};)
      if [ -f $script_dep ]; then
        ./$script_dep;
      else
        eval "${manager} ${dep}";
      fi
    }
    # Install required deps to build go package
    function build_deps() {
      unameOut="$(uname -s;)"
      # loop dependencies
      jq -c '.[]' <<<$1 | while read dep; do
        case "${unameOut}" in
          Linux*)  install_single_build_dep "${dep}" "${PKG_MANAGER} install -y ";;
          Darwin*) install_single_build_dep "${dep}" "brew install ";;
          CYGWIN*) echo "Not available for Cygwin";;
          MINGW*)  echo "Not available for Mingw";;
          *)       machine="UNKNOWN:${unameOut}"
        esac
      done
    }
    # Var Assigments
    local name=$(jq -r '.name' <<<$1;)
    local version=$(jq -r '.version' <<<$1;)
    # Check if version is env variable
    version=$(set_version "$version")
    # Additional command flags
    local flags=$(jq -r '.flags' <<<$1;)
    local deps=$(jq -r '.deps' <<<$1;)
    # State and default value
    local state=$(jq -r '.state' <<<$1;)
    local state=${state:-present}
    # Get the single binary exe
    local bin_name=$(echo $name | tr "/" " " | awk '{print $3}';)

    # Check correct version
    function validate_version() {
      if [ -z ${1} ]; then
        echo "[ Invalid version $1, check if env variable is defined ]";
        exit 1;
      fi
    }

    echo "[ Process go package : ${name}@${version} ]";
    validate_version $version;
    build_deps "$deps";

    # Create the binary
    if [ "$state" = "present"  ]; then
      go get ${flags} ${name}@v${version};
    elif [ "$state" = "absent"  ]; then
      rm -f ${GOPATH}/bin/${bin_name} ${GOPATH}/pkg/mod/${name};
    fi
)

# Loop packages and install
gopackages() {
  local deps_file="${SH_PATH}/gopackages.json"

  jq -c '.[]' ${deps_file} | while read package; do
    install_single_gopackage "$package";
  done
}

install_g;
install_go;
gopackages;

[ $? -eq 0 ] && echo "[ DONE : Installed go stack ]" || exit $?
