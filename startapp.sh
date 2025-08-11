#!/bin/sh -f

# The IMAGE_PATH variable is important as the Galaxy IT is inserting the user-chosen file into this path.

HOME="/tmp"
_JAVA_OPTIONS="-Duser.home=${HOME} -Djavafx.cachedir=/tmp" exec /opt/qupath/QuPath/bin/QuPath --image "${IMAGE_PATH}" --quiet
