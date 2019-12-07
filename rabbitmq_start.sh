#!/bin/bash

# Detect where script SOURCE is located
SCRIPT_ORIGPATH=`readlink -f "$(test -L "$0" && readlink "$0" || echo "$0")"`
SCRIPT_ORIGDIR=`dirname $SCRIPT_ORIGPATH`

HOSTNAME=rabbit-`hostname`

docker run \
    --rm \
    --name=rabbitmq \
    --hostname=$HOSTNAME \
    --add-host=rabbit-ccsvps:62.109.17.171 \
    --add-host=rabbit-dcccsast:46.229.223.203 \
    --add-host=rabbit-dcccsapp:46.229.223.208 \
    --add-host=rabbit-dclvccsast:195.13.217.92 \
    --add-host=rabbit-dclvccsapp:195.13.217.93 \
    -p 5672:5672 \
    -p 15672:15672 \
    -v $SCRIPT_ORIGDIR/data:/var/lib/rabbitmq \
    -e RABBITMQ_ERLANG_COOKIE='IrFCimStSQUkwt5opBiw' \
    -e RABBITMQ_NODENAME=rabbit@$HOSTNAME \
    rabbitmq:management $@
