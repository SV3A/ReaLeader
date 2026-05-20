local M = {}

M.state     = "idle"
M.namespace = nil
M.timestamp = 0.0

function M.activate()
  M.state     = "namespace"
  M.namespace = nil
  M.timestamp = reaper.time_precise()
end

function M.select_namespace(key, bindings)
  if bindings[key] then
    M.state     = "action"
    M.namespace = key
    M.timestamp = reaper.time_precise()
    return true
  end
  return false
end

function M.cancel()
  M.state     = "idle"
  M.namespace = nil
end

function M.is_idle()      return M.state == "idle"      end
function M.is_namespace() return M.state == "namespace" end
function M.is_action()    return M.state == "action"    end

function M.check_timeout(timeout)
  if M.is_idle() then return false end
  if reaper.time_precise() - M.timestamp > timeout then
    M.cancel()
    return true
  end
  return false
end

return M
