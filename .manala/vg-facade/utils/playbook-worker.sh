#!/bin/bash
# ==========
# Playbook worker script
# Execute playbook from a virtual environement
# Usage :
#   ./playbook-worker.sh or globally : mv playbook-worker.sh /usr/local/bin/playbook-worker
# Arguments :
#   $1 : <git playbook url> Example: "https://github.com/g4-dev/playbook-ecs"
#   $2 : <inventory name> (corresponding to inventories path in playbook root) Example: "dev"
#   $3 : <custom sub playbook> Example: "database" (without the .yml)
# ==========
# TODO: check function python3 / ansible
# TOTEST

run_playbook(){
    PLAYBOOK=$2 || "site.yml"
    if [ ! -z "$3" ]; then
        ansible-playbook -K -i ./inventories/$3 $PLAYBOOK
    else
        ansible-playbook -K $PLAYBOOK
    fi
}

required(){
    if [ -z `python3 --version` ];then
        exit_error "Need a python 3 executable"
    fi

    if [ -z "$1" ]; then
        exit_error "Should at least provide a git playbook url";
    fi
}

playbook_check(){
    if [ -z "$2" ] && [ -z `ls ./inventories/$2` ]; then
        exit_error "This inventory doesn't exist";
    fi

    if [ -z "$1" ] && [ -z `ls ./$1.yml` ]; then
        exit_error "This playbook doesn't exist";
    fi
}

init_playbook() {
  cd /tmp
  PLAYBOOK_FOLDER=`ls $(basename "$1" .git)`
  if [ ! -z "$PLAYBOOK_FOLDER" ]; then
    cd $PLAYBOOK_FOLDER
    git fetch origin master && git reset --hard origin/master
    return
  fi

  git clone "$1" && cd "$(basename "$1" .git)"
}

exit_error() {
    echo -e "\e[01;31m$1\e[0m" >&2;
    exit 1;
}

# Verify arguments
required $1
# Clone or update playbook
init_playbook $1
# verify playbook
playbook_check $2 $3
# Execute it
run_playbook $1 $2 $3
