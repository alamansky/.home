#!/usr/bin/env bash
set -uo pipefail

CONN="${1:?Usage: query_through_tunnel.sh <conn> <sql>}"
SQL="${2:?Usage: query_through_tunnel.sh <conn> <sql>}"

port=$(qq -r ".connections[\"${CONN}\"].port" "$USQL_CONFIG")
tunnel_cmd=$(qq -r ".connections[\"${CONN}\"].tunnel_cmd // empty" "$USQL_CONFIG")
eval "$tunnel_cmd" 2>/dev/null

for i in $(seq 1 10); do nc -z localhost "$port" 2>/dev/null && break; sleep 1; done

usql "$CONN" --csv -c "$SQL"
kill -9 $(lsof -t -i :${port}) 2>/dev/null || true
