local super = {"ctrl", "alt", "cmd"}
local sl = require("smartLaunch")

hs.loadSpoon("MiroWindowsManager")

hs.window.animationDuration = 0.3
spoon.MiroWindowsManager:bindHotkeys({
  up = {super, "up"},
  right = {super, "right"},
  down = {super, "down"},
  left = {super, "left"},
  fullscreen = {super, "f"},
  nextscreen = {super, "n"}
})

require "slowq"    -- Avoid accidental Cmd-Q

hs.hotkey.bind(super, 'P', function()
  hs.openPreferences()
end)

hs.hotkey.bind(super, 'R', function()
  hs.reload()
end)