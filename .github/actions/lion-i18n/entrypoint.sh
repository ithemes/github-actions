#!/bin/bash

find ../. -type f | xargs sed -i "s/\([Tt]ext [Dd]omain:\s*\)LION\b/\1it-l10n-$INPUT_TEXTDOMAIN/"
find ../. -type f | xargs sed -i "s/\(['\"]\)LION\(['\"]\)/\1it-l10n-$INPUT_TEXTDOMAIN\2/"