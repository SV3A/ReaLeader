local M = {}

-- Base constants in logical points; draw() scales them by the retina factor at runtime
local PAD   = 18
local ROW_H = 30
local KEY_W = 32

local logical_w = 380  -- updated by window_size(); used to derive scale factor

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

local function sorted_items(node)
  local list = {}
  for k, v in pairs(node) do list[#list+1] = {key = k, label = v.label} end
  table.sort(list, function(a, b) return a.key < b.key end)
  return list
end

local function build_title(path, root)
  if #path == 0 then return "Shortcuts" end
  local parts = {}
  local node = root
  for _, k in ipairs(path) do
    local entry = node[k]
    parts[#parts+1] = k .. " [" .. entry.label .. "]"
    node = entry.keys
  end
  return "Shortcuts  →  " .. table.concat(parts, "  →  ")
end

local function max_node_items(node)
  local count = 0
  for _ in pairs(node) do count = count + 1 end
  local max = count
  for _, v in pairs(node) do
    if v.keys then
      local child = max_node_items(v.keys)
      if child > max then max = child end
    end
  end
  return max
end

function M.draw(sm, config)
  local W, H = gfx.w, gfx.h
  local s    = W / logical_w  -- retina scale: 2.0 on HiDPI, 1.0 otherwise

  local pad   = math.floor(PAD   * s)
  local row_h = math.floor(ROW_H * s)
  local key_w = math.floor(KEY_W * s)

  col(C.bg)
  gfx.rect(0, 0, W, H, 1)

  col(C.border)
  gfx.rect(0, 0, W, 1, 1)
  gfx.rect(0, H - 1, W, 1, 1)
  gfx.rect(0, 0, 1, H, 1)
  gfx.rect(W - 1, 0, 1, H, 1)

  if sm.is_idle() then return end

  local title = build_title(sm.path, config.bindings)
  local items = sorted_items(sm.node)

  -- title
  gfx.setfont(1, "Helvetica Neue", math.floor(18 * s))
  col(C.title)
  gfx.x, gfx.y = pad, pad
  gfx.drawstr(title)

  -- separator
  local sep_y = pad + math.floor(20 * s)
  col(C.sep)
  gfx.line(pad, sep_y, W - pad, sep_y)

  -- rows
  gfx.setfont(1, "Menlo", math.floor(16 * s))
  for i, item in ipairs(items) do
    local y = sep_y + math.floor(6 * s) + (i - 1) * row_h

    col(C.key_bg)
    gfx.rect(pad, y, key_w, row_h - math.floor(3 * s), 1)

    col(C.key_fg)
    local kw = gfx.measurestr(item.key)
    gfx.x = pad + math.floor((key_w - kw) / 2)
    gfx.y = y + math.floor(5 * s)
    gfx.drawstr(item.key)

    col(C.label)
    gfx.x = pad + key_w + math.floor(10 * s)
    gfx.y = y + math.floor(5 * s)
    gfx.drawstr(item.label)
  end

  -- hint
  gfx.setfont(1, "Helvetica Neue", math.floor(13 * s))
  col(C.hint)
  gfx.x = pad
  gfx.y = H - pad - math.floor(13 * s)
  gfx.drawstr("esc: cancel    backspace: back")
end

function M.window_size(config)
  local rows = max_node_items(config.bindings)
  local h    = PAD + 20 + 6 + rows * ROW_H + 6 + 20 + PAD
  logical_w  = 380
  return logical_w, h
end

return M
