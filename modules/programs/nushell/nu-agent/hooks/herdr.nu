# Best-effort lifecycle signals to the surrounding herdr pane.
# No-op outside herdr (no HERDR_PANE_ID). A failure logs one agent.log
# warning; the turn continues. Remove `try` to surface errors.

def report [state: string, message?: string] {
    let pane = $env.HERDR_PANE_ID?
    if $pane == null { return }
    let bin = ($env.HERDR_BIN_PATH? | default 'herdr')
    let args = ([
        pane report-agent $pane
        --source nu-agent --agent nu-agent --state $state
        --seq (date now | into int)
    ] ++ (if $message == null { [] } else { [--message ($message | str substring 0..79)] }))
    try { ^$bin ...$args }
}

def agent_started [event: record] { report idle }

def turn_started [event: record] { report working $event.payload.prompt }

def turn_completed [event: record] { report idle }

def permission_requested [event: record] { report blocked }

def permission_decision_timed_out [event: record] { report working }

def permission_decision_submitted [event: record] { report working }

def permission_request_cancelled [event: record] { report idle }

def agent_shutdown [event: record] {
    let pane = $env.HERDR_PANE_ID?
    if $pane == null { return }
    let bin = ($env.HERDR_BIN_PATH? | default 'herdr')
    try { ^$bin pane release-agent $pane --source nu-agent --agent nu-agent }
}
