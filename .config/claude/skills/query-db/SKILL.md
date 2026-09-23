---
name: query-db
description: Query live SQL databases. Use when performing a task that requires inspection of real data — checking a specific record, verifying a count, tracing a data pipeline issue, etc.
---

# Database Query

Use this skill to query live data from a SQL database.

## Step 1 — Verify dependencies

This skill requires the `usql` database client to query multiple SQL database types, and the `qq` structured data query tool (like `jq` for multiple formats) to read the the `usql` config file. 

```bash
command -v qq   || echo "ERROR: qq is not installed"
command -v usql || echo "ERROR: usql is not installed"
```

If either dependency is missing, stop and advise the user to install from Github:

* `qq` - https://github.com/JFryy/qq
* `usql` - https://github.com/xo/usql

This skill also requires the `$USQL_CONFIG` environment variable to be set.

```bash
[ -n "$USQL_CONFIG" ] && echo "OK" || echo "ERROR: USQL_CONFIG not set"
```

If `$USQL_CONFIG` is missing, stop and ask the user to set it in their shell environment by following these steps:

1. Add the line `export USQL_CONFIG="~/.config/usql/config.yaml"` (substitute actual path if different) to a file sourced by the shell on startup, e.g. `~/.profile`.
2. Spawn a new shell, or source the profile in the current instance via `. ~/.profile`

## Step 2 — Discover available connections

The path of the `usql` configuration file is stored in the `$USQL_CONFIG` environment variable. Use `qq` to list all available connections:

```bash
qq -r '.connections | keys[]' $USQL_CONFIG
```

Connection names should follow the pattern `<database>_<environment>`.

## Step 3 — Discover available tables

Table lists are stored in `.cache/tables.yaml` in the same directory as the configuration file. The lists are keyed by database name, which is the connection name without the environment suffix (e.g. `platform_us` → `platform`). This paradigm assumes that databases have the same table structure across environments.

```bash
db="${CONN%_*}"
tables_yaml="${USQL_CONFIG%/*}/.cache/tables.yaml"
qq -r ".${db} // empty" "$tables_yaml"
```

If the output is empty, the table list has not been populated yet — run `get_tables.sh` from the skill's base directory to populate it, then re-run the lookup above:

```bash
bash scripts/get_tables.sh "$db"
```

## Step 4 — Run the query

Set `CONN` to the connection name (representing the database and environment against which to run a query), and set `SQL` to the query itself, then run the following script:

```bash
CONN=platform_us
SQL="SELECT id, email, created_at FROM users WHERE id = 12345"

tunnel_cmd=$(qq -r ".connections[\"${CONN}\"].tunnel_cmd // empty" "$USQL_CONFIG")
if [[ -n "$tunnel_cmd" ]]; then
    bash scripts/query_through_tunnel.sh "$CONN" "$SQL"
else
    usql "$CONN" --csv -c "$SQL"
fi
```

For exporting large columns or parsing JSONB output, see [REFERENCE.md](REFERENCE.md).

## Rules

- **SELECT only.** Never run INSERT, UPDATE, DELETE, or any DDL.
- **Always include LIMIT.** Use `LIMIT 100` or less unless an aggregate (COUNT, SUM, etc.) is the goal.
- **Always include a WHERE clause.** Do not scan full tables.
- **Prefer the feature or staging environment** when the question can be answered there rather than in production.
