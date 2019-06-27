#!/bin/bash

if [ ! -f ~/.ssh/id_rsa.pub ]; then
    ssh-keygen -t rsa
fi

cat ~/.ssh/id_rsa.pub | ssh -p $1 $2 "
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh
    cat >> ~/.ssh/authorized_keys
    sort -u ~/.ssh/authorized_keys > ~/.ssh/authorized_keys.bak
    mv ~/.ssh/authorized_keys.bak ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
"

ssh -p $1 -n -o PasswordAuthentication=no $2 true
