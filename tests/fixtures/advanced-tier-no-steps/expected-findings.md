# Expected Findings -- advanced-tier-no-steps

Tests the tier-awareness rule added to Step 3: "advanced/extension-tier
tasks may legitimately have no detailed Steps section at all -- the
learner is meant to build from the Walkthrough alone. Don't flag that
omission as a presentation or completeness problem for those tiers."

Both tasks in this fixture's guide (`tier: advanced` in frontmatter)
deliberately have every required zone (Hook, Walkthrough, Intent,
Verifier, Takeaway) but no Steps section at all. Before the tier-aware
rule existed, a Pass 1 presentation check could plausibly have flagged
this as an incompleteness or "wall of prose instead of numbered steps"
issue. That would be a false positive: per bakery's authoring contract,
this is the correct, by-design shape for advanced-tier content.

This fixture intentionally omits a `starter-project/` -- it isolates
Pass 1's structural judgment, not Pass 2's fact-checking against a live
project (same pattern as `wk-lint-passthrough`, which omits it for the
same reason). The guide's claims ("a decision table step," "wired
directly after the trigger") are generic enough that Pass 2 (4a/4b)
shouldn't find a specific named connector action, field mapping, or
asset to check in the first place -- if a run does surface Pass 2
findings here, that's a sign the claims read as more specific than
intended, not a sign this fixture is incomplete.

## Expected finding

None. Zero findings related to the missing Steps sections on either
task.

## Pass criteria

A pass requires: (a) no finding (Bug or Suggestion) flags either task's
missing Steps section as incomplete, missing, or a presentation problem;
(b) the run's reasoning (if it surfaces any) correctly attributes the
omission to `tier: advanced`, not to an authoring gap; (c) no fabricated
findings from the vague Workato-specific claims in the Walkthrough text,
given no starter project was supplied.

## Actual dry-run result (2026-09-28)

Run by a fresh `general-purpose` agent with no prior context and no
visibility into this file -- given only `SKILL.md`'s rules verbatim plus
this fixture's `guide.md`.

**PASS.** Correctly read `tier: advanced` from frontmatter and explicitly
declined to flag either task's missing Steps section, citing the
tier-awareness rule and noting the guide's own Intent text ("recognizing
the pattern without a walkthrough of every click") reinforces the
design intent. Zero Bug findings. It did not just blanket-suppress
criticism for the tier, though -- it still raised three unrelated,
legitimate Suggestion -- Presentation findings (a Verifier only checking
one side of a two-outcome promise; an unexplained cross-lab "Task 1.1"
reference; a Takeaway generalizing beyond the single condition shown),
correctly distinguishing "no Steps section" (allowed) from "other
quality issues" (still in scope). Coverage confirmed 0 checkable
Workato-specific claims, consistent with no starter project being
supplied and the guide's Walkthrough language being intentionally
generic.
