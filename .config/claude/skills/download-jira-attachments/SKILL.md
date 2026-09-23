---
name: download-jira-attachments
description: Download a file attachment from a JIRA ticket to the scratchpad for analysis. Use when a JIRA ticket has an attached file (HAR, log, image, etc.) that needs to be read. Requires ATLASSIAN_API_KEY and CORPORATE_EMAIL environment variables to be set.
---

# JIRA Attachment Download

Use this skill to fetch a file attached to a JIRA ticket so it can be read and analyzed.

## Step 1 — Verify dependencies

Check that the Atlassian MCP server is connected by confirming at least one tool prefixed with `mcp__claude_ai_Atlassian__` is present in the available tools list. If none are found, stop and tell the user the Atlassian MCP server must be configured and connected before this skill can run.

Then verify the Atlassian API key and the user's corporate email address are available as environment variables.

```bash
[ -n "$ATLASSIAN_API_KEY" ] && echo "OK" || echo "ERROR: ATLASSIAN_API_KEY not set"
[ -n "$CORPORATE_EMAIL" ] && echo "OK" || echo "ERROR: CORPORATE_EMAIL not set"
```

If `$ATLASSIAN_API_KEY` is missing, stop and ask the user to set it in their shell environment by following these steps:

1. Open https://id.atlassian.com/manage-profile/security/api-tokens in a web browser.
2. Click "Create API Token", enter a name and expiration date, then click "Create".
3. Copy the new token value to the clipboard.
4. Add the line `export ATLASSIAN_API_KEY="{key}"` to a file sourced by the shell on startup, e.g. `~/.profile`.
5. Spawn a new shell, or source the profile in the current instance via `. ~/.profile`

If `$CORPORATE_EMAIL` is missing, stop and ask the user to set it in their shell environment by following these steps:

1. Add the line `export CORPORATE_EMAIL="{email}"` to a file sourced by the shell on startup, e.g. `~/.profile`.
2. Spawn a new shell, or source the profile in the current instance via `. ~/.profile`

## Step 2 — Get attachment metadata from the ticket

First, call the Atlassian MCP's `getAccessibleAtlassianResources` tool to retrieve the user's authorized cloud ID. If there are multiple results, ask the user which one is correct.

Then call `getJiraIssue` with the following parameters:

- **cloudId**: the UUID from `getAccessibleAtlassianResources` (e.g. `00000000-0000-0000-0000-000000000000`)
- **issueIdOrKey**: the ticket number (e.g. `XXXX-0000`)
- **fields**: `["attachment"]`

The response includes an `attachment` array. Each entry has the following components:
- `filename` — the original file name
- `content` — the authenticated download URL (pattern: `https://api.atlassian.com/ex/jira/{cloudId}/rest/api/3/attachment/content/{attachmentId}`)
- `mimeType` and `size`

If there are multiple attachments, list them and ask the user which to download (or download all if analysis requires it).

## Step 3 — Download to the scratchpad

Use the `content` URL from Step 2 and the user's Atlassian credentials (basic auth: email + API key):

```bash
CONTENT_URL="<content URL from attachment metadata>"
OUTPUT_PATH="<scratchpad>/filename.ext"

curl -s -L \
  -u "${CORPORATE_EMAIL}:${ATLASSIAN_API_KEY}" \
  -H "Accept: */*" \
  "$CONTENT_URL" \
  -o "$OUTPUT_PATH" \
  -w "%{http_code}"
```

- The `-L` flag is required — Atlassian redirects attachment requests before serving content.
- A `200` response means success. `401` means the API key is wrong or expired. `403` means the account lacks permission.
- Confirm the file size matches the `size` field from the metadata.

## Step 4 — Analyze

Read and analyze the downloaded file. For large files (>1MB), read targeted sections rather than the whole file:

- **Log files**: `grep` for errors, exceptions, or relevant patterns
- **Images**: use the `Read` tool to view them visually
- **HAR files**: see [REFERENCE.md](REFERENCE.md)
