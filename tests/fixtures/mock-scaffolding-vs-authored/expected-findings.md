# Expected Findings -- mock-scaffolding-vs-authored

Synthetic fixture, but the core scenario traces back to a real report:
row 52 of the org's Lab Feedback tracker ("Lab feedback template",
`1DYWipO7MUpc3ZswZmxAONKEjQyHeF7Nx4-cu48X5V-E`) -- "DM | 5.2.1 | Didn't
find the APAC entry already added to the table. | Salim" -- which is
also the real-world source of `SKILL.md`'s own "Park APAC" illustrative
example under the scaffolding note (4a branches 2/3).

This fixture engineers both sides of that heuristic deliberately, in one
guide, so a fresh run has to apply it twice and get it right both times:

## Expected finding 1 (structural scaffolding -> Bug, not Unverifiable)

- **Bug -- Discrepancy.** Section 5.2.1 tells the learner to *add* a new
  decision-table row named "Park APAC" with condition `region = APAC`.
  The pulled project already has a row labeled "Park APAC" -- but with
  no conditions set (`conditions: {}`). Per the scaffolding note: an
  empty, labeled placeholder is what incomplete provisioning looks like,
  not something a learner spontaneously creates, and not something a
  learner already did either -- so this should be flagged as a
  discrepancy (the guide's instruction to "add" a row that already
  exists, empty, is itself the bug worth surfacing), not silently passed
  and not marked Unverifiable.

## Expected finding 2 (learner-authored content -> Unverifiable, not Bug)

- **Unverifiable.** Section 5.3.1 frames the "Assign Priority" formula
  as something the learner writes. The pulled project's formula step
  already contains a complete, working formula matching exactly what
  the guide asks for. This is *not* framed as "given" anywhere in the
  guide. Per the exercise-completeness check (4b.3) and the
  learner-authored note, this is ambiguous -- it could be intentional
  starter scaffolding the guide-writer forgot to mark as "given," or a
  previous learner's completed work sitting in a non-pristine pulled
  folder. The correct call is **Unverifiable**, stated plainly as
  ambiguous either way -- not a silent pass, and not a flat Bug.

## Pass criteria

A pass requires both findings to appear with the correct **classification**
(finding 1 = Bug/Discrepancy, finding 2 = Unverifiable) and both correctly
identify *which* artifact is scaffolding (row 5.2, empty conditions) vs.
which is learner-authored-or-ambiguous (formula step 5.3, complete and
working). Getting either classification backwards (e.g. calling the
empty decision-table row "Unverifiable," or calling the complete formula
a flat "Bug") is a fail on that finding, even if something is flagged.
Exact wording, phrasing, or step numbering used in the finding text does
not need to match this file.

## Actual dry-run result (2026-09-25)

Run by a fresh `general-purpose` agent with no prior context and no
visibility into this file -- given only `SKILL.md`'s Step 3/4 rules
verbatim plus this fixture's `guide.md` and pulled-project data.

**PASS on both findings.**

- Finding 1 (scaffolding): "the row already contains... an empty,
  labeled placeholder... Per the skill's own scaffolding rule... this is
  a real discrepancy rather than ambiguous learner work" -- classified
  as **Bug -- Discrepancy**, correct.
- Finding 2 (learner-authored): "the pulled project's formula step
  already contains a complete, working formula... This is either
  leftover scaffolding... or the requester's own prior work-through...
  genuinely ambiguous either way" -- classified as **Unverifiable**,
  correct.

It also correctly declined to guess on two narrative claims (5.2.2,
5.3.2) that presuppose sample lead records this fixture never supplied,
marking them Unverifiable rather than fabricating a verdict, and raised
one legitimate Presentation suggestion (5.3 skips the "why" that 5.2
gives). Nothing fabricated or out of scope.
