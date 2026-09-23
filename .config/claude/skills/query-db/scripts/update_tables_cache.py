#!/usr/bin/env python3
import yaml, sys, os

tables = sys.stdin.read()
tables_path = sys.argv[1]
conn_key = sys.argv[2]

tcfg = {}
if os.path.exists(tables_path):
    with open(tables_path) as f:
        tcfg = yaml.safe_load(f) or {}

tcfg[conn_key] = tables

with open(tables_path, 'w') as f:
    yaml.dump(tcfg, f, default_flow_style=False, allow_unicode=True, sort_keys=True, indent=2)
