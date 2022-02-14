-- vim: sw=2:sts=2:et:
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")
local module_path = (...):match ("(.+/)[^/]+$") or ""

local theme = beautiful.get()

local indicator = {}
local function worker(args)
  local args = args or {}
  local widget = wibox.container.background()
  local wired = wibox.widget.imagebox()
  local vpn = wibox.widget.imagebox()
  local wired_na = wibox.widget.imagebox()
  -- Settings
  local interfaces = args.interfaces
  local ignore_interfaces = args.ignore_interfaces or {}
  local ICON_DIR = awful.util.getdir("config").."/"..module_path.."/net_widgets/icons/"
  local timeout = args.timeout or 10
  local font = args.font or beautiful.font
  local onclick = args.onclick
  local hidedisconnected = args.hidedisconnected
  local popup_position = args.popup_position or naughty.config.defaults.position

  -- Turn off advanced details by default
  if args.skiproutes == nil then
    args.skiproutes = true
  end
  if args.skipcmdline == nil then
    args.skipcmdline = true
  end
  if args.skipvpncheck == nil or args.skiproutes or args.skipcmdline then
    args.skipvpncheck = true
  end

  local real_interfaces = nil
  -----------------------
  -- This function fetches the latest info about a given interface
  -- It makes use of `io.popen` so we only run it asynchronously
  -- It updates the global variable `real_interfaces`
  -- It only processes the interfaces listed in the `interfaces` argument
  -- If that argument is blank it will process all interfaces
  -----------------------
  local function get_interfaces()
    ----
    -- First, get the `links` table of all link data for relevant interfaces
    ----
    local links = {}
    -- All on one line:
    -- 2: enp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel
    --    state UP mode DEFAULT group default qlen 1000\ link/ether
    --    1c:6f:65:3f:48:9a brd ff:ff:ff:ff:ff:ff
    -- 32: br-39d5fbb21742: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc
    --    noqueue state DOWN mode DEFAULT group default \    link/ether
    --    02:42:68:08:88:34 brd ff:ff:ff:ff:ff:ff
    local ipl_pattern = "^%d+:%s+([^%s]+):%s+<.*>%s.*%s" ..
        "state%s+([^%s]+)%s.*%slink/([^%s]+)[%s]*([%x:]*)"
    local f = io.popen("ip -oneline link show")
    for line in f:lines() do
      local iface, state, type_, mac = string.match(line, ipl_pattern)
      if not iface then
        notification = naughty.notify({
          preset = fs_notification_preset,
          text = "LINE: \n" .. line,
          timeout = t_out,
          screen = mouse.screen,
          position = popup_position
        })
        goto continue_iplink
      end

      for _, i in pairs(ignore_interfaces) do
        if (i == iface) then
          goto continue_iplink  -- ignore this interface
        end
      end
      if interfaces then
        for _, i in pairs(interfaces) do
          if (i == iface) then
            goto donotignore_iplink  -- do not ignore this link
          end
        end
        goto continue_iplink  -- ignore this link
      end
      ::donotignore_iplink::  -- IS in the list of interfaces to process

      links[iface] = {iface = iface, state = state, type_ = type_, mac = mac}
      ::continue_iplink::  -- is NOT in the list of interfaces to process
    end
    f:close()

    ----
    -- Next, get the `ifaces` to be a sequence of tables with data about each
    -- relevant interface
    ----
    -- TODO document all the fields in each `links[iface]` table
    local ifaces = {}

    -- Grab address information
    -- All on one line:
    -- 2: enp3s0    inet 192.168.1.190/24 brd 192.168.1.255 scope global \
    --    link/ether 1c:6f:65:3f:48:9a brd ff:ff:ff:ff:ff:ff
    local ipa_pattern = "^%d+:%s+([^%s]+)%s+([^%s]+)%s+([^%s]+)"
    local f = io.popen("ip -oneline addr show")
    for line in f:lines() do
      local iface, type_, addr = string.match(line, ipa_pattern)
      if not links[iface] then
        goto continue_ipaddr  -- is NOT in the list of interfaces to process
      end
      if not links[iface].addrs then
        -- First addr for this iface
        links[iface].addrs = {}
        table.insert(ifaces, links[iface])
      end
      table.insert(links[iface].addrs, {addr = addr, type_ = type_})
      ::continue_ipaddr::  -- is NOT in the list of interfaces to process
    end
    f:close()

    -- Grab route information
    if (not args.skiproutes) then
      local f = io.popen("ip -oneline route show")
      for line in f:lines() do
        -- 10.11.0.0/24 dev tun2 proto kernel scope link src 10.11.0.3
        local rt, iface = string.match(line, "^([^%s]+)%s+dev%s+([^%s]+)")
        if rt then
          if not links[iface] then
            goto continue_iprts  -- is NOT in the list of interfaces to process
          end
          if not links[iface].localrts then  -- First route for this iface
            links[iface].localrts = {}
          end
          if string.match(line, " proto ") then
            proto = string.match(line, " proto ([^%s]+) ")
            if not (proto == "kernel") then  -- e.g., " proto dhcp "
              rt = rt .. " [" .. proto .. "]"
            end
          end
          table.insert(links[iface].localrts, rt)
        else
          -- 192.168.123.0/24 via 10.10.0.1 dev tun2
          rtpattern = "^([^%s]+%s+via%s+[^%s]+)%s+dev%s+([^%s]+)"
          rt, iface = string.match(line, rtpattern)
          if rt then
            if not links[iface] then
              goto continue_iprts  -- is NOT in the list of ifaces to process
            end
            if not links[iface].rts then  -- First route for this iface
              links[iface].rts = {}
              links[iface].coverage = {}
            end
            if string.match(line, " proto ") then
              proto = string.match(line, " proto ([^%s]+) ")
              if not (proto == "kernel") then  -- e.g., " proto dhcp "
                rt = rt .. " [" .. proto .. "]"
              end
            end
            table.insert(links[iface].rts, rt)
            if rt:match("^default") then
              rt = "0.0.0.0/0"
              --links[iface].default_route = true
            end
            local pattern = "^(%d+)%.(%d+)%.(%d+)%.(%d+)/(%d+)"
            local o1, o2, o3, o4, n = rt:match(pattern)
            if o1 and o2 and o3 and o4 and n then
              o1, o2, o3, o4, n = o1+0, o2+0, o3+0, o4+0, n+0
              if o1<256 and o2<256 and o3<256 and o4<256 and n<33 then
                local ipdec = 2^24*o1 + 2^16*o2 + 2^8*o3 + o4
                table.insert(links[iface].coverage, {ipdec, ipdec+2^(32-n)-1})
              end
            end
          else
            -- Regexps should catch every line!
            notification = naughty.notify({
              preset = fs_notification_preset,
              text = "Route pattern failure:\n" .. line,
              timeout = 300,
              screen = mouse.screen,
              position = popup_position
            })
          end
        end
        ::continue_iprts::  -- is NOT in the list of interfaces to process
      end  -- for line in ip route
      f:close()

      -- TODO allow gaps in bogon space; check IPv6 coverage
      -- Label any iface with full route coverage as default_route
      for iface, s in pairs(links) do
        if s.coverage then
          s.default_route = true  -- iface is a default route, unless...
          table.sort(s.coverage, function (a, b) return a[1] < b[1] end)
          if s.coverage[1][1] > 0.0 then
            s.default_route = false  -- ...coverage starts at > 0...
          else
            local biggest = s.coverage[1][2]
            for i = 2, #s.coverage do
              if ((biggest+1) < s.coverage[i][1]) then
                s.default_route = false  -- ...or there's a gap...
                break
              end
              if s.coverage[i][2] > biggest then
                biggest = s.coverage[i][2]
              end
            end
            if biggest < ((2.0^32) - 1.0) then
              s.default_route = false  -- ...or coverage ends at < 2^32
            end
          end
        end
      end
    end  -- Grab route information

    -- Grab process information (e.g., for tun/tap devices)
    if (not args.skipcmdline) then
      local cmd = "sudo find /proc -name task -prune -o "
      cmd = cmd .. "-path /proc/\\*/fdinfo/\\* -print0 "
      cmd = cmd .. "| xargs -0 sudo grep '^iff:'"
      --cmd = cmd .. "| sed 's/^\\(.proc.*\\/\\)fdinfo.*/\\1cmdline/'"
      --cmd = cmd .. "| xargs grep -va asdfasdfasdf "
      --cmd = cmd .. "| sed 's/\\x00/ /g'"
      --cmd = cmd .. "\""
      local f = io.popen(cmd)
      for line in f:lines() do
        -- /proc/2993045/fdinfo/4:iff:     tun0
        iff_pattern = "^/proc/(%d+)/fdinfo/%d+:iff:%s+([^%s]+)"
        local pid, iface = string.match(line, iff_pattern)
        local ff = io.open("/proc/" .. pid .. "/cmdline", "rb")
        local c = ff:read("a")
        ff:close()
        c = string.gsub(c, "\x00", " ")
        if not links[iface].cmdlines then
          links[iface].cmdlines = {}
        end
        table.insert(links[iface].cmdlines, c)
      end
      f:close()
    end  -- Grab process list

    -- TODO add checks for more vpn types, e.g., l2tp/ipsec, pptp, etc
    -- Auto-detect VPN interfaces
    if (not args.skipvpncheck) then
      local f = io.popen("sudo wg")
      for line in f:lines() do
        local iface = line:match("^interface: ([^%s]+)")
        if iface and links[iface] then
          links[iface].is_wireguard = true
          links[iface].is_vpn = true
          links[iface].is_drvpn = links[iface].default_route
        end
      end
      for iface, s in pairs(links) do
        if iface:match("^tun") and s.cmdlines then
          -- TUN/TAP devices are never in an "UP" state, but if there's a
          -- running process associated with it, it's probably connected
          if string.match(table.concat(s.cmdlines), "openvpn") then
            s.is_vpn = true
            s.is_openvpn = true
            s.is_drvpn = s.default_route
          elseif string.match(table.concat(s.cmdlines), "vpnc") then
            s.is_vpn = true
            s.is_vpnc = true
            s.is_drvpn = s.default_route
          end
        end
      end
    end

    for _, s in ipairs(links) do
      table.insert(ifaces, s)
    end
    return ifaces
  end  -- function get_interfaces()

  local function text_grabber()
    if not real_interfaces then
      return "Interface data not loaded"
    end
    local msg = ""
    for _, s in pairs(real_interfaces) do
      msg = msg .. "\n<span font_desc=\"" .. font .. "\">"
      msg = msg .. "┌[" .. s.iface .. "]"
      if s.is_vpn then
        if s.is_drvpn then
          msg = msg .. " - Full VPN"
        else
          msg = msg .. " - Partial VPN"
        end
        if s.is_openvpn then
          msg = msg .. " - (OpenVPN)"
        elseif s.is_vpnc then
          msg = msg .. " - (Cisco3000/vpnc)"
        elseif s.is_wireguard then
          msg = msg .. " - (WireGuard)"
        end
      elseif s.state then  -- not a VPN but we have state
        msg = msg .. " - state is " .. s.state
      end
      msg = msg .. "\n"

      -- Show process information
      if not args.skipcmdline then
        if  s.cmdlines then
          for _, c in pairs(s.cmdlines) do
            msg = msg .. "├CMD:\t" .. c .. "\n"
          end
        end
      end

      -- Show IP and MAC addresses
      for a = 1, #s.addrs - 1 do
        msg = msg .. "├ADDR:\t" .. s.addrs[a].addr ..
              " (" .. s.addrs[a].type_ .. ")\n"
      end
      if (args.skiproutes) then
        msg = msg .. "└ADDR:\t" .. s.addrs[#s.addrs].addr ..
              " (" .. s.addrs[#s.addrs].type_ .. ")</span>\n"
      else
        msg = msg .. "├ADDR:\t" .. s.addrs[#s.addrs].addr ..
              " (" .. s.addrs[#s.addrs].type_ .. ")\n"
      end

      -- Grab route information
      if (not args.skiproutes) then
        if s.default_route then
          msg = msg .. "├IS A DEFAULT ROUTE\n"
        end
        if s.rts then
          for _, rt in pairs(s.rts) do
            msg = msg .. "├RTE:\t" .. rt .. "\n"
          end
        end
        if (s.localrts and #s.localrts > 0) then
          for rt = 1, #s.localrts - 1 do
            msg = msg .. "├LOC:\t" .. s.localrts[rt] .. "\n"
          end
          msg = msg .. "└LOC:\t" .. s.localrts[#s.localrts] .. "</span>\n"
        else
          msg = msg .. "└LOC:\tNO LOCAL ROUTE</span>\n"
        end
      end
    end
    return string.gsub(string.gsub(msg, '^\n', ""), '\n$', "")
  end  -- function text_grabber()

  wired:set_image(ICON_DIR.."wired.png")
  wired_na:set_image(ICON_DIR.."wired_na.png")
  vpn:set_image(ICON_DIR.."vpn.png")
  widget:set_widget(wired_na)
  local function net_update()
    -- Refresh interface data
    real_interfaces = get_interfaces()

    -- Grab interface state, set icon
    if not hidedisconnected then
      widget:set_widget(wired_na)
    else
      widget:set_widget(nil)
    end
    for _, s in pairs(real_interfaces) do
      if (not args.skipvpncheck and s.is_drvpn) then
        widget:set_widget(vpn)
        break
      elseif (s.state == "UP") then
        widget:set_widget(wired)
      end
    end  -- for each real_interface
    return true
  end
  net_update()
  gears.timer.start_new(timeout, net_update)

  local notification = nil
  function widget:hide()
    if notification ~= nil then
      naughty.destroy(notification)
      notification = nil
    end
  end

  function widget:show(t_out)
    widget:hide()

    notification = naughty.notify({
        preset = fs_notification_preset,
        text = text_grabber(),
        timeout = t_out,
        screen = mouse.screen,
        position = popup_position
      })
  end

  -- Bind onclick event function
  if onclick then
    widget:buttons(awful.util.table.join(
        awful.button({}, 1, function() awful.util.spawn(onclick) end)
    ))
  end

  widget:connect_signal('mouse::enter', function () widget:show(0) end)
  widget:connect_signal('mouse::leave', function () widget:hide() end)
  return widget
end
return setmetatable(indicator, {__call = function(_,...) return worker(...) end})
