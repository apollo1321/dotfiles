hs.loadSpoon("EmmyLua")
hs.ipc.cliInstall("/opt/homebrew")

local function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

local function focus_to_screen(x, y)
  local cur_x, cur_y = hs.window.focusedWindow():screen():position()

  if cur_x == x and cur_y == y then
    return
  end

  local f = hs.window.filter.new(function(w)
    local xx, yy = w:screen():position()
    return (xx == x) and (yy == y) and w:isStandard() and w:isVisible()
  end)

  local window = f:getWindows()[1]
  if window ~= nil then
    window:focus()
  end
  local screen = hs.screen{x, y}
  if screen ~= nil then
    hs.mouse.absolutePosition(screen:frame().center)
  end
end

hs.hotkey.bind({ "cmd" }, "J", function()
  focus_to_screen(0, 0)
end)


hs.hotkey.bind({ "cmd" }, "K", function()
  focus_to_screen(0, -1)
end)
