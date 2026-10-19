#!/usr/bin/env bash
# Usage: scripts/run.sh examples/<topic>/
# Creates .venv, installs the topic's requirements, loads .env, and launches Jupyter Lab in that folder.
set -euo pipefail

topic="${1:?usage: scripts/run.sh examples/<topic>/}"
root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

[ -d .venv ] || python3 -m venv .venv
# shellcheck disable=SC1091
source .venv/bin/activate

pip install --quiet --upgrade pip jupyterlab
if [ -f "$topic/requirements.txt" ]; then
    pip install --quiet -r "$topic/requirements.txt"
else
    echo "no $topic/requirements.txt; notebooks install their own deps via %pip"
fi

if [ -f .env ]; then
    set -a; source .env; set +a
fi
: "${OPENAI_API_KEY:?OPENAI_API_KEY not set (put it in $root/.env)}"

jupyter lab --notebook-dir="$topic"
