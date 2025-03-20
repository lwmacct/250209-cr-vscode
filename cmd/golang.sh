#!/usr/bin/env bash

__main() {

  {
    # 镜像准备
    _image1="ghcr.io/lwmacct/250209-cr-vscode:dev-2503200"
    _image2="$(docker images -q $_image1)"
    if [[ "$_image2" == "" ]]; then
      docker pull $_image1
      _image2="$(docker images -q $_image1)"
    fi
  }

  _name="250209-go-module"
  _app_data="/data/project/$_name"

  docker rm -f $_name 2>/dev/null || true
  docker run -itd \
    --name=$_name \
    --hostname=$_name \
    --restart=always \
    --ipc=host \
    --network=host \
    --cgroupns=host \
    --privileged=true \
    --security-opt apparmor=unconfined \
    -v /dev:/dev \
    -v /proc/:/host/proc \
    -v /run/:/host/run \
    -v /data:/data \
    -v /data/library/android-sdk:/opt/android-sdk \
    -v "$_app_data:/apps/data" \
    -v "$_app_data/.vscode-server/root:/root" \
    -v "$_app_data/.vscode-server/data:/root/.vscode-server/data" \
    -v "$_app_data/.cursor-server/data:/root/.cursor-server/data" \
    -v cursor-server:/root/.cursor-server \
    -v vscode-server:/root/.vscode-server \
    -v vscode-root-go:/root/go \
    -v vscode-root-cache:/root/.cache \
    "$_image2"

}

__main
