#!/bin/bash

# Install go environment with go modules
# =======
# Target : vps / container / CI

# Dependencies
# - curl
# - brew (mac) / apt (ubuntu / debian)

PKG_MANAGER=${PKG_MANAGER:-apt}
SH_PATH=$(dirname "$0")
NODE_VERSION=${NODE_VERSION:-'engine'} # semantic version | lts | (latest / current)
YARN_VERSION=${YARN_VERSION:-''} # # semantic version | '' for latest
export N_PREFIX=${HOME}
SHELLS=()

determine_shells() {
  if command -v bash &> /dev/null; then SHELLS+=('bash'); fi
  if command -v fish &> /dev/null; then SHELLS+=('fish'); fi
}

# Install n (simple node version manager)
install_n() {
  shell_path() {
    for shell in ${SHELLS[@]}; do
      if [ $shell = 'fish' ]; then
        fish -c "set -U fish_user_paths $N_PREFIX/bin \$fish_user_paths"
      else
        echo 'export PATH="$PATH:$N_PREFIX/bin"' >> ${HOME}/.${shell}rc
        source ${HOME}/.${shell}rc
      fi
    done
  }

  local bin=/usr/local/bin/n
  echo '[ Install n : simple node version manager ]';
  mkdir -p ${N_PREFIX}

  if command -v n &> /dev/null; then echo '[ Already configured n ]';
  else
    curl -sSL https://raw.githubusercontent.com/tj/n/master/bin/n > ${bin} && chmod +x ${bin};
  fi

  echo "$PATH" | grep -q "${N_PREFIX}/bin" && echo '[ n_prefix already in PATH ]' || shell_path
}

install_node() {
  echo "[ node version asked : ${NODE_VERSION} ]"
  CURRENT_NODE_VERSION=''

  if command -v node &> /dev/null; then
    CURRENT_NODE_VERSION="$(node --version)"
    CURRENT_NODE_VERSION=${CURRENT_NODE_VERSION#v}
    echo "[ node ${CURRENT_NODE_VERSION} already installed ]";
  else
    if [ "engine" = "$NODE_VERSION" ]; then
      NODE_VERSION='lts'
    fi
    n install ${NODE_VERSION};
  fi

  if [ "$CURRENT_NODE_VERSION" != "$NODE_VERSION" ]; then
    n install ${NODE_VERSION};
  fi
  # Update npm
  npm install -g npm
}

install_yarn() {
  CURRENT_YARN_VERSION=''

  echo "[ yarn version asked : ${YARN_VERSION:-'latest'} ]"

  if command -v yarn &> /dev/null; then
    CURRENT_YARN_VERSION="$(yarn --version)"
    echo "[ yarn ${CURRENT_YARN_VERSION} already installed ]";
  else
    npm install --global yarn@${YARN_VERSION}
  fi

  if [ "$CURRENT_YARN_VERSION" != "$YARN_VERSION" ]; then
    npm install --global yarn@${YARN_VERSION}
  fi
}

determine_shells
install_n
install_node
install_yarn
