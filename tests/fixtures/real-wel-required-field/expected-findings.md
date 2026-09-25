# Expected Findings -- real-wel-required-field

Grounded in a real, recurring finding from the org's actual Lab Feedback
tracker (spreadsheet `1DYWipO7MUpc3ZswZmxAONKEjQyHeF7Nx4-cu48X5V-E`,
"Lab feedback template"), rows 3, 13, 15, 18, 20, 22, 26, 28, 31 -- all
the same root cause, reported repeatedly by tester "Ben" against the
real WEL lab.

Real tester report (row 3, verbatim): "I get this error when following
the expression under 1.2.3 #input validation failed: Email value must
be present (path: code_input.data.leads.11.email)."

This fixture reconstructs the minimal shape of that bug (fewer sample
records, same mechanism) rather than reproducing it byte-for-byte:
the pre-built "Validate Lead" step's input schema marks `email` as a
required field, and the guide's own stated sample dataset for that step
(1.2.2) has one record (Barbara Lin) with a blank email. Per SKILL.md
branch 4b.1 ("Required field vs. sample data"), this is a **Bug --
Discrepancy** regardless of whether the guide's prose says anything
explicitly wrong -- the contradiction is between the step's own schema
and the guide's own sample data.

## Expected finding (semantic match required, not exact wording)

- **Bug -- Discrepancy** (branch 4b.1). Section 1.2.2/1.2.3: the
  "Validate Lead" step's input schema marks `email` as required, but
  the guide's own sample lead data includes a record (Barbara Lin) with
  a blank email. Running the step against this data will fail input
  validation on that record, contradicting 1.2.3's claim that the
  learner "should see the step complete with no errors." Suggested fix:
  give the record a placeholder email, mark the field optional, or
  explain that the blank email is intentional and handled later.

A pass requires the finding to identify: (a) the required `email` field,
(b) the blank-email record in the guide's own sample data, and (c) that
this is a Bug/Discrepancy, not Unverifiable or no-finding. Exact wording,
step numbering, or reasoning phrased differently are all fine.

## Actual dry-run result (2026-09-25)

Run by a fresh `general-purpose` agent with no prior context and no
visibility into this file -- given only `SKILL.md`'s Step 3/4 rules
verbatim plus this fixture's `guide.md` and pulled-project data.

**PASS.** It independently found: "The sample leads array's third record
('Barbara Lin') has `email: ''`, but the Validate Lead recipe's
`code_step` input schema marks `email` as `required: true`. This blank
value on a required field will fail validation the moment the step runs
against the full array" -- classified correctly as **Bug -- Discrepancy**.

It also went beyond the minimum bar: it separately flagged an **Internal
Consistency** bug (1.2.3's "no errors" claim directly contradicts the
failure from finding #1), one legitimate **Unverifiable** call (the
step's actual code logic isn't visible in the pulled schema, only its
declared input fields), and two in-scope **Presentation** suggestions
(undefined term "routing schema"; inconsistent scope wording between
1.2.2 and 1.2.3). Nothing fabricated or out of scope.
