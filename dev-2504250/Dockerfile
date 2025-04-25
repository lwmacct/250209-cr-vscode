FROM ghcr.io/lwmacct/250209-cr-ubuntu:noble-t2502090

COPY --from=gcr.io/etcd-development/etcd:v3.5.21 /usr/local/bin/etcdctl /usr/local/bin/etcdctl
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
    curl -Lo - "https://golang.google.cn/dl/go1.24.2.linux-amd64.tar.gz" | tar zxf - -C /usr/local/;

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
        bpfcc-tools linux-tools-common linux-tools-generic \
        build-essential gcc make cmake automake ninja-build shc upx \
        strace ltrace valgrind \
        cron  direnv shellcheck fzf zfsutils-linux xxd \
        zsh redis-tools openssh-client supervisor \
        xarclock xvfb x11vnc dbus-x11 \
        umoci skopeo \
        ; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

RUN set -eux; \
    echo "python"; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        python3 python3-pip python3-venv python3-dotenv \
        python3-docker python3-dockerpty python3-dockerpycreds \
        python3-watchdog python3-psutil python3-cpuinfo python3-ping3 python3-schedule python3-pexpect \
        python3-nftables python3-pyudev python3-dmidecode \
        python3-paramiko python3-dnspython python3-scapy python3-netifaces python3-pysnmp-lextudio python3-plumbum \
        python3-etcd3 python3-redis python3-influxdb-client python3-apsw \
        python3-websockets python3-httpx python3-fastapi python3-uvicorn python3-pydantic \
        python3-requests python3-requests-unixsocket python3-requests-toolbelt python3-requests-oauthlib \
        python3-openssl python3-cryptography python3-bcrypt \
        python3-yaml python3-jinja2 python3-protobuf \
        python3-numpy python3-pandas \
        python3-prometheus-client python3-pyghmi \
        python3-urwid python3-urwid-readline python3-urwidtrees python3-urwid-utils \
        python3-rich python3-rich-click python3-textual; \
    python3 -m venv --system-site-packages /root/venv; \
    apt-get autoremove -y; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

RUN echo "软链接 cron.d" ; \
    rm -rf /etc/cron.d/; \
    ln -sf /apps/data/cron.d/ /etc/cron.d; \
    ln -sf /bin/bash /bin/sh; \
    mkdir -p /root/.ssh; \
    chmod 700 /root/.ssh; \
    echo "StrictHostKeyChecking no" >> /root/.ssh/config;

ENV PATH=/root/venv/bin:/usr/local/go/bin:/opt/fluent-bit/bin:/root/go/bin:$PATH
ENV TZ=Asia/Shanghai
ENV GOPROXY=https://goproxy.cn,direct
ENV GO111MODULE=on

WORKDIR /apps/data
COPY apps/ /apps/
ENTRYPOINT ["tini", "--"]
CMD ["sh", "-c", "bash /apps/.entry.sh & exec cron -f"]

LABEL org.opencontainers.image.source=https://github.com/lwmacct/250209-cr-vscode
LABEL org.opencontainers.image.description="专为 VSCode 容器开发环境构建"
LABEL org.opencontainers.image.licenses=MIT
