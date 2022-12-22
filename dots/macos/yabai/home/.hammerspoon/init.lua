local hyper = { "ctrl", "alt", "cmd" }
require("smartLaunch")

hs.loadSpoon("MiroWindowsManager")

hs.window.animationDuration = 0.3
spoon.MiroWindowsManager:bindHotkeys({
  up = { hyper, "up" },
  right = { hyper, "right" },
  down = { hyper, "down" },
  left = { hyper, "left" },
  fullscreen = { hyper, "f" },
  nextscreen = { hyper, "n" }
})

require("slowq") -- Avoid accidental Cmd-Q

hs.hotkey.bind(hyper, "P", function() hs.openPreferences() end)
hs.hotkey.bind(hyper, "R", function() hs.reload() end)

hs.loadSpoon("ReloadConfiguration")
spoon.ReloadConfiguration:start()

hs.loadSpoon("ClipboardTool")
spoon.ClipboardTool:start()

hs.loadSpoon("ColorPicker")
spoon.ColorPicker:start()
spoon.ColorPicker:bindHotkeys({ show = { hyper, "C" } })

hs.loadSpoon("Commander")
-- spoon.Commander:start()

hs.loadSpoon("EjectMenu")
spoon.EjectMenu:start()

hs.loadSpoon("KSheet")
spoon.KSheet:bindHotkeys({ toggle = { hyper, "K" } })
