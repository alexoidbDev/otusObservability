#!/bin/bash
set -o errexit   # abort on nonzero exit status
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

vagrant up database storage monitor
vagrant up --parallel app-node-1 app-node-2 app-node-3
vagrant up balancer
