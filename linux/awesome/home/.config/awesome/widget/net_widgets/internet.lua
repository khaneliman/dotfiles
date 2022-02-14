local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")
local module_path = (...):match ("(.+/)[^/]+$") or ""

local theme = beautiful.get()

local internet = {}
local function worker(args)
  local args = args or {}
  local widget = wibox.container.background()
  -- Icons made by http://www.flaticon.com/authors/maxim-basinski from www.flaticon.com
  local ICON_DIR = awful.util.getdir("config").."/"..module_path.."/net_widgets/icons/"
  local yes_internet = wibox.widget {
    {
      widget = wibox.widget.imagebox,
      image = ICON_DIR.."internet.png",
      resize = false,
    },
    layout = wibox.container.margin(brightness_icon, 0, 0, 2)
  }
  local no_internet = wibox.widget {
    {
      widget = wibox.widget.imagebox,
      image = ICON_DIR.."internet_na.png",
      resize = false,
    },
    layout = wibox.container.margin(brightness_icon, 0, 0, 2)
  }
  -- Settings
  local timeout = args.timeout or 5
  local onclick = args.onclick
  local showconnected = args.showconnected or false

  local connected = false

  widget:set_widget(no_internet)
  local function net_update()
    connected = false
    awful.spawn.easy_async("bash -c \"nc -z 8.8.8.8 53 >/dev/null 2>&1\"",
      function(_, _, _, exit_code)
        if (exit_code == 0) then
          connected = true
        end
        if connected then
          if showconnected then
            widget:set_widget(yes_internet)
          else
            widget:set_widget(nil)
          end
        else
            widget:set_widget(no_internet)
        end
      end)

    return true
  end

  net_update()

  gears.timer.start_new(timeout, net_update)

  -- Bind onclick event function
  if onclick then
    widget:buttons(awful.util.table.join(
        awful.button({}, 1, function() awful.util.spawn(onclick) end)
    ))
  end

  return widget
end
return setmetatable(internet, {__call = function(_,...) return worker(...) end})

-- vim: set ts=2 sw=2 sts=2:
