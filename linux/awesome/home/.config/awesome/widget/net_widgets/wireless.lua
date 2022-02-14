local wibox         = require("wibox")
local awful         = require("awful")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local gears         = require("gears")
local cairo         = require("lgi").cairo
local module_path = (...):match ("(.+/)[^/]+$") or ""

local theme = beautiful.get()

function dbg(message)
    naughty.notify({ preset = naughty.config.presets.normal,
                     title = "debug",
                     text = message })
end

local function draw_signal(level)
    -- draw 32x32 for simplicity, imagebox will resize it using loseless transform
    local img = cairo.ImageSurface.create(cairo.Format.ARGB32, 32, 32)
    local cr  = cairo.Context(img)

    cr:set_source(gears.color(theme.fg_normal))
    if level > 75 then
        cr:arc(         32/2, 32/2, 32/2, 145*math.pi/180, 395*math.pi/180)
        cr:arc_negative(32/2, 32/2, 32/2-3, 395*math.pi/180, 145*math.pi/180)
    end
    if level > 50 then
        cr:arc(         32/2, 32/2, 24/2, 145*math.pi/180, 395*math.pi/180)
        cr:arc_negative(32/2, 32/2, 24/2-3, 395*math.pi/180, 145*math.pi/180)
    end
    if level > 25 then
        cr:arc(         32/2, 32/2, 16/2, 145*math.pi/180, 395*math.pi/180)
        cr:arc_negative(32/2, 32/2, 16/2-3, 395*math.pi/180, 145*math.pi/180)
    end
    cr:rectangle(32/2-1, 32/2-1, 2, 32/2-2)
    cr:fill()

    if level == 0 then
        cr:set_source(gears.color("#cf5050"))
        gears.shape.transform(gears.shape.cross)
            :rotate(45*math.pi/180)
                :translate(12, -10)(cr, 10, 10, 3)
    end

    cr:close_path()
    cr:fill()
    return img
end

function net_stats(card,which)
    local prefix = {
        [0] = "",
        [1] = "K",
        [2] = "M",
        [3] = "G",
        [4] = "T"
    }

    local function readAll(file)
        local f = assert(io.open(file, "rb"))
        local content = f:read()
         f:close()
        return content
    end

    local function round(num, numDecimalPlaces)
        local mult = 10^(numDecimalPlaces or 0)
        return math.floor(num * mult + 0.5) / mult
    end

    if (which == "d") then
        f = readAll("/sys/class/net/" .. card .. "/statistics/rx_bytes")
    else if (which == "u") then
        f = readAll("/sys/class/net/" .. card .. "/statistics/tx_bytes")
        end
    end

    local count = 0
    local stat = tonumber(f)
    while (stat > 1024) do
        stat = (stat / 1024)
        count = count + 1
    end

    result = (round(stat,2) .." "..prefix[count].."B")
    return result
end

local wireless = {}
local function worker(args)
    local args = args or {}

    widgets_table = {}
    local connected = false

    -- Settings
    local ICON_DIR      = awful.util.getdir("config").."/"..module_path.."/net_widgets/icons/"
    local interface     = args.interface or "wlan0"
    local timeout       = args.timeout or 5
    local font          = args.font or beautiful.font
    local popup_signal  = args.popup_signal or false
    local popup_position = args.popup_position or naughty.config.defaults.position
    local onclick       = args.onclick
    local widget        = args.widget == nil and wibox.layout.fixed.horizontal() or args.widget == false and nil or args.widget
    local indent        = args.indent or 3
    local popup_metrics	= args.popup_metrics or false

    local net_icon = wibox.widget.imagebox(draw_signal(0))
    local net_text = wibox.widget.textbox()
    net_text.font = font
    net_text:set_text(" N/A ")
    local signal_level = 0
    local function net_update()
        awful.spawn.easy_async("awk 'NR==3 {printf \"%3.0f\" ,($3/70)*100}' /proc/net/wireless", function(stdout, stderr, reason, exit_code)
          signal_level = tonumber( stdout )
        end)
        if signal_level == nil then
            connected = false
            net_text:set_text(" N/A ")
            net_icon:set_image(draw_signal(0))
        else
            connected = true
            net_text:set_text(string.format("%"..indent.."d%%", signal_level))
            net_icon:set_image(draw_signal(signal_level))
        end
    end

    net_update()
    local timer = gears.timer.start_new( timeout, function () net_update()
      return true end )

    widgets_table["imagebox"]	= net_icon
    widgets_table["textbox"]	= net_text
    if widget then
            widget:add(net_icon)
            -- Hide the text when we want to popup the signal instead
            if not popup_signal then
                    widget:add(net_text)
            end
            wireless:attach(widget,{onclick = onclick})
    end



    local function text_grabber()
        local msg = ""
        if connected then
            local mac     = "N/A"
            local essid   = "N/A"
            local bitrate = "N/A"
            local inet    = "N/A"

            -- Use iw/ip
            f = io.popen("iw dev "..interface.." link")
            for line in f:lines() do
                -- Connected to 00:01:8e:11:45:ac (on wlp1s0)
                mac     = string.match(line, "Connected to ([0-f:]+)") or mac
                -- SSID: 00018E1145AC
                essid   = string.match(line, "SSID: (.+)") or essid
                -- tx bitrate: 36.0 MBit/s
                bitrate = string.match(line, "tx bitrate: (.+/s)") or bitrate
            end
            f:close()

            f = io.popen("ip addr show "..interface)
            for line in f:lines() do
                inet    = string.match(line, "inet (%d+%.%d+%.%d+%.%d+)") or inet
            end
            f:close()

            signal = ""
            if popup_signal then
                signal = "├Strength\t"..signal_level.."\n"
            end

            metrics_down = ""
            metrics_up = ""
            if popup_metrics then
                local tdown    = net_stats(interface,"d")
                local tup    = net_stats(interface,"u")
                metrics_down = "├DOWN:\t\t"..tdown.."\n"
                metrics_up = "├UP:\t\t"..tup.."\n"
            end

            msg =
                "<span font_desc=\""..font.."\">"..
                "┌["..interface.."]\n"..
                "├ESSID:\t\t"..essid.."\n"..
                "├IP:\t\t"..inet.."\n"..
                "├BSSID\t\t"..mac.."\n"..
                ""..metrics_down..
                ""..metrics_up..
                ""..signal..
                "└Bit rate:\t"..bitrate.."</span>"


        else
            msg = "Wireless network is disconnected"
        end

        return msg
    end

    local notification = nil
    function wireless:hide()
            if notification ~= nil then
                    naughty.destroy(notification)
                    notification = nil
            end
    end

    function wireless:show(t_out)
            wireless:hide()

            notification = naughty.notify({
                    preset = fs_notification_preset,
                    text = text_grabber(),
                    timeout = t_out,
            screen = mouse.screen,
            position = popup_position
            })
    end
    return widget or widgets_table
end

function wireless:attach(widget, args)
    local args = args or {}
    local onclick = args.onclick
    -- Bind onclick event function
    if onclick then
            widget:buttons(awful.util.table.join(
            awful.button({}, 1, function() awful.util.spawn(onclick) end)
            ))
    end
    widget:connect_signal('mouse::enter', function () wireless:show(0) end)
    widget:connect_signal('mouse::leave', function () wireless:hide() end)
    return widget
end

return setmetatable(wireless, {__call = function(_,...) return worker(...) end})
