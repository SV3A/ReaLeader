local M = {}

M.state     = "idle"
M.path      = {}   -- keys pressed so far, e.g. {"t", "c"}
M.node      = nil  -- the keys-table currently being browsed
M.timestamp = 0.0

function M.activate(root)
  M.state     = "active"
  M.path      = {}
  M.node      = root
  M.timestamp = reaper.time_precise()
end

-- Returns "action", cmd  → matched a leaf, execute cmd
--         "deeper"       → matched a branch, descended one level
--         "invalid"      → key not found in current node
function M.select(key)
  local entry = M.node[key]
  if not entry then return "invalid" end

  if entry.cmd then
    return "action", entry.cmd
  elseif entry.keys then
    M.path[#M.path + 1] = key
    M.node      = entry.keys
    M.timestamp = reaper.time_precise()
    return "deeper"
  end
  return "invalid"
end

-- Step back one level; cancels entirely if already at root
function M.back(root)
  if #M.path == 0 then
    M.cancel()
    return
  end
  table.remove(M.path)
  M.node = root
  for _, k in ipairs(M.path) do
    M.node = M.node[k].keys
  end
  M.timestamp = reaper.time_precise()
end

function M.cancel()
  M.state = "idle"
  M.path  = {}
  M.node  = nil
end

function M.is_idle()   return M.state == "idle"   end
function M.is_active() return M.state == "active" end

function M.check_timeout(timeout)
  if M.is_idle() then return false end
  if reaper.time_precise() - M.timestamp > timeout then
    M.cancel()
    return true
  end
  return false
end

return M
