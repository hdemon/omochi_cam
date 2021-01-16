#!/bin/sh

/usr/sbin/nginx -g "daemon off;" &
~/janus-gateway/plugins/streams/test_gstreamer_1.sh &
/opt/janus/bin/janus

