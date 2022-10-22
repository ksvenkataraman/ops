#!/bin/bash

set -euxo pipefail

ffmpeg -i $1 -ab 320k -map_metadata 0 -id3v2_version 3 $2


