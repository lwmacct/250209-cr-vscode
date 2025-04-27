# shellcheck disable=all

__load_taskfile_env() {
  {
    # 加载 .env.template 文件
    _task_env="$(find /apps/data/workspace/*/.taskfile/ -maxdepth 1 -type f -name '.env.template' 2>/dev/null)"
    while IFS= read -r _env_file; do
      if [[ -f $_env_file ]]; then
        set -a
        source $_env_file
        set +a
      fi
    done <<<"$_task_env"
  }

  {
    # 加载 .env 文件
    _task_env="$(find /apps/data/workspace/*/.taskfile/ -maxdepth 1 -type f -name '.env' 2>/dev/null)"
    while IFS= read -r _env_file; do
      if [[ -f $_env_file ]]; then
        set -a
        source $_env_file
        set +a
      fi
    done <<<"$_task_env"
  }

}

__main() {
  # 如有必要, 可以取消注释
  __load_taskfile_env

  {
    _env_file="/root/.env"
    set -a
    source $_env_file
    set +a
  }

}
__main
