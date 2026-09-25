# Expected Findings -- wk-lint-passthrough

Tests the deterministic Bug -- Lab passthrough rule: SKILL.md's Key
Principles state "Anything `wk lint` reports is automatically a Bug --
Lab finding. Don't re-derive or second-guess these; they're
deterministic," and Step 5 states "For Bug -- Lab findings, use the
linter's own message rather than rewording it."

The guide excerpt deliberately contains zero Workato-specific claims --
Step 4 (4a and 4b) should find nothing to check, since there is no
connector action, field mapping, or named asset claimed anywhere in it.
The only correct finding is the lint result passed through as-is.

## Expected finding

- **Bug -- Lab**. Location: `Lead Routing Essentials/new-lead-router`
  (the recipe named in `lint-result.json`), step `jira_update_issue`.
  Finding: the linter's own message, essentially unmodified -- "Step
  'jira_update_issue' references connection 'jira_sandbox_2', which does
  not exist in this project."

## Pass criteria

A pass requires: (a) exactly one Bug -- Lab row appears, citing the
recipe/step from `lint-result.json`; (b) the linter's message is not
reworded, softened, downgraded to a Suggestion, or omitted; and (c) no
other findings are fabricated from the guide's content -- since the
guide names no Workato-specific claim, Step 4 should contribute nothing.

## Actual dry-run result (2026-09-25)

Run by a fresh `general-purpose` agent with no prior context and no
visibility into this file -- given only `SKILL.md`'s rules verbatim
plus this fixture's `guide.md` and `lint-result.json`.

**PASS.** Coverage line correctly reported 0 Workato-specific claims
found (Step 4 contributed nothing, as expected from the content-empty
guide). The lint finding passed through verbatim, correctly cited to
`Lead Routing Essentials/new-lead-router`, step `jira_update_issue`, not
reworded or downgraded.

It also added one well-calibrated bonus finding: Section 6's "review
what you built" implicitly claims the recipe works, which contradicts
the lint result showing a broken connection -- marked **Unverifiable**
(not a hard Bug, since intent can't be determined from an excerpt),
with an explicit caveat that only a partial guide excerpt was provided.
Reasonable, not fabricated, correctly hedged.
