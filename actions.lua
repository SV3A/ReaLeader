local M = {}

function M.execute(cmd)
  if type(cmd) == "number" then
    reaper.Main_OnCommand(cmd, 0)
  elseif type(cmd) == "string" then
    local id = reaper.NamedCommandLookup(cmd)
    if id ~= 0 then reaper.Main_OnCommand(id, 0) end
  end
end

return M
