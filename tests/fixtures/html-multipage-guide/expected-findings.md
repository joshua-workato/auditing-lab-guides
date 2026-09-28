# Expected Findings -- html-multipage-guide

Tests Step 1's discovery instruction: "HTML guides are often a multi-page
static site... rather than one standalone file -- check for this before
assuming a single file is the whole guide." This is a mechanical/
procedural check, not a decision-tree branch: the question is whether the
audit notices `index.html` links to `page2.html` and reads that page too,
before concluding the audit is complete.

`guide-site/index.html` deliberately contains **zero** planted bugs --
every claim on it (recipe named "New Lead Router", a Gmail trigger, a
pre-built Jira "Search Issues" step) matches the pulled project exactly.
Both planted bugs live only on `guide-site/page2.html`, reachable solely
via the "Continue to Exercise B" link on `index.html`.

## Expected findings (both require having actually read page2.html)

1. **Bug -- Discrepancy** (branch 4a.1). Page 2 claims a Jira action
   called "Escalate Issue." No such action exists in the mock
   `lint-rules.json` for jira (closest real ones: `create_issue`,
   `update_issue`, `add_comment`).
2. **Bug -- Discrepancy** (branch 4a.3). Page 2 claims the Priority field is
   mapped "from the Gmail trigger's `priority` output." The pulled
   recipe's Gmail trigger only outputs `email_subject`, `email_from`,
   `email_body`, `received_at` -- there is no `priority` field on the
   trigger at all.

## Pass criteria

**The critical pass/fail signal is discovery, not classification.** If
the audit reports zero findings (or only comments on `index.html`'s
content), that is a **fail** -- it means the audit treated `index.html`
as the entire guide and never followed the link to `page2.html`, which
is exactly the failure mode Step 1 exists to prevent. A pass requires
both planted bugs to be surfaced, correctly classified as Bug --
Discrepancy (not Unverifiable or no-finding), regardless of exact wording.

## Actual dry-run result (2026-09-25)

Run by a fresh `general-purpose` agent with no prior context and no
visibility into this file -- given only `SKILL.md`'s Step 1/3/4 rules
verbatim, a real path to `guide-site/index.html` on disk (not pasted
content), and the pulled-project/lint-rules data. It had to discover
`page2.html` itself via the link, using its own file-reading tools.

**PASS.** Coverage line opened with: "The guide is a 2-page HTML site
(index.html = 'Exercise A', linked forward to page2.html = 'Exercise
B')... Both pages were read as the complete guide" -- confirming
discovery worked unaided. Both planted bugs were found and correctly
classified as Bug -- Discrepancy: the nonexistent "Escalate Issue"
action (cited against `lint-rules.json`), and the Priority field
claimed from the Gmail trigger's nonexistent `priority` output (cited
against the trigger's actual schema). It also connected Exercise A's
"review the trigger's output fields" instruction to Exercise B's broken
claim as a presentation issue -- accurate, not fabricated.

## Regression re-run (2026-09-28, after Sheet-id redaction + tier-awareness)

Re-ran blind after the same `SKILL.md` edits noted in `sample-lab-1`'s
regression entry (none touch Step 1's multi-page discovery instruction).
**PASS.** Discovered `page2.html` via the "Continue to Exercise B" link
unaided, confirmed via directory listing that only two pages exist.
Both planted bugs found and correctly classified Bug -- Discrepancy:
the nonexistent "Escalate Issue" Jira action (cited against
`lint-rules.json`), and the Priority field falsely sourced from the
Gmail trigger's nonexistent `priority` output (cited against the
trigger's actual schema). Also caught legitimate bonus findings:
a title-tag mismatch between the two pages (Internal Consistency), and
two Presentation suggestions (missing "why," prose-vs-table).
