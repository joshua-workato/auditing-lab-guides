---
name: auditing-lab-guides
description: "Audits a Workato training lab guide (Markdown or HTML) against its live starter Workato project. Finds three things -- internal inconsistencies within the guide itself, presentation/instructional-design issues, and discrepancies between what the guide claims and what the project actually contains (wrong connector action/trigger names, field mappings that reference non-existent steps, project/connection name mismatches). Pulls the project with the wk CLI and checks connector facts against a recipe-skills checkout. Use when asked to review, QA, fact-check, audit, or find issues/discrepancies in a Workato lab guide, training guide, or workshop guide -- especially before a WOW/training session ships. Keywords: lab guide, lab testing, wk pull, wk lint, recipe-skills, lint-rules.json, discrepancy, guide review, training QA."
---

# Purpose

Audit a Workato lab guide against the live starter project it's written
against, producing a findings report a human can act on before the guide
ships to attendees.

# Scope Boundaries

This skill:
- ✅ Checks the guide's claims about Workato assets (recipes, connectors,
  connections, projects, actions/triggers, datapills) against the starter
  project and connector reference data.
- ✅ Reviews the guide holistically for internal contradictions and
  presentation/instructional-design quality.
- ✅ Flags claims it cannot verify, rather than guessing.
- ❌ Does not check or reason about non-Workato systems (Okta, mock apps,
  Playgrounds, LibreChat, manual credential/connection setup). Skip these
  entirely -- don't flag them as missing or wrong.
- ❌ Does not assume a "golden"/completed reference project exists. Only the
  starter project is available; never invent what the finished recipe
  should look like.
- ❌ Is not a recurring or scheduled check. Run it fresh each time a human
  asks -- it does not monitor for platform drift over time.

# Prerequisites

Have these ready *before* starting a run -- checking them up front avoids
stalling mid-audit on a missing dependency:
- This skill repo up to date (`git pull`) -- fixes from previous audits
  (decision-tree gaps, tool quirks) land here first.
- `wk` installed and authenticated against the target workspace/environment/
  region, with the `recipe-lint` plugin installed
  (`wk plugins install recipe-lint`).
- A local checkout of `github.com/workato-devs/recipe-skills`. Optionally
  export its path once as `RECIPE_SKILLS_DIR` so you don't have to pass it
  to `scripts/find_connector_skill.sh` on every run.
- A Google Sheets tool connected in this environment. Treat this as
  required, not optional, for team/shared audits -- see the note in Step 5.
- The **Topic** label decided (see Step 1.4).

# Core Workflow

## Step 1: Gather inputs

Confirm before proceeding:
1. The guide file (path or URL) -- Markdown or HTML. HTML guides are often
   a multi-page static site or a zip bundle (unzip it and look for an
   `index.html`/`Index` entry point, then follow its internal links to find
   every page belonging to the same guide) rather than one standalone file
   -- check for this before assuming a single file is the whole guide.
2. A `wk` project directory targeting the starter project. If none exists
   yet, run `wk init` against the workspace the guide is written for (this
   skill assumes `wk` is already installed and authenticated).
3. A local checkout of `github.com/workato-devs/recipe-skills`. If missing,
   clone it: `git clone https://github.com/workato-devs/recipe-skills.git`.
4. The **Topic** label for this run -- the lab/course code this guide
   belongs to (e.g. "WEL", "DM", "MCP 201"). This becomes the Topic column
   value for every row this run writes to the output sheet. Ask if not
   given; don't invent one. If prior runs exist for this lab/course in the
   team's Lab Feedback tracker, match their exact spelling/casing rather
   than introducing a new variant.

If any of these are missing or ambiguous, ask -- don't guess at a project
path or assume which workspace/profile is active.

## Step 2: Establish deterministic ground truth first

Run `scripts/pull_and_lint.sh <project-dir>`. This pulls the project and
runs the recipe linter, writing `pull-result.json` and `lint-result.json`
into the project directory.

Anything `wk lint` reports is automatically a **Bug -- Lab** finding. Don't
re-derive or second-guess these; they're deterministic.

## Step 3: Pass 1 -- Holistic guide review

Read the entire guide once, start to finish, before flagging anything. Load
`references/presentation-rubric.md` and check for:
- Internal contradictions (guide states a conflicting fact/name elsewhere)
- Inconsistent terminology for the same concept
- Parallel sections that should mirror each other but don't
- Presentation fit (paragraph vs. table, wall of text vs. numbered steps)
- Missing motivation/context ("why" before "how")
- Forward references to not-yet-introduced concepts

These become **Bug -- Internal consistency** or **Suggestion -- Presentation**
findings (see decision tree in Step 4 for the bug/suggestion split).

## Step 4: Pass 2 -- Extract and classify Workato-specific claims

Walk the guide step by step. For each step, first check if it's about a
non-Workato system (login flow, mock app navigation, generic UI orientation)
-- if so, skip it entirely, it's out of scope. Otherwise extract the
Workato-specific claim (a named connector + action/trigger, a named
field/datapill + the step it's claimed to come from, a named
project/connection/folder) and classify it:

**Evaluate in order, stop at first match:**

1. **Claim names a specific connector action/trigger** (e.g. "add a Jira
   'Update Issue Priority' action"). If the guide only describes generic
   behavior without naming an action ("add a Slack action and set these
   fields") there's no name to validate -- skip to branch 3 instead, since
   what matters there is whether the step exists, not what it's called.
   Run `scripts/find_connector_skill.sh <recipe-skills-checkout> <connector>`.
   - `lint-rules.json` found for that connector:
     - Name exists as claimed → no finding.
     - Name doesn't exist or is misnamed → **Bug -- Discrepancy** (cite
       `lint-rules.json` as the source of truth, not general knowledge --
       the connector's actual action list changes over time).
   - No skill found for that connector (common for bespoke/mock training
     connectors -- e.g. custom apps built just for a training track --
     `recipe-skills` only covers a handful of mainstream connectors):
     - Is that exact action already used in a pre-built step somewhere in
       the pulled project? → it's real, confirmed by the project itself, no
       finding.
     - Otherwise → **Unverifiable**, no source of truth exists for this
       connector's action list. Say so explicitly rather than silently
       passing it or guessing from the connector's apparent purpose.

2. **Claim is about a named project/connection/folder that should already
   be provisioned.**
   Check `pull-result.json` / the pulled project tree.
   - Exists with matching name → no finding.
   - Missing or name mismatch → **Bug -- Discrepancy**.

3. **Claim references a field/datapill sourced from a specific step** (e.g.
   "map the Issue Key from the trigger" / "from the search step"), or sets
   field *values* on a step the guide never gave a specific action name to
   (e.g. "add a Slack action, set channel to X, username to Y" -- routed
   here rather than branch 1, since there's no action name to validate).
   - Does that step already exist in the pulled project (i.e. it's part of
     the pre-built starter scaffold, not something the attendee builds
     later in the lab)?
     - Yes → does the step's actual output schema contain that field?
       - Yes → no finding.
       - No → **Bug -- Discrepancy** (cite the step name and its actual
         schema).
     - No (the step doesn't exist yet in the starter project) →
       **Unverifiable**. Do not guess whether the guide's instruction is
       correct -- there is no ground truth to check it against. This
       applies to every field claim about that step, not just the first
       one -- don't stop checking after finding one Unverifiable claim
       about a not-yet-built step.

4. **Claim is about wording, structure, or explanation rather than a
   verifiable fact** → this belongs to Pass 1 (Step 3), not here.

Screenshots and other images: don't attempt to verify their content against
the live Workato UI in either pass -- out of scope for v1, note it only if
an image is obviously broken/missing (a Pass 1 presentation concern), not
its accuracy.

## Step 5: Write findings to a new Google Sheet

Output goes to a **new** Google Sheet per run -- never write into the
template itself, and never write into a sheet from a previous run. Match
the org's existing Lab Feedback template shape exactly:

**Columns (in this order):** `Topic | Section Number / Part | Feedback | Section Time | Reported By | Status`

Use whichever Google Sheets tool is available in the current environment
(e.g. in this workspace, the "Google Sheets by Workato MCP" connector's
create-spreadsheet / append-rows tools). If no Google Sheets tool is
available, say so and fall back to the markdown table in
`references/output-sheet-format.md` instead of silently doing nothing.

**For team/shared audits, treat the Sheets tool as required, not optional.**
Check for it during Step 1 (Prerequisites) and flag its absence *before*
running the audit, not after -- a markdown table that has to be manually
transcribed into the shared tracker later is a worse outcome for a
regularly-run, multi-person workflow than pausing up front to get the
connector added.

Note: append/update calls on this connector require a `required_revision_id`
(the `revision_id` from the create/most recent response) for concurrency
safety -- fetch it from the prior call's result rather than guessing or
omitting it, and use the fresh `revision_id` each call returns for the
next one.

**Known tool limitation -- no cell-formatting API.** The Google Sheets by
Workato MCP tools (as of this writing) only expose row/value operations
(`append_rows`, `update_range_values`, `add_sheet`/`rename_sheet`/etc.) --
there's no operation for bold, wrap-text, frozen rows, or column width.
Don't attempt to call one; it doesn't exist, and guessing at undocumented
parameters isn't safe. Checked the connector directory for an alternative
before writing this -- none currently exposes formatting either. Work
around it instead:
- Write each **Feedback** cell with embedded line breaks (`\n`) separating
  the `[Track]` prefix, the finding, and the suggested fix onto their own
  lines, rather than one run-on sentence. Sheets renders literal line
  breaks inside a cell regardless of wrap formatting, so this reads
  cleanly without needing the missing format call.
- Tell the person the sheet is otherwise unformatted (no bold header, no
  frozen row, default column widths) and that a quick manual pass --
  select all, Format > Text wrapping > Wrap, freeze row 1, bold row 1 --
  finishes the polish in a few clicks. Don't silently skip mentioning this.
- If a more capable Sheets connector is ever connected in a given
  environment, prefer it for this step instead.

1. Create a new spreadsheet titled `Lab Feedback -- <guide name> -- <today's date>`,
   with two tabs:
   - **Lab Feedback** -- headers exactly as above.
   - **Coverage** -- headers `Metric | Value`.
2. Append one row per finding to **Lab Feedback**:
   - `Topic` -- the Topic label gathered in Step 1 (same for every row).
   - `Section Number / Part` -- the location (a guide section number like
     `1.2.3`, or free text like `Recipe: lead-sync` for Bug -- Lab findings
     that aren't tied to a guide section -- the template already mixes both
     styles).
   - `Feedback` -- `[<Track>]\n<finding>.\nSuggested fix: <fix>.` -- three
     lines within one cell (see the line-break note in Step 5's intro) --
     e.g.:
     ```
     [Bug -- Discrepancy]
     Guide maps Issue Key from the trigger, but the recipe maps it from the Jira Search step.
     Suggested fix: update the mapping to pull from the trigger.
     ```
     For **Bug -- Lab** findings, use the linter's own message rather than
     rewording it.
   - `Section Time` -- leave blank. It's for human time-to-complete data,
     not applicable to an automated pass.
   - `Reported By` -- the fixed string `auditing-lab-guides (automated)`,
     so these rows are never mistaken for a human tester's entry.
   - `Status` -- leave blank, matching the template's existing convention
     for untriaged rows.
3. Append one row per metric to **Coverage**: total Workato-specific claims
   found, how many were checked against connector reference data, how many
   against pre-built project state, and how many came back Unverifiable.
4. Report the new spreadsheet's URL back -- that's the deliverable, not a
   restated copy of the findings in chat.

If a Drive connector is also available and the person hasn't said where
the sheet should live, ask rather than leaving it wherever it defaults to
(e.g. offer to place it alongside the template rather than at the Drive
root).

Include the Coverage tab even when there are zero findings in Lab Feedback
-- a clean report on a mostly-unverifiable guide should not look identical
to a clean report on a fully-checked one.

# Key Principles

- **No golden project exists.** Only check claims against connector
  reference data (`lint-rules.json`) and whatever is actually pre-built in
  the starter project. Never assume or infer what a finished recipe should
  look like.
- **Workato-only scope.** Never flag, verify, or comment on anything about
  Okta, mock apps, Playgrounds, LibreChat, or manual external setup steps.
- **Never guess silently.** If a claim can't be checked against something
  concrete, mark it Unverifiable -- don't stay silent and don't fabricate a
  verdict either way.
- **Deterministic checks are not up for debate.** Anything `wk lint` flags
  is a Bug -- Lab finding as-is.
- **Connector facts come from `lint-rules.json`, not memory.** Connector
  action/trigger lists change over time; always check the live reference
  file for the connector in question rather than recalling it.
- **Match the existing template, don't reinvent it.** The org already has a
  Lab Feedback sheet convention (Topic / Section Number / Part / Feedback /
  Section Time / Reported By / Status) -- output into a new sheet shaped
  exactly like it rather than inventing new columns, so it merges into the
  existing human review process instead of creating a second format.
- **This is a point-in-time, human-triggered audit**, not a monitoring job.
  Re-run it fresh whenever the guide or project changes.

# Reference Files

- `references/presentation-rubric.md` -- detailed Pass 1 checklist with
  concrete examples of each presentation/consistency issue type. Read this
  before starting Step 3.
- `references/output-sheet-format.md` -- markdown-table fallback for when
  no Google Sheets tool is available. Read this only if Step 5's Sheets
  output isn't possible in the current environment.
