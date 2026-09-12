---
description: Show the open Gadriel findings from the last scan
allowed-tools: Bash(gadriel:*), Bash(jq:*)
---

# /gadriel:status

The findings recorded by the last scan. These come from `.security/`, so they
are only as fresh as that scan: after editing code, run `/gadriel:scan` first.

## Open findings

!`gadriel code findings`

## What to do with it

Give the user a one-screen answer to "is this repo clean?": counts by severity
and the few findings that matter most. If there is no scan yet, suggest
`/gadriel:scan`.
