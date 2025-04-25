# shellcheck disable=all

__env() {
  _env_file="/root/.env"
  source $_env_file
  export $(cat $_env_file | awk -F= '{print $1}' | xargs -r -I {} echo {} | xargs)
}
__env
