


# ReaLeader

Vim-style nested keyboard shortcuts for [REAPER](https://www.reaper.fm/). Press a leader key to open a which-key overlay, then type a short sequence to trigger any action - without memorizing dozens of modifier combinations.

```
L → t → m     mute selected track(s)
L → t → c → c set random custom color
L → s → m     toggle mixer
L → f → f     show FX chain
```

https://github.com/user-attachments/assets/0045db1e-0785-4932-bbc2-7c39127ee5ed

## How it works

1. Press your **leader key** (e.g. `L`) - a floating overlay appears listing all namespaces
2. Press a **namespace key** (e.g. `t` for Tracks) - the overlay updates to show that namespace's actions
3. Press an **action key** (e.g. `m` for Mute) - the action fires and the overlay closes

Sequences can be nested to any depth. Press `Backspace` to step back one level, `Esc` to cancel.

## Requirements

- REAPER 6+
- [SWS Extension](https://www.sws-extension.org/) - required for any bindings that use named commands (strings starting with `_`)

## Installation

1. Clone the this repo into REAPERs `Scripts/` directory
2. In REAPER: **Actions → Show action list → Load ReaScript**
3. Select `rea_leader/main.lua` - it will appear as *Script: main.lua*
4. Click **Add shortcut** and press your chosen leader key

## Customizing bindings

All bindings live in `config.lua`. The structure is a nested Lua table:

```lua
M.bindings = {
  t = {                             -- namespace key
    label = "Tracks",               -- shown in the overlay
    keys = {
      n = { label = "New track", cmd = 40001 },  -- action key → command ID
      c = { label = "Color", keys = {            -- nested submenu
        c = { label = "Random color", cmd = "_SWS_TRACKRANDCOL" },
      }},
    }
  },
}
```

- **`cmd`** accepts a REAPER command ID (number) or a named command string (e.g. `"_SWS_TRACKRANDCOL"`)
- **`keys`** instead of `cmd` creates a sub-menu - nesting works at any depth
- **`M.timeout`** controls how many seconds of inactivity cancel the sequence

### Finding command IDs

**Actions → Show action list** → select an action → right-click → **Copy selected action command ID**

The ID is a plain number for built-in actions, or a `_`-prefixed string for SWS/ReaPack scripts. Both work in `config.lua`.

## Files

```
rea_leader/
  main.lua          - entry point (bind this to your leader key)
  config.lua        - all key bindings (the only file you need to edit)
  state_machine.lua - tracks the current position in the binding tree
  ui.lua            - gfx overlay rendering
  actions.lua       - executes REAPER commands
```
