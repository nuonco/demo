#!/usr/bin/env bash

set -eo pipefail

env | sort | grep FOO

echo "FOO="$FOO
