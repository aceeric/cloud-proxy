#!/bin/sh

./stunnel stunnel.conf
./tinyproxy -d -c ./tinyproxy.conf
