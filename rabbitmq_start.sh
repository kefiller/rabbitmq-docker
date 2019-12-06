#!/bin/bash

# Detect where script SOURCE is located
SCRIPT_ORIGPATH=`readlink -f "$(test -L "$0" && readlink "$0" || echo "$0")"`
SCRIPT_ORIGDIR=`dirname $SCRIPT_ORIGPATH`

HOSTNAME=rabbit-`hostname`

docker run \
    --rm \
    --name=rabbitmq \
    --hostname=$HOSTNAME \
    -p 5672:5672 \
    -p 15672:15672 \
    -v $SCRIPT_ORIGDIR/data:/var/lib/rabbitmq \
    -e RABBITMQ_ERLANG_COOKIE='IrFCimStSQUkwt5opBiw' \
    -e RABBITMQ_NODENAME=rabbit@$HOSTNAME \
    rabbitmq:management $@
