#!/bin/bash

# Detect where script SOURCE is located
SCRIPT_ORIGPATH=`readlink -f "$(test -L "$0" && readlink "$0" || echo "$0")"`
SCRIPT_ORIGDIR=`dirname $SCRIPT_ORIGPATH`

HOSTNAME=rabbit-`hostname`

ip_ccsvps=$([ "`hostname`" == "ccsvps" ] && echo "127.0.0.1" || echo "62.109.17.171")
ip_dcccsast=$([ "`hostname`" == "dcccsast" ] && echo "127.0.0.1" || echo "46.229.223.203")
ip_dcccsapp=$([ "`hostname`" == "dcccsapp" ] && echo "127.0.0.1" || echo "46.229.223.208")
ip_dclvccsast=$([ "`hostname`" == "dclvccsast" ] && echo "127.0.0.1" || echo "195.13.217.92")
ip_dclvccsapp=$([ "`hostname`" == "dclvccsapp" ] && echo "127.0.0.1" || echo "195.13.217.93")

docker run \
    --rm \
    --name=rabbitmq \
    --hostname=$HOSTNAME \
    --add-host=rabbit-ccsvps:$ip_ccsvps \
    --add-host=rabbit-dcccsast:$ip_dcccsast \
    --add-host=rabbit-dcccsapp:$ip_dcccsapp \
    --add-host=rabbit-dclvccsast:$ip_dclvccsast \
    --add-host=rabbit-dclvccsapp:$ip_dclvccsapp \
    -p 4369:4369 \
    -p 5671-5672:5671-5672 \
    -p 25672:25672 \
    -p 35672-35682:35672-35682 \
    -p 15672:15672 \
    -p 61613-61614:61613-61614 \
    -p 1883:1883 \
    -p 8883:8883 \
    -p 15674-15675:15674-15675 \
    -p 15692:15692 \
    -v $SCRIPT_ORIGDIR/data:/var/lib/rabbitmq \
    -e RABBITMQ_ERLANG_COOKIE='IrFCimStSQUkwt5opBiw' \
    -e RABBITMQ_NODENAME=rabbit@$HOSTNAME \
    rabbitmq:management $@

#    -p 4369:4369 \   # epmd, a helper discovery daemon used by RabbitMQ nodes and CLI tools
#    -p 5671-5672:5671-5672 \   # used by AMQP 0-9-1 and 1.0 clients without and with TLS
#    -p 25672:25672 \ # used for inter-node and CLI tools communication (Erlang distribution server port)
#    -p 35672-35682:35672-35682 \ # HTTP API clients, management UI and rabbitmqadmin (only if the management plugin is enabled)
#    -p 15672:15672 \ # HTTP API clients, management UI and rabbitmqadmin (only if the management plugin is enabled)
#    -p 61613-61614:61613-61614 \ #  STOMP clients without and with TLS (only if the STOMP plugin is enabled)
#    -p 1883:1883 \ #  (MQTT clients without and with TLS, if the MQTT plugin is enabled
#    -p 8883:8883 \ #  (MQTT clients without and with TLS, if the MQTT plugin is enabled
#    -p 15674-15675:15674-15675 \ # STOMP-over-WebSockets clients (only if the Web STOMP plugin is enabled)
#    -p 15692:15692 \ # Prometheus metrics (only if the Prometheus plugin is enabled)
