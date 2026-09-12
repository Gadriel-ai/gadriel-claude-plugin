---
description: Propose and apply a remediation for one Gadriel finding by ID
allowed-tools: Bash(gadriel:*), Bash(jq:*)
argument-hint: <FINDING-ID>
---

# /gadriel:fix

Remediate one Gadriel finding. The argument is the rule code the scanner
reported, for example `CODE-W1-L3-017` or `CODE-W1-AI-636`.

If no finding ID was given, list the top open findings with
`gadriel code findings` and ask the user which one to fix.

## Gadriel's remediation

!`gadriel code fix $ARGUMENTS`

## What to do with it

1. Confirm the finding is still open in `.security/findings.json`.
2. Apply the fix, following the matching `gadriel-*` skill and the codebase's
   existing patterns.
3. Re-scan the affected file with `gadriel code scan <path>` and confirm the
   finding is gone.
