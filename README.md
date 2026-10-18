# HerAI_Halloween_Workshop_F2026
Haunted house Linux CLI escape room for Fall 2026 Halloween-themed workshop

A Halloween escape room that teaches Linux and command line skills. Built for
**Halloween with HerAI** by HerAI (Women in AI and Machine Learning).

Teams are trapped in a haunted house run by a Ghost AI. The only way out is through the terminal: explore
rooms, hunt for keys, and shut GHOST down before midnight.


## How It Works

Each team gets its own Docker container running the haunted house, accessed
through a browser-based terminal ([ttyd](https://github.com/tsl0922/ttyd)).
Participants only need a laptop and a web browser. There's nothing to install,
no SSH, and no Linux machine required.

Teams unlock each door with `check <room> <key>`.

## Repository Contents

| File | Purpose |
|---|---|
| `Dockerfile` | Builds the image with the house baked in |
| `build_house.sh` | Creates the rooms, puzzles, and the `check` command |
| `ghost_ai.sh` | Background "ghost" process teams must find and stop |
| `entrypoint.sh` | Starts the ghost process and the web terminal |
| `launch_teams.sh` | Builds the image and launches one container per team |

## Requirements

- A Linux server (Ubuntu 24.04 recommended), 2 vCPUs and 4 GB RAM for about 12 teams
- Docker
- Inbound TCP ports **7701-7799** open in your firewall or cloud security group


## Setup

1. **Install Docker**
```bash
   curl -fsSL https://get.docker.com | sh
```
2. **Clone the repo**
```bash
   git clone <your-repo-url> hollow-manor
   cd hollow-manor
```
3. **Launch the teams** (example: 12 teams)
```bash
   chmod +x launch_teams.sh
   ./launch_teams.sh 12
```
   This builds the image, starts one container per team, and prints a table of
   URLs and passwords. It is also saved to `teams.csv`.
4. **Distribute logins.** Give each team its URL, username (`team1`, `team2`,
   ...), and password.

## Running the Event

**Reset one team's house**
```bash
./launch_teams.sh reset 3
```

**Tear everything down**
```bash
docker rm -f $(docker ps -aq --filter name=house-)
```

Delete the server afterward to avoid ongoing charges.

## Security Notes

- Teams run as an unprivileged `guest` user inside an isolated container, with
  CPU, memory, and process limits.
- `ttyd` login uses HTTP basic auth over plain HTTP by default. Passwords are
  throwaway and only unlock a sandbox, but put Caddy or a Cloudflare Tunnel in
  front for HTTPS if you need it.
- `teams.csv` contains live passwords. It is git-ignored. Never commit it.
- Answer keys live in the house files, so teams who run `grep -r` could find
  them early. Remind teams to stay within their current room.

## Adding Your Own Rooms

1. Add a directory and `README.txt` for the room in `build_house.sh`.
2. Add the puzzle files and the key.
3. Add a line for the room in the `check` script's `case` block, using `h <key>`
   to store the hash instead of the plain text.
4. Rebuild with `./launch_teams.sh <N>`.

## Facilitator Guide

The answer key, hints, and event timeline are in `FACILITATOR.md`.

## License

MIT