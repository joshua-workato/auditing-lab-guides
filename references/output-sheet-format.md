# Fallback Output Format (no Google Sheets tool available)

Use this only when no Google Sheets tool is available in the current
environment. Say so explicitly before falling back to this -- don't switch
silently, since the person may need the Sheet and not this.

```
## Coverage

Of N Workato-specific claims found in the guide: X checked against connector
reference data, Y checked against pre-built project state, Z flagged
unverifiable (referenced step not yet built in the starter project).

## Findings

| # | Track | Location | Finding | Suggested fix |
|---|-------|----------|---------|----------------|
| 1 | Bug -- Lab | <recipe/file from lint-result.json> | <the linter's own message, don't reword it> | <fix> |
| 2 | Bug -- Discrepancy | Step 4 | <what's wrong, cite the source checked against> | <fix> |
| 3 | Bug -- Internal consistency | Step 2 vs. Step 9 | <the contradiction> | <fix> |
| 4 | Suggestion -- Presentation | Step 6 | <what to improve and why> | <fix> |
| 5 | Unverifiable | Step 7 | <what can't be checked and why> | Human should verify manually |

(Omit table rows/sections with zero findings, but keep the Coverage line.)
```
