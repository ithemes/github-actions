#!/bin/bash

rm -rf $1/tests
rm -rf $1/bin
find $1 -name '.git*' -print0 | xargs -0 -I {} rm -rf {}
find $1 -name 'grunt' -print0 | xargs -0 -I {} rm -rf {}
find $1 -name '.env' -type f -delete
find $1 -name 'Gruntfile.js' -type f -delete
find $1 -name 'phpunit.xml' -type f -delete
find $1 -name '.travis.yml' -type f -delete
find $1 -name 'package-lock.json' -type f -delete
find $1 -name 'composer.lock' -type f -delete
find $1 -maxdepth 1 -name '*.yml' -type f -delete
find $1 -name 'docker-compose.yml' -type f -delete
find $1 -name 'docker-compose.*.yml' -type f -delete
find $1 -name '.eslintignore' -type f -delete