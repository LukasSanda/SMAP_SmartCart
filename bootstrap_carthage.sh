#!/usr/bin/env bash

set -e

osascript -e 'display notification "Carthage build started" with title "Carthage"'

/usr/local/bin/carthage bootstrap --platform ios --no-use-binaries --cache-builds

osascript -e 'display notification "Carthage build is done" with title "Carthage"'
