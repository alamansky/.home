# duckdb

An in-process SQL OLAP database management system CLI.

## Installation

1. Run playbook.

```sh
ansible-playbook install.yml
```

## Reference

Example uses:

1. Inline query:

```sh
duckdb -c "SELECT \"First Name\" FROM 'people.csv' WHERE \"Last Name\" = \"Doe\";"
```

2. Multi-line heredoc query:

```sh
duckdb <<'EOF'
  SELECT "First Name"
  FROM read_csv_auto('people.csv')
  WHERE "Last Name" = "Doe";
EOF
```

3. Query in file:

```sh
sed -n '1,5p' query.sql | duckdb
```

## Modifications

* Creates /opt/managed/duckdb

## Further Reading

- [DuckDB](https://duckdb.org)
- [GitHub](https://github.com/duckdb/duckdb)
