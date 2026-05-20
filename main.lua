local base = debug.getinfo(1, 'S').source:match('^@(.+[/\\])') or ''

local config  = dofile(base .. 'config.lua')
local sm      = dofile(base .. 'state_machine.lua')
local ui      = dofile(base .. 'ui.lua')
local actions = dofile(base .. 'actions.lua')

local w, h = ui.window_size(config)
gfx.ext_retina = 1
gfx.init("Shortcuts", w, h, 0)
gfx.clear = -1

sm.activate()
ui.draw(sm, config)
gfx.update()

local function loop()
  local char = gfx.getchar()

  if char == -1 then
    -- window closed
    sm.cancel()
  elseif char == 27 then
    -- Escape
    sm.cancel()
  elseif char == 8 then
    -- Backspace: step back to namespace selection
    if sm.is_action() then sm.activate() end
  elseif char > 0 and char < 256 then
    local key = string.char(char):lower()

    if sm.is_namespace() then
      sm.select_namespace(key, config.bindings)
    elseif sm.is_action() then
      local ns = config.bindings[sm.namespace]
      if ns and ns.keys[key] then
        actions.execute(ns.keys[key].cmd)
        sm.cancel()
      end
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
