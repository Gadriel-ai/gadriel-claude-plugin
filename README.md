# Gadriel — AI Security Harness for Claude Code

Claude writes code fast. Gadriel makes sure what it writes is safe.

This plugin puts [Gadriel](https://gadriel.ai) around Claude Code as a
security harness: every file Claude writes is scanned the moment it is written,
and when the change introduces a serious finding, Gadriel hands it straight
back to Claude with the fix, so it is corrected before the turn moves on.
Around that guardrail, Claude gets Gadriel's security tools, skills and
reviewer agents to find, explain and fix issues across the whole repo.

Gadriel covers SAST, secrets, dependencies (SCA and SBOM), containers and
configuration, including AI-specific risks such as prompt injection and the
OWASP LLM Top 10, with 3,000+ rules. Scanning runs on your machine.

## Install

```
/plugin marketplace add Gadriel-ai/gadriel-claude-plugin
/plugin install gadriel@gadriel
```

Then, in a repository:

```
/gadriel:scan
```

The first scan creates `.security/` in the repo and switches the guardrail on
there. That is deliberate: the plugin is enabled everywhere, but it only acts
in repositories you have scanned, and never writes into one you have not.

## Use cases

**Catch vulnerabilities as Claude writes them.** You ask for a feature and
Claude writes `subprocess.run("ls " + name, shell=True)`. The guardrail replies
at once — *"[Critical] CODE-W1-L3-017: pass the command as a list and never set
`shell=True`"* — and Claude fixes it before it moves on.

**Check before you open a PR.** `/gadriel:scan` for a verdict and the findings
that matter, then `/gadriel:fix CODE-W1-L3-017`: Claude applies the fix and
re-scans to prove the finding is gone.

**Secure AI applications.** *"Review this agent for prompt injection and
hardcoded LLM keys."* The OWASP LLM Top 10 and AI-secrets skills load on their
own, and Gadriel's MCP configuration rules flag unpinned `npx` servers,
plaintext tokens and plain-HTTP remote servers.

**Vet third-party skills and MCP servers before you trust them.** *"Scan this
skill I downloaded."* Gadriel flags skill instructions that override the user
or direct destructive or exfiltrating actions, such as a skill that tells
Claude to send out your SSH key. Hooks are not analyzed yet, so review any
hook commands a third-party plugin ships yourself.

**Produce compliance evidence.** `/gadriel:reports` renders PDFs for the OWASP
LLM Top 10, SOC 2, HIPAA, the EU AI Act, NIST AI RMF and cyber-insurance
readiness from the latest scan.

**Get a specialist review.** *"Have the security reviewer go over the auth
module."* Claude delegates to `gadriel:gadriel-security-reviewer`, which
confirms or dismisses each finding, explains it and proposes a fix in your
codebase's own style.

## What you get

**The guardrail.** After every `Write`/`Edit`, Gadriel re-scans the file. A
finding at or above High is fed back to Claude with the remediation:

```
⚠ Gadriel guardrail: 1 security finding(s) at or above High in app.py. Fix these before continuing:
  [Critical] CODE-W1-L3-017 (sast):2
      → Pass the command + arguments as a list — `subprocess.run(["echo", user])` — and never set `shell=True`.
```

**Commands**

| Command | Does |
|---|---|
| `/gadriel:scan [path]` | Full scan, or one directory or file |
| `/gadriel:status` | Open findings from the last scan |
| `/gadriel:fix <FINDING-ID>` | Remediate one finding and verify it is gone |
| `/gadriel:reports` | Compliance PDFs per pillar (OWASP, EU AI Act, NIST AI RMF, SOC 2, …) |
| `/gadriel:watch` | On-save scanning in the background |

**MCP tools** (server `gadriel`): `validate_file`, `validate_buffer`,
`findings_for_path`, `fix_finding`, `dismiss_false_positive`,
`start_remediation_campaign`, `campaign_advance`, `submit_ai_findings`.

**Skills** — 17, loaded when relevant: OWASP Web Top 10, OWASP LLM Top 10, AI
secrets catalog, AI config security, API security patterns, Dockerfile best
practices, SBOM guidance, license compatibility, EU AI Act and NIST AI RMF
mappers, A2A contracts, graph attack patterns, human-in-the-loop patterns,
output schemas, deadlock resolution, Bayesian calibration, token cost
estimation.

**Reviewer agents** — 8: security, safety, compliance, operational, coherence,
bias, FinOps and teamwork reviewers.

## How the scanner gets onto your machine

The plugin itself is small; the scanner is the `gadriel` binary. The launcher
in `bin/gadriel` uses, in order:

1. `$GADRIEL_BIN`, if you set it;
2. a `gadriel` already on your `PATH` (for example `npm install -g gadriel`);
3. otherwise the pinned release (currently **1.4.0**), downloaded once from
   `registry.npmjs.org` and cached in `~/.cache/gadriel-claude-plugin`.

A downloaded package is checked against the SHA-512 pinned in the launcher —
the npm registry's own integrity value for that release — and is deleted, not
run, if it does not match.

**Supported:** macOS and Linux (glibc), x64 and arm64. Windows works through
WSL; native Windows is not supported yet. Needs `curl` and `tar` for the
first download.

## Network and data

Your code is scanned locally and is not uploaded. Gadriel makes these network
calls:

| When | Where | What is sent |
|---|---|---|
| First use of the launcher | `registry.npmjs.org` | Downloads the pinned `gadriel` release |
| First run on a machine | `app.gadriel.ai` `POST /api/v1/auth/anonymous` | A random device ID created on your machine (no hostname, MAC, username or disk serial), the client version, and the environment (e.g. local or CI). This registers a free anonymous device credential. |
| Credential refresh | `app.gadriel.ai` `GET /api/v1/auth/whoami` | That credential, the client version, and aggregate run counts (how many scans of each kind ran) |
| Rule or vulnerability-database updates | Gadriel servers and the public [OSV](https://osv.dev) database | Downloads rule and advisory data |

To skip device registration, set `GADRIEL_NO_ANONYMOUS_AUTH=1`; scanning keeps
working unregistered. See the [privacy policy](https://gadriel.ai/privacy).

## Configuration

| Variable | Effect |
|---|---|
| `GADRIEL_GUARDRAIL` | `off` disables the edit guardrail; `critical` blocks only on critical findings |
| `GADRIEL_NO_ANONYMOUS_AUTH` | `1` skips anonymous device registration |
| `GADRIEL_BIN` | Use this `gadriel` binary instead of resolving one |
| `GADRIEL_PLUGIN_CACHE` | Where the launcher caches the downloaded binary |

If a project was already set up with `gadriel code init`, its
`.claude/settings.json` and `.mcp.json` wire Gadriel in as well. Use one or the
other in that project, not both, or every hook runs twice.

## License

The plugin — everything in this repository — is licensed under
[Apache-2.0](LICENSE). The `gadriel` scanner it runs is proprietary software
distributed under the [Gadriel terms](https://gadriel.ai/terms).
