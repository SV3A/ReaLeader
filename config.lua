local M = {}

M.timeout = 10.0  -- seconds of inactivity before the sequence cancels

--[[
  To find a command ID: Actions > Show action list > right-click an action >
  "Copy selected action command ID". Paste the number here.
  SWS/named commands use strings like "_SWS_SAVEALLVPENV"; those work too.
--]]

M.bindings = {
  t = {
    label = "Tracks",
    keys = {
      n = { label = "New track",   cmd = 40001 },
      d = { label = "Duplicate",   cmd = 40062 },
      x = { label = "Remove",      cmd = 40005 },
      m = { label = "Mute",        cmd = 6     },
      s = { label = "Solo",        cmd = 7     },
      c = { label = "Color", keys = {
        c = { label = "Random custom color", cmd = "_SWS_TRACKRANDCOL" },
      }},
    }
  },
  f = {
    label = "FXs",
    keys = {
      f = { label = "Show FX chain for sel. track(s)", cmd = "_S&M_SHOWFXCHAINSEL" },
      a = { label = "Show FX browser",      cmd = 40271 },
    }
  },
  i = {
    label = "Items",
    keys = {
      s = { label = "Split at cursor",      cmd = 40012 },
      d = { label = "Duplicate",            cmd = 41295 },
      m = { label = "Insert new MIDI item", cmd = 40214 },
    }
  },
  v = {
    label = "View",
    keys = {
      z = { label = "Zoom to selection", cmd = 40031 },
      i = { label = "Zoom in",           cmd = 1011  },
      o = { label = "Zoom out",          cmd = 1012  },
    }
  },
  p = {
    label = "Project",
    keys = {
      s = { label = "Save",   cmd = 40026 },
    }
  },
  s = {
    label = "Show",
    keys = {
      m = { label = "Mixer",          cmd = 40078 },
      e = { label = "Media explorer", cmd = 50124 },
      t = { label = "Track manager",  cmd = 40906 },
      i = { label = "Open items in primary ext editor",  cmd = 40109 },
    }
  },
}

return M
