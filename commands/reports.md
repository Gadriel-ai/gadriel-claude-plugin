---
description: Generate Gadriel's compliance reports (PDF) for every pillar
allowed-tools: Bash(gadriel:*)
---

# /gadriel:reports

Render Gadriel's compliance reports from the latest scan into
`.security/compliance/`: one per pillar plus an umbrella report, mapped to the
frameworks the project uses (OWASP, EU AI Act, NIST AI RMF, SOC 2 and others).

A PARTIAL compliance verdict is normal for any repo with open findings and is
not a rendering failure; `--fail-on render-only` reserves a non-zero exit for a
report that could not be rendered.

## Output

!`gadriel code report --format pdf --all-pillars --fail-on render-only`

## What to do with it

List the generated files for the user. If the command reports that no scan
exists yet, suggest `/gadriel:scan` first.
