#!/usr/bin/env bash
# Takes one or more connection names as args, and queries the table list for each one. Queries for all connections in the usql config file if no args are provided. Results are stored in `./.cache/tables.yaml`

set -uo pipefail

if [[ -z "${USQL_CONFIG:-}" ]]; then
    echo "Error: USQL_CONFIG is not set" >&2
    exit 1
fi

if [[ $# -gt 0 ]]; then
    mapfile -t conns < <(
        qq -r '.connections | keys[]' "$USQL_CONFIG" | while IFS= read -r c; do
            for arg in "$@"; do
                [[ "${c%_*}" == "$arg" ]] && echo "$c" && break
            done
        done
    )
else
    mapfile -t conns < <(qq -r '.connections | keys[]' "$USQL_CONFIG")
fi

total="${#conns[@]}"
echo "Fetching tables for ${total} connection(s)..."
echo

for conn in "${conns[@]}"; do
    db="${conn%_*}"
    port=$(qq -r ".connections[\"${conn}\"].port" "$USQL_CONFIG")
    protocol=$(qq -r ".connections[\"${conn}\"].protocol" "$USQL_CONFIG")
    tunnel_cmd=$(qq -r ".connections[\"${conn}\"].tunnel_cmd // empty" "$USQL_CONFIG")

    printf "  %-35s" "$conn"

    eval "$tunnel_cmd" 2>/dev/null
    for i in $(seq 1 10); do nc -z localhost "$port" 2>/dev/null && break; sleep 1; done

    if [[ "$protocol" == "mysql" ]]; then
        query="SELECT table_name FROM information_schema.tables WHERE table_schema = DATABASE() ORDER BY table_name"
    else
        query="SELECT table_name FROM information_schema.tables WHERE table_schema NOT IN ('pg_catalog', 'information_schema', 'realtime_parts') ORDER BY table_name"
    fi

    tables=$(usql "$conn" --csv -c "$query" 2>/dev/null | tail -n +2 | tr -d '"' | tr '\n' ',' | sed 's/,$//')

    kill -9 $(lsof -t -i :${port}) 2>/dev/null || true

    if [[ -n "$tables" ]]; then
        printf '%s' "$tables" | python3 "$(dirname "$0")/update_tables_cache.py" "${USQL_CONFIG%/*}/.cache/tables.yaml" "$db"
        echo "OK"
    else
        echo "FAILED"
    fi

    sleep 0.5

done
