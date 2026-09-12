---
description: Start Gadriel's watch mode for on-save scanning in the background
allowed-tools: Bash(gadriel:*)
---

# /gadriel:watch

Start `gadriel code watch` from the project root as a **background** Bash
command. It runs until stopped and would otherwise block the session.

Watch mode re-runs Gadriel's fast per-file scanners whenever a source file
changes and updates `.security/findings.json`. Deeper analysis still needs
`/gadriel:scan`.

Tell the user it is running, how to read its output, and that stopping the
background task ends it. If a watch process is already running for this
project, do not start a second one.
