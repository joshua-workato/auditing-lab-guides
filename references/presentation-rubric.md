# Presentation & Internal-Consistency Rubric (Pass 1)

Read the whole guide top to bottom before flagging anything here — these are
holistic checks, not per-line ones. If the organization has an official doc
template/style guide, treat it as authoritative over this rubric and note any
conflict rather than silently picking one.

## Parallel-section drift

When two sections are structurally meant to mirror each other (e.g. "first
run" vs. "second run" of the same exercise, or step N in Track A vs. step N in
Track B), check they actually match. A UI element, button, or option present
in one but silently missing from its parallel counterpart is a bug, not a
stylistic quirk — testers have flagged exactly this pattern before ("it would
be great if we made it consistent, either just provide the button in both
places or provide both").

## Redundant / repeated structure

Flag repeated elements that add confusion rather than reinforcement — e.g. an
identical tab or question appearing multiple times where once would do.

## Table vs. paragraph

If a paragraph is really a list of (field, value, description) triples, or
any set of ≥3 parallel items each with 2+ attributes, it reads faster as a
table. Recommend the conversion; don't just say "hard to read."

## Numbered steps vs. prose

Anything the learner must *perform*, in order, belongs in a numbered list.
Reserve prose paragraphs for context, motivation, and explanation. A wall of
text describing a sequence of actions is a signal to convert to steps.

## Missing "why"

Each major section should give the learner a reason before the mechanics —
what problem this solves or why it matters, not just what to click. Guides
that skip straight to clicks without this context have been flagged in past
testing rounds ("feedback on context setting info in doc, e.g. hook, why").

## Terminology consistency

Pick one name per UI element/concept and use it everywhere. Watch for the
same thing called by two names across sections (e.g. "Connections tab" in
one step, "Connection Manager" in another) — this is confusing even when
both are technically accurate.

## Forward references

Don't require or reference a concept, term, or UI element before the guide
has introduced it.

## Internal contradictions

Any place the guide states a fact, value, or name that conflicts with what
it states elsewhere (a different field name, a different expected result, a
different named project) is a bug regardless of which version is correct —
flag both locations.
