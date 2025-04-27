# shellcheck disable=all

__load_taskfile_env() {
  {
    _task_env="$(find /apps/data/workspace -type f -path '*/.taskfile/.env.template' 2>/dev/null)"
    while IFS= read -r _env_file; do
      set -a
      source $_env_file
      set +a
    done <<<"$_task_env"
  }

  {
    _task_env="$(find /apps/data/workspace -type f -path '*/.taskfile/.env' 2>/dev/null)"
    while IFS= read -r _env_file; do
      set -a
      source $_env_file
      set +a
    done <<<"$_task_env"
  }

}

__main() {
  # 如有必要, 可以取消注释
  # __load_taskfile_env

  {
    _env_file="/root/.env"
    set -a
    source $_env_file
    set +a
  }

}
__main
