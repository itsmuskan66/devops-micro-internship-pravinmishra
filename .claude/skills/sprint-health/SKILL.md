---
name: sprint-health
description: Reads the current active sprint via Jira MCP and produces a read-only triage report — velocity so far, at-risk stories, and items missing estimates. Never creates, edits, comments on, or transitions a Jira issue.
allowed-tools: mcp__jira__jira_search, mcp__jira__jira_get_issue, mcp__jira__jira_get_agile_boards, mcp__jira__jira_get_sprints_from_board, mcp__jira__jira_get_sprint_issues, Read
disable-model-invocation: true
---

# Sprint Health Skill

When `/sprint-health` is invoked:

0. Always fetch fresh data with the Jira MCP tools on every invocation; never reuse results from earlier in the conversation.
1. Use the Jira MCP read tools to find the current active sprint on the project's Scrum board (`jira_get_agile_boards` → `jira_get_sprints_from_board` with state `active`).
2. Retrieve every issue in that sprint (`jira_get_sprint_issues`, or `jira_search` with `sprint in openSprints()`): status, assignee, story points, description, and last-updated timestamp.
3. Calculate:
   - Sprint velocity so far: story points in "Done" versus total points committed
   - Days remaining in the sprint (from the sprint end date and today's date)
   - Stories at risk: still "To Do" or "In Progress" with few days remaining, or with no update in several days
   - Items with no story point estimate, or with no acceptance criteria in the description
4. Report in this order:
   - Sprint name and days remaining
   - Velocity so far (points done / points committed)
   - At-risk stories, with the exact evidence (status, last update, points) for each
   - Items missing an estimate or acceptance criteria
   - One suggested talking point for standup — phrased as a question for the human Scrum Master to raise, not an instruction to act
5. Use only data returned by the Jira MCP tools. If a value is missing, say it is missing; never guess.
6. Do not call any Jira MCP tool that creates, edits, comments on, or transitions an issue.
7. Do not use `Write`.
8. Never take an action on the board. Only report. The Scrum Master decides and acts manually.
