#!/usr/bin/env bash
if [[ ! -f id_rsa.pub ]]; then
    ssh-keygen -t rsa -N "" -f id_rsa
fi
docker build --rm=true -t $USER/centos:galera .
