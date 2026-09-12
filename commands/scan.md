---
description: Scan the repo (or one path) with Gadriel - SAST, secrets, dependencies, containers, config
allowed-tools: Bash(gadriel:*), Bash(jq:*)
argument-hint: [path]
---

# /gadriel:scan

Scan the current repository with Gadriel, or only the path given as an argument
(a directory or a single file).

Results are written to `.security/` at the project root: `findings.json`,
`pillar-scores.json`, SBOMs and compliance reports. The first scan in a repo
also switches on Gadriel's edit guardrail there: the plugin's hooks act only in
projects that have a `.security/` directory.

## Scan output

!`gadriel code scan $ARGUMENTS`

## What to do with it

Summarise the result for the user: the verdict, finding counts by severity, and
the most important findings with file and line. Offer `/gadriel:fix <FINDING-ID>`
for anything they want fixed.
