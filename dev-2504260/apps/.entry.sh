#!/usr/bin/env bash
# Admin https://www.yuque.com/lwmacct

__main() {
    {
        : # 初始化文件
        mkdir -p /apps/data/{workspace,logs,script,cron.d}
        tar -vcpf - -C /apps/file . | (cd / && tar -xpf - --skip-old-files)
        (cd /apps/data/workspace && go work init)
    } 2>&1 | tee /apps/data/logs/entry-tar.log

    {
        for _script in /apps/data/init.d/*.sh; do
            if [ -r "$_script" ]; then
                echo "Run $_script"
                # shellcheck disable=SC1090
                source "$_script"
            fi
        done
    } 2>&1 | tee -a /apps/data/logs/entry-init.log
    service cron reload
}

__main
