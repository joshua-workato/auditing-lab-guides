# Smart Lead Router -- Lab Guide (excerpt: Section 5.2)

## Section 5.2: Route APAC leads

5.2.1 Open the **Route by Region** decision table. Add a new row to
park every APAC lead until a rep is assigned: name the row **"Park
APAC"** and set its condition to `region = APAC`.

5.2.2 Run the recipe once more with the sample leads to confirm APAC
leads now land in the parked bucket instead of being routed
immediately.

## Section 5.3: Assign priority

5.3.1 Open the **Assign Priority** formula step. Write a formula that
sets `priority` to `"high"` when `deal_value > 10000`, and `"normal"`
otherwise.

5.3.2 Run the step and confirm high-value leads are flagged correctly.
