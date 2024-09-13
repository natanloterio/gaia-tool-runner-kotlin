#!/bin/sh

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Error: Both PORT and JDBC_CONNECTION_STRING must be provided."
  exit 1
fi

export PORT=$1
export JDBC_CONNECTION_STRING=$2

docker build --progress=plain -t "gaia-tool-runner"  \
-f ./docker/tool-runner-controller/Dockerfile .

try() {
  docker stop gaia-tool-runner
  docker rm gaia-tool-runner
}
catch() {
  echo "An error occurred: $1"
}

docker run \
  -e PORT="$PORT" \
  -e JDBC_CONNECTION_STRING="$JDBC_CONNECTION_STRING" \
  -p "$PORT":"$PORT" \
  --privileged \
  --name gaia-tool-runner -d gaia-tool-runner
