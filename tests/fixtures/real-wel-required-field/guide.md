# Smart Lead Router -- Lab Guide (excerpt: Section 1.2)

## Section 1.2: Validate the incoming leads

1.2.1 Open the **Validate Lead** code step. This step is pre-built for
you -- it checks each incoming lead against the routing schema before
anything downstream runs.

1.2.2 The step is wired to the sample leads array below. Run the step
now to confirm your sample data is ready for the rest of the lab:

```json
[
  { "name": "Amit Shah", "email": "amit.shah@example.com", "company": "Northwind" },
  { "name": "Dana Reyes", "email": "dana.reyes@example.com", "company": "Acme Corp" },
  { "name": "Barbara Lin", "email": "", "company": "Globex" }
]
```

1.2.3 Click **Run this step**. You should see the step complete with no
errors, confirming your sample data is ready for the next section.
