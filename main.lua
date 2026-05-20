local base = debug.getinfo(1, 'S').source:match('^@(.+[/\\])') or ''

local config  = dofile(base .. 'config.lua')
local sm      = dofile(base .. 'state_machine.lua')
local ui      = dofile(base .. 'ui.lua')
local actions = dofile(base .. 'actions.lua')

local w, h = ui.window_size(config)
gfx.ext_retina = 1
gfx.init("Shortcuts", w, h, 0)
gfx.clear = -1

sm.activate(config.bindings)
ui.draw(sm, config)
gfx.update()

local function loop()
  local char = gfx.getchar()

  if char == -1 then
    sm.cancel()
  elseif char == 27 then
    sm.cancel()
  elseif char == 8 then
    sm.back(config.bindings)
  elseif char > 0 and char < 256 then
    local key = string.char(char):lower()
    local result, cmd = sm.select(key)
    if result == "action" then
      actions.execute(cmd)
      sm.cancel()
    end
  end

  sm.check_timeout(config.timeout)

  if sm.is_idle() then
    gfx.quit()
    return
  end

  ui.draw(sm, config)
  gfx.update()
  reaper.defer(loop)
end

reaper.defer(loop)
