#!/usr/bin/env bash

cat >/apps/data/supervisor.d/cron.conf <<EOF
[program:cron]
command=cron -f
autostart=true
autorestart=true
startretries=3
user=root
redirect_stderr=true
stdout_logfile=/var/log/supervisor/cron.log
stdout_logfile_maxbytes=50MB
stdout_logfile_backups=10
stderr_logfile=/var/log/supervisor/cron_error.log
stderr_logfile_maxbytes=50MB
stderr_logfile_backups=10
environment=TERM="xterm"
EOF
