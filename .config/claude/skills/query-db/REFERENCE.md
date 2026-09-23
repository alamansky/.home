# Query Database — Reference

## Exporting large columns

`usql` does not support `COPY ... TO STDOUT`. To export a large value to a file, cast to text and redirect:

```bash
usql "$CONN" --csv -c "SELECT col::text FROM table WHERE id = 123" > /path/to/output.txt
```

## Parsing JSONB output

`usql --csv` wraps JSONB values in outer quotes and escapes inner quotes as `""`. Strip that before parsing:

```python
with open("output.txt") as f:
    lines = f.read().strip().split("\n", 1)
raw = lines[1].strip()
if raw.startswith('"') and raw.endswith('"'):
    raw = raw[1:-1].replace('""', '"')
data = json.loads(raw)
```
