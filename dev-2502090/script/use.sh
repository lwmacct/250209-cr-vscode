#!/usr/bin/env bash

__main() {
    {
        _name="sss"
        _data="/data/project/$_name"
        _image1="registry.cn-hangzhou.aliyuncs.com/lwmacct/vscode:dev-t2406210"
        _docker_id=$(docker info 2>/dev/null | grep 'ID:' | awk '{print $NF}')
        _image2="i:$(echo "$_docker_id:$_image1:$_name" | md5sum | cut -c1-6)"
        # docker rmi "$_image2" 2>/dev/null || true
        if [[ "$(docker images "$_image2" | wc -l)" != "2" ]]; then
            docker pull $_image1 && docker tag "$_image1" "$_image2"
        fi
    }

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
        -v "$_data:/apps/data" \
        -v "$_data/.vscode-server/root:/root" \
        -v "$_data/.vscode-server/data:/root/.vscode-server/data" \
        -v vscode-server:/root/.vscode-server \
        -v vscode-root-go:/root/go \
        -v vscode-root-cache:/root/.cache \
        "$_image2"
}

__main
