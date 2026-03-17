# Linear MCP via mcpc

Query and manage Linear issues, projects, and workflow states using the `mcpc` CLI
connected to a Linear MCP session. Use when asked about Linear issues, projects,
roadmap, backlog, or task management.

## Session

The Linear MCP server is available as a persistent mcpc session. Check `mcpc` (no args) to find the active Linear session name, then use it:

```
mcpc @<session> <command> [args]
```

Add `-j` for JSON output (useful for piping to `python3` for parsing).

## Available Tools

### Read Operations

**my_issues** — Issues assigned to the authenticated user.
```bash
mcpc @<session> tools-call my_issues
```

**issue** — Full details for a single issue (comments, labels, assignee, team).
```bash
mcpc @<session> tools-call issue 'identifier:=ENG-123'
```

**search** — Text search across issue titles and descriptions.
```bash
mcpc @<session> tools-call search 'query:=search terms'
```

**list_projects** — All projects, optionally filtered by team.
```bash
mcpc @<session> tools-call list_projects
mcpc @<session> tools-call list_projects 'team_id:=<uuid>'
```

**list_project_updates** — Status updates for a project.
```bash
mcpc @<session> tools-call list_project_updates 'project_id:=<uuid>'
mcpc @<session> tools-call list_project_updates 'project_id:=<uuid>' 'limit:=5'
```

**states** — Workflow states for a team (or all teams). Use to get `state_id` values.
```bash
mcpc @<session> tools-call states
mcpc @<session> tools-call states 'team_id:=<uuid>'
```

### Write Operations

**create_issue** — Create a new issue. Priority: 0=none, 1=urgent, 2=high, 3=medium, 4=low.
```bash
mcpc @<session> tools-call create_issue 'team_id:=<uuid>' 'title:=Fix login bug' 'description:=Details here' 'priority:=2'
```
Optional: `description`, `priority`, `state_id`, `assignee_id`, `project_id`.

**update_issue** — Update an existing issue (by internal UUID, not identifier).
```bash
mcpc @<session> tools-call update_issue 'issue_id:=<uuid>' 'title:=New title' 'priority:=3'
```
Optional: `title`, `description`, `priority`, `state_id`, `assignee_id`.

**update_status** — Change workflow state of an issue.
```bash
mcpc @<session> tools-call update_status 'issue_id:=<uuid>' 'state_id:=<uuid>'
```

**create_project** — Create a new project. State: planned, started, paused, completed, canceled.
```bash
mcpc @<session> tools-call create_project 'name:=My Project' 'team_id:=<uuid>' 'state:=planned'
```

**create_project_update** — Post a status update. Health: onTrack, atRisk, offTrack.
```bash
mcpc @<session> tools-call create_project_update 'project_id:=<uuid>' 'body:=Update text' 'health:=onTrack'
```

## Response Schemas

### Issue (from search, my_issues)
```json
{
  "id": "uuid",
  "identifier": "ENG-123",
  "title": "string",
  "description": "string|null",
  "state": { "name": "Backlog" },
  "priority": 2,
  "project": { "name": "string" } | null
}
```

### Issue (from issue — full details)
Includes all above plus: comments, labels, assignee, team.

### Project (from list_projects)
```json
{
  "id": "uuid",
  "name": "string",
  "slugId": "string",
  "state": "backlog|planned|started|paused|completed|canceled",
  "teams": { "nodes": [{ "id": "uuid", "name": "string" }] }
}
```

### Project Update (from list_project_updates)
```json
{
  "body": "string",
  "health": "onTrack|atRisk|offTrack",
  "createdAt": "datetime",
  "user": { "name": "string" }
}
```

## Argument Syntax

mcpc uses `:=` for typed values and `=` for strings:
- String: `'query:=some text'` or `'title:=Fix bug'`
- Integer: `'priority:=2'`
- Null: omit the parameter

For complex JSON args, pipe stdin:
```bash
echo '{"team_id":"uuid","title":"Issue"}' | mcpc @<session> tools-call create_issue
```

## Tips

- Use `-j` flag for JSON output when parsing programmatically.
- `issue_id` in write operations is the internal UUID (from `id` field), not the human identifier like `ENG-123`.
- Fetch the `id` from a search or `issue` call first, then use it in updates.
- Project states (backlog, planned, started, etc.) differ from issue workflow states (which are team-specific UUIDs from the `states` tool).
- Run `mcpc` with no args to list active sessions and find the Linear session name.
