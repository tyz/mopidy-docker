#!/bin/sh

# convert ConfigMap to /etc/mopidy/mopidy.conf
python3 /usr/local/bin/yaml2ini

exec /usr/bin/python3 /usr/bin/mopidy --config /usr/share/mopidy/conf.d:/etc/mopidy/mopidy.conf
