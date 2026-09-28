---
title: Escalation Routing
tier: advanced
course: Enterprise MCP Essentials
module: Enterprise MCP
lab_number: 3
lab_total: 3
time_estimate: "45 minutes"
---

## Task -- Configure Escalation Routing

#### Hook

The on-call queue is drowning in low-priority noise, and the one ticket
that actually needs a human right now is buried in it.

#### Walkthrough

You'll end up with a decision table step, wired directly after the
trigger, that reroutes any ticket tagged `escalation` to the on-call
queue and leaves everything else on the default queue.

#### Intent

Escalation routing is the same branching pattern from Task 1.1, applied
to a second condition -- the goal here is recognizing the pattern
without a walkthrough of every click.

#### Verifier

Verify escalation-tagged tickets land in the on-call queue.

#### Takeaway

A decision table scales better than a chain of if/else branches once you
have more than two routing conditions.

## Task -- Notify the Requester

#### Hook

The requester who filed the ticket has no idea it moved queues.

#### Walkthrough

You'll add a notification step after the routing decision table that
emails the requester whichever queue their ticket landed in.

#### Intent

Closing the loop with the requester is part of the routing contract, not
an optional nicety.

#### Verifier

Verify the requester receives an email naming the destination queue.

#### Takeaway

Routing logic isn't done until the people affected by it are told what
happened.
