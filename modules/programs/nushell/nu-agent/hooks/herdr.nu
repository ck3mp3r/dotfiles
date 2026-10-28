# Best-effort lifecycle signals to the surrounding herdr pane.
# No-op outside herdr (no HERDR_PANE_ID). A failure logs one agent.log
# warning; the turn continues. Remove `try` to surface errors.
const AGENT_ID = 'nu-a'

def report [state: string message?: any agent?: any] {
  let pane = $env.HERDR_PANE_ID?
  if $pane == null { return }
  let bin = ($env.HERDR_BIN_PATH? | default 'herdr')
  let label = (if $agent == null { $AGENT_ID } else { $"($AGENT_ID): ($agent)" })
  let args = (
    [
      pane
      report-agent
      $pane
      --source
      nu-agent
      --agent
      $label
      --state
      $state
      --seq
      (date now | into int)
    ] ++ (if $message == null { [] } else { [--message ($message | str substring 0..79)] })
  )
  try { ^$bin ...$args }
}

def agent_started [event: record] { report idle null $event.agent? }

def turn_started [event: record] { report working $event.payload.prompt $event.agent? }

def turn_completed [event: record] { report idle null $event.agent? }

def permission_requested [event: record] { report blocked null $event.agent? }

def permission_decision_timed_out [event: record] { report working null $event.agent? }

def permission_decision_submitted [event: record] { report working null $event.agent? }

def permission_request_cancelled [event: record] { report idle null $event.agent? }

def agent_switched [event: record] { report idle null $event.agent? }

def agent_shutdown [event: record] {
  let pane = $env.HERDR_PANE_ID?
  if $pane == null { return }
  let bin = ($env.HERDR_BIN_PATH? | default 'herdr')
  try { ^$bin pane release-agent $pane --source nu-agent --agent (if $event.agent? == null { $AGENT_ID } else { $"($AGENT_ID): ($event.agent)" }) }
}
