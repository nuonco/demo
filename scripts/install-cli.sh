#!/bin/bash

if [ "$NUON_DEBUG" = "true" ]
then
  set -x
fi

set -e
set -o pipefail
set -u

BASE_URL=https://nuon-artifacts.s3.us-west-2.amazonaws.com/cli
NAME=nuon

DIR=~/bin
if [ ! -d "$DIR" ]; then
  DIR=/usr/local/bin

  # fall back to /usr/local/bin
  if [ ! -d $DIR ]; then
    # fall back to /bin
    DIR=/bin
  fi
fi

echo "Installing nuon cli into $DIR"

echo "checking OS and Architecture..."
set +e
dpkg_path=$(which dpkg)
set -e
if [ "$dpkg_path" = "" ]
then
  ARCH=$(uname -m)
else
  ARCH=$(dpkg --print-architecture)
fi

if [ "$ARCH" = "x86_64" ]; then
  ARCH=amd64
fi

OS=$(uname -s |  awk '{print tolower($0)}')
echo "✅ using version ${OS}_${ARCH}..."

echo "calculating latest version..."
VERSION=$(curl -s $BASE_URL/latest.txt)
echo "✅ using version ${VERSION}..."

echo "fetching binary for ${OS} ${ARCH}..."
curl -s -o $DIR/$NAME $BASE_URL/$VERSION/${NAME}_${OS}_${ARCH}
echo "✅ fetching binary for ${OS} ${ARCH}..."

echo "making binary executable..."
chmod +x $DIR/$NAME
echo "✅ nuon should be ready to use"
