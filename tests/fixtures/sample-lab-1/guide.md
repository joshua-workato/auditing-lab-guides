# Smart Lead Router -- Lab Guide (v1)

## Prerequisites

Log in to the training portal via Okta using the credentials emailed to
you, then open Workato.

You should see a project called **"Lead Routing Essentials"** already in
your workspace, with a `[Lead Routing] Connections` folder containing the
Gmail, Jira, and Asana connections you'll need.

## Exercise A: Route the lead

1. Open the **New Lead Router** recipe. It already has a Gmail trigger and
   a Jira "Search Issues" step pre-built for you.
2. Under **Inspect these assets** in the Connections tab, review the
   trigger's output fields.
3. Add a Jira action called **"Update Issue Priority"** and connect it
   after the search step.
4. Map the new task's fields as follows: Name comes from the email
   subject, Assignee comes from the email sender, Priority comes from the
   ticket's Issue Key, which is available on the trigger.
5. Run the recipe and confirm a new Jira issue is created with priority
   set.
6. Verify your work: check that the recipe ran with no errors and the
   Jira issue shows the correct priority.

## Exercise B: Notify the team

1. Open the same recipe and add a Slack action after the Jira step.
2. Map the Slack message body from the Slack thread's parent message
   text.
3. Set the channel, username, icon, and thread option fields as follows:
   channel is `#leads`, username is `Lead Bot`, icon is `:robot_face:`,
   and thread option is `Reply in thread`.
4. Run the recipe once more to confirm the Slack message posts.

## Notes on connector setup

Within the Connection Manager, double-check that your Jira connection is
still active before running either exercise.
