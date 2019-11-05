#!/usr/bin/env bash

set -e

osascript -e 'display notification "Carthage update started" with title "Carthage"'

/usr/local/bin/carthage update --platform iOS --no-use-binaries --cache-builds

osascript -e 'display notification "Carthage update is done" with title "Carthage"'
