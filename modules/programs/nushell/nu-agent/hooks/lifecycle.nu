# Lifecycle signals to the surrounding multiplexer, for the two terminals this
# repo configures: herdr's pane protocol, and Rex's Program Status Protocol
# (OSC 7501). Each side returns when its marker variable is absent, so the hook
# is a no-op anywhere else. Failures are swallowed: a turn must never depend on
# the terminal understanding the report.
const AGENT_ID = 'nu-a'

# ─── shared ───────────────────────────────────────────────────────────────

def agent_label [agent?: any] {
  if $agent == null { $AGENT_ID } else { $"($AGENT_ID): ($agent)" }
}

# Free text is one line for both protocols: herdr prints it, OSC 7501 forbids
# control characters outright and takes it base64'd.
def flatten [text: any limit: int] {
  let flat = ($text | into string | str replace --all --regex '\s+' ' ' | str trim)
  $flat | str substring 0..<$limit
}

# OSC 7501 values exclude ':' and ';' and control characters.
def sanitize [text: any limit: int] {
  let clean = ($text | into string | str replace --all --regex '[^A-Za-z0-9_.,+/=-]+' '-')
  $clean | str substring 0..<$limit
}

# A hook event's payload is optional; reading a missing column aborts the hook.
def prompt_of [event: record] {
  let payload = ($event | get --optional payload | default {})
  $payload | get --optional prompt
}

# ─── herdr ──────────────────────────────────────────────────────────────────

def herdr_report [state: string message?: any agent?: any] {
  let pane = $env.HERDR_PANE_ID?
  if $pane == null { return }
  let bin = ($env.HERDR_BIN_PATH? | default 'herdr')
  let args = ([
    $pane
    report-agent
    $pane
    --source
    nu-agent
    --agent
    (agent_label $agent)
    --state
    $state
    --seq
    (date now | into int)
  ] ++ (if $message == null { [] } else { [--message (flatten $message 79)] }))
  try { ^$bin ...$args }
}

def herdr_release [agent?: any] {
  let pane = $env.HERDR_PANE_ID?
  if $pane == null { return }
  let bin = ($env.HERDR_BIN_PATH? | default 'herdr')
  try { ^$bin pane release-agent $pane --source nu-agent --agent (agent_label $agent) }
}

# ─── rex ───────────────────────────────────────────────────────────────────

# The report belongs to the terminal the agent runs in, not to our stdout, which
# the hook runner captures.
def rex_emit [body: string] {
  let tty = (try { ^tty | str trim } catch { '' })
  if not ($tty | str starts-with '/dev/tty') { return }
  let esc = (char -u '1b')
  try { ^printf '%s' $"($esc)]7501;($body)($esc)\\" out> $tty }
}

# Every report replaces its record, so app travels with each one.
def rex_report [state: string message?: any agent?: any kind?: any] {
  if $env.REX_BLOCK? == null { return }
  let app = (if $agent == null { $AGENT_ID } else { sanitize $agent 32 })
  let pairs = ([$'state=($state)' $'app=($app)']
    | append (if $kind == null { [] } else { [$'kind=(sanitize $kind 16)'] })
    | append (if $message == null { [] } else { [$'msg=(flatten $message 200 | encode base64)'] }))
  rex_emit ($pairs | str join ':')
}

# ─── events ────────────────────────────────────────────────────────────────

def agent_started [event: record] {
  herdr_report idle null $event.agent?
  rex_report idle null $event.agent?
}

def turn_started [event: record] {
  herdr_report working (prompt_of $event) $event.agent?
  rex_report working (prompt_of $event) $event.agent?
}

def turn_completed [event: record] {
  # herdr has no finished state; Rex distinguishes done from idle so the result
  # stays visible in the session picker until looked at.
  herdr_report idle null $event.agent?
  rex_report done 'Finished this turn' $event.agent?
}

def permission_requested [event: record] {
  herdr_report blocked null $event.agent?
  rex_report blocked (prompt_of $event) $event.agent? permission
}

def permission_decision_timed_out [event: record] {
  herdr_report working null $event.agent?
  rex_report working null $event.agent?
}

def permission_decision_submitted [event: record] {
  herdr_report working null $event.agent?
  rex_report working null $event.agent?
}

def permission_request_cancelled [event: record] {
  herdr_report idle null $event.agent?
  rex_report idle null $event.agent?
}

def agent_switched [event: record] {
  herdr_report idle null $event.agent?
  rex_report idle null $event.agent?
}

def agent_shutdown [event: record] {
  herdr_release $event.agent?
  rex_report clear null $event.agent?
}
