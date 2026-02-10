#!/bin/sh

# convert Kubernetes ConfigMap to /etc/mopidy/mopidy.conf
[ -f /tmp/config/mopidy-input.yaml ] && python3 /usr/local/bin/yaml2ini

exec /usr/bin/python3 /usr/bin/mopidy --config /usr/share/mopidy/conf.d:/etc/mopidy/mopidy.conf
