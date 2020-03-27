#!/bin/bash -ex

# gst-launch-1.0 videotestsrc ! autovideosink
# gst-launch-1.0 v4l2src device="/dev/video0" ! video/x-raw,width=640,height=480,framerate=30/1 ! autovideosink
# gst-launch-1.0 v4l2src device="/dev/video0" ! video/x-raw,width=640,height=480,framerate=30/1 ! videoconvert ! vp8enc ! rtpvp8pay ! udpsink host=3.84.134.247 port=5004

# gst-launch-1.0 v4l2src device="/dev/video0" ! video/x-raw,width=640,height=480,framerate=30/1 ! videoconvert ! x264enc tune=zerolatency bitrate=500 speed-preset=superfast ! rtph264pay ! udpsink host=3.84.134.247 port=8004
# gst-launch-1.0 v4l2src device="/dev/video0" ! video/x-raw,width=640,height=480 ! videoconvert ! vp8enc target-bitrate=128000 ! rtpvp8pay ! udpsink host=3.84.134.247 port=5004

# echo -n "hi2" >/dev/udp/3.84.134.247/5008
# gst-launch-1.0 v4l2src device="/dev/video0" ! video/x-raw,width=640,height=480 ! videoconvert ! vp8enc target-bitrate=128000 ! rtpvp8pay ! udpsink host=janus.shattered.services port=6004
gst-launch-1.0 v4l2src device="/dev/video0" ! video/x-raw,width=1280,height=720 ! videoconvert ! vp8enc target-bitrate=512000 ! rtpvp8pay ! udpsink host=janus.shattered.services port=6004

# gst-launch-1.0 pulsesrc ! audioconvert ! opusenc bitrate=64000 ! rtpopuspay ! udpsink host=janus.shattered.services port=6002
