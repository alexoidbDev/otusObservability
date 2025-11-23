#!/bin/bash
set -o errexit   # abort on nonzero exit status
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

FILENAME="./conf/telegram.token"
if [ ! -f "$FILENAME" ]; then
    echo "Please enter telegram token:"
    read TOKEN
    echo $TOKEN > $FILENAME
fi


vagrant up database storage monitor
vagrant up --parallel app-node-1 app-node-2
vagrant up balancer
