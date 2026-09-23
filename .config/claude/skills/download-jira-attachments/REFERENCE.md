# JIRA Attachment Download — Reference

## HAR files

Verify the download is valid JSON before analyzing:

```bash
python3 -c "import json; json.load(open('$OUTPUT_PATH'))" && echo "Valid JSON" || echo "ERROR: file is not valid JSON — download may be truncated or an error page"
```

Use `python3` to extract and report on the following categories:

- **HTTP errors** — responses with status 4xx, 5xx, or 0 (network failure)
- **Redirects** — 3xx responses, especially chains (the same resource redirecting multiple times)
- **CORS/preflight failures** — OPTIONS requests that returned a non-2xx status, or responses missing `Access-Control-Allow-Origin`
- **Slow requests** — entries where `time` exceeds 3000ms

For each finding, report: method, URL, status code, and response time.
