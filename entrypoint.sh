#!/bin/bash
# Start the ghost AI as the guest user
runuser -u guest -- bash -c 'nohup /opt/ghost_ai.sh >/dev/null 2>&1 &'

# Web terminal with a per-team login
exec ttyd -p 7681 \
  -c "${TEAM_USER}:${TEAM_PASS}" \
  -t fontSize=18 \
  -t 'theme={"background":"#0b0b12","foreground":"#7CFC9A"}' \
  runuser -l guest