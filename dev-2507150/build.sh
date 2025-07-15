#!/usr/bin/env bash
# shellcheck disable=SC2317
# document https://www.yuque.com/lwmacct/docker/buildx

__main() {
  {
    _sh_path=$(realpath "$(ps -p $$ -o args= 2>/dev/null | awk '{print $2}')") # 当前脚本路径
    _pro_name=$(echo "$_sh_path" | awk -F '/' '{print $(NF-2)}')               # 当前项目名
    _dir_name=$(echo "$_sh_path" | awk -F '/' '{print $(NF-1)}')               # 当前目录名
    _image="${_pro_name}:$_dir_name"
  }

  _dockerfile=$(
    cat <<"EOF"
FROM ghcr.io/lwmacct/250209-cr-ubuntu:noble-t2506180

COPY --from=gcr.io/etcd-development/etcd:v3.6.2 /usr/local/bin/etcdctl /usr/local/bin/etcdctl
RUN set -eux; \
    echo "安装 docker-cli https://docs.docker.com/engine/install/ubuntu/"; \
    install -m 0755 -d /etc/apt/keyrings; \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc; \
    chmod a+r /etc/apt/keyrings/docker.asc; \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null; \
    apt-get update && apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin docker-buildx-plugin; \
    rm -rf /etc/apt/sources.list.d/docker.list; \
    rm -rf /etc/apt/keyrings/docker.asc; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

RUN set -eux; \
    echo "安装 Golang https://golang.google.cn/dl/"; \
    curl -Lo - "https://golang.google.cn/dl/go1.24.5.linux-amd64.tar.gz" | tar zxf - -C /usr/local/; \
    /usr/local/go/bin/go install mvdan.cc/sh/v3/cmd/shfmt@latest;

RUN set -eux; \
    echo "安装 Minio Client https://min.io/docs/minio/linux/reference/minio-mc.html"; \
    curl -Lo /usr/local/bin/mc "https://dl.min.io/client/mc/release/linux-amd64/mc"; \
    chmod +x /usr/local/bin/mc;

RUN set -eux; \
    echo "Installing Node.js and npm"; \
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - ; \
    apt-get install -y nodejs; \
    rm -rf /etc/apt/sources.list.d/nodesource.list; \
    npm -v; \
    npm install -g npm@latest; \
    npm -v; \
    npm install -g @go-task/cli; \
    npm install -g vitest@latest; \
    npm install -g vue-tsc@latest; \
    npm install -g yarn@latest; \
    npm install -g pnpm@latest-10; \
    npm install -g prettier@latest; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

RUN set -eux; \
    echo 'https://github.com/cli/cli#installation'; \
    (type -p wget >/dev/null || (sudo apt update && sudo apt-get install wget -y)) \
    && sudo mkdir -p -m 755 /etc/apt/keyrings \
    && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && sudo apt update \
    && sudo apt install gh -y; \
    rm -rf  /usr/share/keyrings/githubcli-archive-keyring.gpg /etc/apt/sources.list.d/github-cli.list; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

RUN set -eux; \
    echo 'install oh-my-zsh'; \
    git clone https://github.com/ohmyzsh/ohmyzsh.git /opt/ohmyzsh; \
    git clone https://github.com/zsh-users/zsh-autosuggestions.git /opt/ohmyzsh/custom/plugins/zsh-autosuggestions; \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /opt/ohmyzsh/custom/plugins/zsh-syntax-highlighting; \
    git clone https://github.com/zsh-users/zsh-completions.git /opt/ohmyzsh/custom/plugins/zsh-completions; \
    git clone https://github.com/jimhester/per-directory-history.git /opt/ohmyzsh/custom/plugins/per-directory-history; \
    git clone https://github.com/zsh-users/zsh-history-substring-search.git /opt/ohmyzsh/custom/plugins/zsh-history-substring-search; \
    git clone https://github.com/MichaelAquilina/zsh-you-should-use.git /opt/ohmyzsh/custom/plugins/you-should-use; \
    git clone https://github.com/changyuheng/zsh-interactive-cd.git /opt/ohmyzsh/custom/plugins/zsh-interactive-cd; \
    git clone https://github.com/romkatv/powerlevel10k.git /opt/ohmyzsh/custom/themes/powerlevel10k; \
    find /opt/ohmyzsh/ -type d -name '.git'; \
    find /opt/ohmyzsh/ -type d -name '.git' | xargs -r rm -rf;

RUN set -eux; \
    echo "安装 fluent-bit"; \
    curl https://raw.githubusercontent.com/fluent/fluent-bit/master/install.sh | sh; \
    apt-get autoremove -y; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

RUN set -eux; \
    echo "常用包安装"; \
    apt-get update; apt-get install -y --no-install-recommends \
        bpfcc-tools linux-tools-common \
        build-essential gcc make cmake automake ninja-build shc upx \
        file strace ltrace valgrind netcat-openbsd \
        git-lfs cron direnv shellcheck fzf zfsutils-linux xxd \
        zsh redis-tools openssh-client supervisor \
        xarclock xvfb x11vnc dbus-x11 \
        dnsutils \
        asciinema \
        umoci skopeo \
        ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

RUN set -eux; \
    echo "python"; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        python3 python3-pip python3-venv python3-dotenv \
        python3-yaml \
        flake8 python3-flake8 python3-autopep8 \
        python3-requests python3-requests-unixsocket \
        python3-openssl python3-bcrypt; \
    python3 -m venv --system-site-packages /opt/venv; \
    apt-get autoremove -y; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

RUN set -eux; \
    echo "pip 安装"; \
    /opt/venv/bin/pip config set global.index-url https://mirrors.ustc.edu.cn/pypi/simple; \
    /opt/venv/bin/pip install --upgrade pip; \
    /opt/venv/bin/pip install --no-cache-dir uv "mcp[cli]"; \
    echo;

RUN echo "软链接 cron.d" ; \
    rm -rf /etc/cron.d/; \
    ln -sf /apps/data/cron.d/ /etc/cron.d; \
    ln -sf /bin/bash /bin/sh; \
    mkdir -p /root/.ssh; \
    chmod 700 /root/.ssh; \
    echo "StrictHostKeyChecking no" >> /root/.ssh/config;

ENV PATH=/usr/local/go/bin:/opt/venv/bin:/opt/fluent-bit/bin:/root/go/bin:$PATH
ENV TZ=Asia/Shanghai
ENV PYTHONDONTWRITEBYTECODE=1
ENV GOPROXY=https://goproxy.cn,direct
ENV GO111MODULE=on

WORKDIR /apps/data
COPY apps/ /apps/
ENTRYPOINT ["tini", "--"]
CMD ["sh", "-c", "bash /apps/.entry.sh & exec cron -f"]

LABEL org.opencontainers.image.source=$_ghcr_source
LABEL org.opencontainers.image.description="专为 VSCode 容器开发环境构建"
LABEL org.opencontainers.image.licenses=MIT
EOF
  )
  {
    cd "$(dirname "$_sh_path")" || exit 1
    echo "$_dockerfile" >Dockerfile

    _ghcr_source=$(sed 's|git@github.com:|https://github.com/|' ../.git/config | grep url | sed 's|.git$||' | awk '{print $NF}')
    sed -i "s|\$_ghcr_source|$_ghcr_source|g" Dockerfile
  }
  {
    if command -v sponge >/dev/null 2>&1; then
      jq 'del(.credsStore)' ~/.docker/config.json | sponge ~/.docker/config.json
    else
      jq 'del(.credsStore)' ~/.docker/config.json >~/.docker/config.json.tmp && mv ~/.docker/config.json.tmp ~/.docker/config.json
    fi
  }
  {
    _registry="ghcr.io/lwmacct" # CR 服务平台
    _repository="$_registry/$_image"
    docker buildx build --builder default --platform linux/amd64 -t "$_repository" --network host --progress plain --load . && {
      if false; then
        docker rm -f sss
        docker run -itd --name=sss \
          --restart=always \
          --network=host \
          --privileged=false \
          "$_repository"
        docker exec -it sss bash
      fi
    }
    docker push "$_repository"

  }
}

__main

__help() {
  cat >/dev/null <<"EOF"
这里可以写一些备注

ghcr.io/lwmacct/250209-cr-vscode:dev-2507150

EOF
}
