-- Rex key bindings. The prefix is ctrl+a, as in modules/programs/herdr.
-- Rex has no prefix of its own: a prefix key becomes the first key of a
-- sequence, so `bind X` in tmux is `ctrl+a>X` here and `bind -n X` is X alone.
-- Apply changes with `rex config reload`, inspect them with `rex keymap`.

-- Hosts this machine reaches by a forwarded socket, generated from hosts.nix.
@hosts@

-- Tabs (tmux windows)
rex.bind("ctrl+a>c", "client.tab.new")
rex.bind("ctrl+a>n", "client.tab.next")
rex.bind("ctrl+a>p", "client.tab.previous")
rex.bind("ctrl+a>,", "client.tab.rename")

for i = 1, 9 do
  rex.bind("ctrl+a>" .. i, "client.tab.goto", { index = i })
end

-- Splits: | and \ side by side, - and _ stack
rex.bind("ctrl+a>shift+\\", "pane.split", { direction = "right" })
rex.bind("ctrl+a>shift+5", "pane.split", { direction = "right" })
rex.bind("ctrl+a>-", "pane.split", { direction = "down" })
rex.bind("ctrl+a>shift+-", "pane.split", { direction = "down" })
rex.bind("ctrl+a>shift+'", "pane.split", { direction = "down" })

-- Pane focus: arrows as in tmux, hjkl as in herdr
rex.bind("ctrl+a>left", "pane.focus", { direction = "left" })
rex.bind("ctrl+a>right", "pane.focus", { direction = "right" })
rex.bind("ctrl+a>up", "pane.focus", { direction = "up" })
rex.bind("ctrl+a>down", "pane.focus", { direction = "down" })
rex.bind("ctrl+a>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+a>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+a>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+a>l", "pane.focus", { direction = "right" })
rex.bind("ctrl+a>o", "pane.focus_next")

-- Resize with the prefix held, as tmux does; every press moves by one step
rex.bind("ctrl+a>ctrl+left", "pane.resize", { direction = "left" })
rex.bind("ctrl+a>ctrl+right", "pane.resize", { direction = "right" })
rex.bind("ctrl+a>ctrl+up", "pane.resize", { direction = "up" })
rex.bind("ctrl+a>ctrl+down", "pane.resize", { direction = "down" })

-- Pane lifecycle
rex.bind("ctrl+a>x", "pane.close")
rex.bind("ctrl+a>z", "pane.zoom")
rex.bind("ctrl+a>space", "pane.balance")

-- Sessions
rex.bind("ctrl+a>s", "session.switch")
-- tmux's prefix+w lists windows; Rex's nearest is the session picker, and
-- pane.go_to is its choose-tree over panes, tabs and sessions.
rex.bind("ctrl+a>w", "session.switch")

-- laio picker in a floating layer, as modules/programs/herdr binds its popup.
-- Rex has no popup key type: a floating layer is the nearest equivalent.
rex.action{
  name = "laio_picker",
  title = "Open laio Picker",
  description = "Choose a laio configuration and open it in a floating layer.",
  keywords = "laio session layout picker popup",
  run = function(ctx, args)
    local _, err = rex.session.new_layer{
      bounds = {0.25, 0.25, 0.5, 0.4},
      focus = true,
      layout = rex.layout.block{
        flavor = "com.superlogical.terminal.shell",
        label = "laio",
        options = {
          command = {"@laio@", "start", "--muxer", "rex", "--show-picker"},
        },
      },
    }
    if err ~= nil then error(err, 0) end
  end,
}

rex.bind("ctrl+a>alt+l", "laio_picker")

-- A prefix starts a sequence, so it no longer reaches the terminal by itself
rex.bind("ctrl+a>ctrl+a", "pane.send_key", { key = "ctrl+a" })
