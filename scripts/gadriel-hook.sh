#!/bin/sh
# Claude Code hook shim for the Gadriel plugin.
#
# The plugin is enabled in every project, but Gadriel only acts where it
# already keeps state: a `.security/` directory, which the first
# `/gadriel:scan` creates. Everywhere else these hooks exit 0 untouched, so the
# plugin never writes into a repo you have not scanned.
#
# `post-edit` is Gadriel's inline guardrail: when the file Claude just wrote
# has a finding at or above the threshold, gadriel prints it to stderr and
# exits 2, which Claude Code feeds back so the code is fixed before the turn
# continues. Every other event is silent and can never fail the session.
# GADRIEL_GUARDRAIL=off disables the guardrail; =critical blocks only on
# critical findings.
event=${1:-}
root=${CLAUDE_PROJECT_DIR:-$PWD}

[ -d "$root/.security" ] || exit 0

launcher=$(dirname -- "$0")/../bin/gadriel
export GADRIEL_PLUGIN_NO_DOWNLOAD=1
# The guardrail's stderr goes to Claude verbatim; keep log lines out of it.
export RUST_LOG=${RUST_LOG:-error}

if [ "$event" = post-edit ]; then
  "$launcher" hooks "$@"
  # 2 is the guardrail's "fix this first"; anything else is not Claude's problem.
  [ $? -eq 2 ] && exit 2
  exit 0
fi

"$launcher" hooks "$@" 2>/dev/null || true
exit 0
