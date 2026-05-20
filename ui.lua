local M = {}

local PAD   = 14
local ROW_H = 24
local KEY_W = 26

local C = {
  bg     = {0.11, 0.11, 0.13},
  border = {0.30, 0.30, 0.35},
  title  = {0.55, 0.80, 1.00},
  key_bg = {0.22, 0.22, 0.26},
  key_fg = {0.95, 0.78, 0.35},
  label  = {0.88, 0.88, 0.88},
  sep    = {0.25, 0.25, 0.30},
  hint   = {0.42, 0.42, 0.47},
}

local function col(c) gfx.r, gfx.g, gfx.b, gfx.a = c[1], c[2], c[3], 1.0 end

local function sorted_items(tbl)
  local list = {}
  for k, v in pairs(tbl) do list[#list+1] = {key = k, label = v.label} end
  table.sort(list, function(a, b) return a.key < b.key end)
  return list
end

function M.draw(sm, config)
  local W, H = gfx.w, gfx.h

  col(C.bg)
  gfx.rect(0, 0, W, H, 1)

  col(C.border)
  gfx.rect(0, 0, W, 1, 1)
  gfx.rect(0, H - 1, W, 1, 1)
  gfx.rect(0, 0, 1, H, 1)
  gfx.rect(W - 1, 0, 1, H, 1)

  if sm.is_idle() then return end

  local items, title

  if sm.is_namespace() then
    title = "leader"
    items = sorted_items(config.bindings)
  else
    local ns = config.bindings[sm.namespace]
    title = "leader  →  " .. sm.namespace .. "   [" .. ns.label .. "]"
    items = sorted_items(ns.keys)
  end

  -- title
  gfx.setfont(1, "Arial", 15)
  col(C.title)
  gfx.x, gfx.y = PAD, PAD
  gfx.drawstr(title)

  -- separator
  local sep_y = PAD + 20
  col(C.sep)
  gfx.line(PAD, sep_y, W - PAD, sep_y)

  -- rows
  gfx.setfont(1, "Courier New", 13)
  for i, item in ipairs(items) do
    local y = sep_y + 6 + (i - 1) * ROW_H

    col(C.key_bg)
    gfx.rect(PAD, y, KEY_W, ROW_H - 3, 1)

    col(C.key_fg)
    local kw = gfx.measurestr(item.key)
    gfx.x = PAD + math.floor((KEY_W - kw) / 2)
    gfx.y = y + 5
    gfx.drawstr(item.key)

    col(C.label)
    gfx.x = PAD + KEY_W + 10
    gfx.y = y + 5
    gfx.drawstr(item.label)
  end

  -- hint
  gfx.setfont(1, "Arial", 11)
  col(C.hint)
  gfx.x = PAD
  gfx.y = H - PAD - 13
  gfx.drawstr("esc: cancel    backspace: back")
end

function M.window_size(config)
  local n_ns, max_act = 0, 0
  for _, ns in pairs(config.bindings) do
    n_ns = n_ns + 1
    local c = 0
    for _ in pairs(ns.keys) do c = c + 1 end
    if c > max_act then max_act = c end
  end
  local rows = math.max(n_ns, max_act)
  local h    = PAD + 20 + 6 + rows * ROW_H + 6 + 20 + PAD
  return 310, h
end

return M
