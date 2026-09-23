# Expected Findings -- sample-lab-1

Planted issues, one per decision-tree branch. Written before running the
skill against the fixture, so the audit below is checked against this,
not the other way around.

1. **Bug -- Discrepancy (branch 1, invalid action name).** Exercise A
   step 3 claims a Jira action called "Update Issue Priority." The mock
   `lint-rules.json` for jira has no such action (closest real ones:
   `update_issue`, `create_issue`).
2. **Bug -- Discrepancy (branch 2, project name mismatch).** Prerequisites
   claim the project is called "Lead Routing Essentials". The pulled
   project is actually named "Lead Routing Starter".
3. **Bug -- Discrepancy (branch 2, connection folder name mismatch).**
   Prerequisites claim the connections folder is `[Lead Routing]
   Connections`. It's actually `[Lead Router] Connections`.
4. **Bug -- Discrepancy (branch 3, field sourced from wrong step).**
   Exercise A step 4 claims Issue Key "is available on the trigger."
   The trigger (Gmail) only outputs `email_subject`, `email_from`,
   `email_body`, `received_at`. `issue_key` is actually on the pre-built
   Jira `search_issues` step. (This mirrors the real trigger-vs-search-step
   bug reported in `#ask-academy`.)
5. **Unverifiable.** Exercise B step 2 claims the Slack message body comes
   from "the Slack thread's parent message text," but the Slack step
   doesn't exist yet in the pulled project -- the attendee adds it in
   Exercise B step 1. No ground truth to check this claim against.
6. **No finding (correctly out of scope).** The Okta login line in
   Prerequisites should be skipped entirely, not flagged as missing or
   wrong.
7. **Bug -- Internal consistency.** "the Connections tab" (Exercise A
   step 2) vs. "the Connection Manager" (Notes on connector setup) --
   same UI element, two names.
8. **Bug -- Internal consistency (parallel-section drift).** Exercise A
   has a "Verify your work" step; Exercise B, which mirrors its structure,
   has no equivalent.
9. **Suggestion -- Presentation.** Exercise B step 3 lists four
   field/value pairs in prose; reads faster as a table.

## Actual dry-run results (2026-09-23)

Live sheet: https://docs.google.com/spreadsheets/d/1pEybZ0Gm_u4uo7r_9jbYeREpurGuWLqddgc7VLJyZbA/edit

8 of 9 planted issues caught (all except the confirmed non-findings, which
correctly produced no finding). One issue -- unnamed Slack action field
claims -- was found by the audit but missing from this answer key; fixed
in SKILL.md (decision tree branch 1/3 gap) and in this doc. Also confirmed:
`append_rows`/`update_range_values` on the Google Sheets by Workato MCP
connector require `required_revision_id`; documented in SKILL.md Step 5.
