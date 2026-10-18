#!/bin/bash
set -euo pipefail
BASE=7700
HOST="${HOST:-$(curl -s ifconfig.me)}"

run_team() {
  local i=$1 pass=$2 name="team$1"
  docker rm -f "house-$name" >/dev/null 2>&1 || true
  docker run -d --init --name "house-$name" \
    --cpus 0.25 --memory 256m --pids-limit 128 \
    -p "$((BASE+i)):7681" \
    -e TEAM_USER="$name" -e TEAM_PASS="$pass" \
    haunted-house >/dev/null
}

# Reset one team's house:  ./launch_teams.sh reset 3
if [ "${1:-}" = "reset" ]; then
  i=$2
  pass=$(grep "^team$i," teams.csv | cut -d, -f3)
  run_team "$i" "$pass"
  echo "team$i has been reset."
  exit 0
fi

# Launch N teams:  ./launch_teams.sh 12
N=${1:-10}
docker build -t haunted-house .
echo "team,url,password" > teams.csv
for i in $(seq 1 "$N"); do
  pass=$(openssl rand -hex 3)
  run_team "$i" "$pass"
  echo "team$i,http://$HOST:$((BASE+i)),$pass" >> teams.csv
done
column -s, -t teams.csv