# auditing-lab-guides

A [Claude Skill](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview) that audits a Workato training lab guide against the live starter project it's written against — catching discrepancies between what a guide *claims* and what the recipe actually contains before the guide ships to attendees.

This repo is the skill's source. The workflow Claude actually follows lives in [`SKILL.md`](./SKILL.md); this README is for humans browsing the repo — orientation, setup, and structure.

## What it catches

Run against a lab guide (Markdown or HTML) plus the Workato project it's built on, the skill produces a findings report covering:

- **Discrepancies** — a connector action/trigger the guide names that doesn't exist, a field mapped from a step that doesn't have it, a project/connection/folder name that doesn't match what's actually provisioned.
- **Lab bugs** — anything the deterministic `wk lint` recipe linter flags.
- **Internal inconsistencies** — the guide contradicting itself, or two parallel sections (e.g. "Exercise A" vs. "Exercise B") drifting out of sync.
- **Presentation issues** — walls of prose that should be numbered steps or tables, missing motivation/context, inconsistent terminology.
- **Unverifiable claims** — flagged explicitly rather than guessed at, when there's no ground truth to check against (e.g. a claim about a step the attendee hasn't built yet).

It deliberately does **not** assume a "finished" reference recipe exists, and does not reason about non-Workato systems (Okta, mock apps, manual credential setup). See `SKILL.md`'s Scope Boundaries for the full list.

## Repository structure

```
.
├── SKILL.md                          # The skill itself — read by Claude, not humans, when triggered
├── references/
│   ├── presentation-rubric.md        # Pass 1 checklist: consistency & instructional-design issues
│   └── output-sheet-format.md        # Markdown fallback format when no Sheets tool is available
├── scripts/
│   ├── pull_and_lint.sh              # wk pull + wk lint, writes structured JSON ground truth
│   ├── find_connector_skill.sh       # Locates a connector's lint-rules.json in a recipe-skills checkout
│   └── resolve_folder_id.sh          # Resolves a bare Workato folder id to a project/path
└── tests/
    └── fixtures/                     # Eval fixtures -- each a guide + mock pulled-project data + expected-findings.md
        ├── sample-lab-1/              # Broad golden case: 9 planted issues across most branches
        ├── real-wel-required-field/   # Required-field-vs-sample-data, grounded in a real tracker report
        ├── mock-scaffolding-vs-authored/  # Scaffolding vs. learner-authored, tested both directions
        ├── wk-lint-passthrough/       # Deterministic Bug -- Lab passthrough
        └── html-multipage-guide/      # Step 1's multi-page HTML discovery
```

## Prerequisites

Before running an audit, make sure the following are in place:

| Requirement | Why |
|---|---|
| [`wk`](#) CLI installed and authenticated to the target workspace/environment/region | Pulls the starter project and runs the deterministic recipe linter |
| `recipe-lint` plugin (`wk plugins install recipe-lint`) | Required for `wk lint` to produce findings |
| A local checkout of [`workato-devs/recipe-skills`](https://github.com/workato-devs/recipe-skills) | Source of truth for each connector's real action/trigger names (`lint-rules.json`) |
| A Google Sheets MCP connector in the Claude environment | **Required, not optional**, for team/shared audits — output goes to a new Sheet per run |
| A Drive MCP connector (recommended) | Lets output land pre-formatted, via template duplication, instead of a blank sheet |
| Read access to the org's shared **"Lab Feedback Template (blank)"** Google Sheet | The template every run's output sheet is copied from |

Optionally export `RECIPE_SKILLS_DIR` once, pointing at your `recipe-skills` checkout, so you don't have to pass the path to `scripts/find_connector_skill.sh` on every call:

```bash
git clone https://github.com/workato-devs/recipe-skills.git
export RECIPE_SKILLS_DIR="$(pwd)/recipe-skills"
```

> **Note:** the Sheets/Drive connector requirement and the shared template are specific to this org's Workato Google Workspace. Outside that environment, Step 5 of `SKILL.md` falls back to a markdown table (`references/output-sheet-format.md`) instead of failing silently.

## Setup

```bash
git clone https://github.com/joshua-workato/auditing-lab-guides.git
```

Then make this repo available to Claude as a skill (e.g. drop it in your Claude Code skills directory, or upload it as a skill package on claude.ai). Claude reads `SKILL.md`'s frontmatter to decide when to trigger it, and loads the full body only once triggered — you don't need to do anything with this README for the skill itself to work.

## Usage

Once the skill is available, just ask Claude to review, QA, fact-check, or audit a lab guide — e.g.:

> "Audit the WEL-201 lab guide against the Lead Routing Essentials starter project."

Claude will walk you through gathering the guide, the `wk` project, and the Topic label before running the audit, per `SKILL.md`'s Core Workflow. The deliverable is a new Google Sheet URL (or a markdown table, if no Sheets tool is available) — not a restated copy of the findings in chat.

## Testing

`tests/fixtures/` holds eval fixtures: each is a deliberately flawed lab guide plus mock pulled-project/`recipe-skills` data, together with an `expected-findings.md` written *before* the skill is run against it — results are checked against that file, not the reverse. Each `expected-findings.md` also records its actual dry-run result (and, where applicable, what real tester report it's grounded in).

- `sample-lab-1` — a broad golden case, 9 planted issues across most branches.
- `real-wel-required-field` — required-field-vs-sample-data, grounded in a real, repeated finding from the org's Lab Feedback tracker.
- `mock-scaffolding-vs-authored` — forces the scaffolding-vs-learner-authored heuristic both directions in one guide.
- `wk-lint-passthrough` — the deterministic Bug -- Lab passthrough rule.
- `html-multipage-guide` — Step 1's "is this actually a multi-page site" discovery check.

To validate a change to `SKILL.md`'s decision logic, run the skill against every fixture and diff the output against each `expected-findings.md` before running against a real guide — a fix for one branch can regress another, so check all of them, not just the one you changed.

## Contributing

This skill evolves from real dry runs, not speculation — see the commit history for the pattern: each change is tied to a specific gap found either by running the skill for real or by code review. When you find a new decision-tree gap:

1. Add the case to a test fixture (or `tests/fixtures/sample-lab-1` if it fits) with an expected finding.
2. Fix the gap in `SKILL.md`.
3. Note the fix and its source in the commit message.

`git pull` this repo before starting a new audit — fixes from previous runs land here first.
