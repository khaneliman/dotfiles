local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local theme = require("beautiful")
local naughty = require("naughty")
local glib = require("lgi").GLib
local dpi = theme.xresources.apply_dpi

local module = {}

local client, screen, mouse, awesome = client, screen, mouse, awesome

local instances = {}

local function update_on_signal(c, signal, widget)
	local sig_instances = instances[signal]
	if sig_instances == nil then
		sig_instances = setmetatable({}, { __mode = "k" })
		instances[signal] = sig_instances
		client.connect_signal(signal, function(cl)
			local widgets = sig_instances[cl]
			if widgets then
				for _, w in pairs(widgets) do
					w.update()
				end
			end
		end)
	end
	local widgets = sig_instances[c]
	if widgets == nil then
		widgets = setmetatable({}, { __mode = "v" })
		sig_instances[c] = widgets
	end
	table.insert(widgets, widget)
end

local glib_context = function(fn)
	return function(args)
		glib.idle_add(glib.PRIORITY_DEFAULT_IDLE, function()
			fn(args)
		end)
	end
end

local function ori(pos)
	if pos == "left" or pos == "right" then
		return "v"
	end
	return "h"
end

local function list2map(list)
	local set = {}
	for _, l in ipairs(list) do
		set[l] = true
	end
	return set
end

local function len(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

local function doubleclicked(obj)
	if obj.doubleclick_timer then
		obj.doubleclick_timer:stop()
		obj.doubleclick_timer = nil
		return true
	end
	obj.doubleclick_timer = gears.timer.start_new(0.3, function()
		obj.doubleclick_timer = nil
	end)
	return false
end

local menu_selection_symbol
local menu_marker = function(condition)
	if condition then
		return menu_selection_symbol
	end
	return ""
end

local menu_move2tag = function(c, scr)
	local list = {}
	local s = scr or awful.screen.focused()
	local count = 0
	for _, t in pairs(s.tags) do
		if t ~= awful.screen.focused().selected_tag then
			count = count + 1
			local name = t.name or ""
			local entry = {
				t.index .. ": " .. name .. menu_marker(t.selected) .. " ",
				function()
					c:move_to_tag(t)
				end,
			}
			table.insert(list, entry)
		end
	end
	if count > 0 then
		return list
	end
	return nil
end

local menu_move2screen = function(c)
	local list = {}
	local count = 0
	for s in screen do
		local desc = next(s.outputs) or ""
		if s.index ~= awful.screen.focused().index then
			count = count + 1
			local entry = { s.index .. ": " .. desc .. " ", menu_move2tag(c, s) }
			table.insert(list, entry)
		end
	end
	if count > 1 then
		return list
	end
	return nil
end

function module.menu_client(custom_menu, c)
	local list = {}

	local list_tags = menu_move2tag(c)
	if list_tags then
		table.insert(list, { "move to tag", list_tags })
	end

	local list_screens = menu_move2screen(c)
	if list_screens then
		table.insert(list, { "move to screen", list_screens })
	end

	table.insert(list, {
		"fullscreen" .. menu_marker(c.fullscreen),
		function()
			c.fullscreen = not c.fullscreen
			c:raise()
		end,
	})

	table.insert(list, {
		"maximize" .. menu_marker(c.maximized),
		function()
			c.maximized = not c.maximized
			c:raise()
		end,
	})

	table.insert(list, {
		"master" .. menu_marker(c == awful.client.getmaster()),
		function()
			c:swap(awful.client.getmaster())
		end,
	})

	table.insert(list, {
		"sticky" .. menu_marker(c.sticky),
		function()
			c.sticky = not c.sticky
		end,
	})

	table.insert(list, {
		"top" .. menu_marker(c.ontop),
		function()
			c.ontop = not c.ontop
		end,
	})

	table.insert(list, {
		"minimize" .. menu_marker(c.minimized),
		function()
			if c.minimized then
				c.minimized = false
				c:raise()
			else
				c.minimized = true
			end
		end,
	})

	table.insert(list, {
		"floating" .. menu_marker(c.floating),
		function()
			c.floating = not c.floating
		end,
	})

	table.insert(list, {
		menu_marker(nil) .. "close",
		function()
			c:kill()
		end,
	})

	if custom_menu and len(custom_menu) > 0 then
		local function generate_menu_entry(e)
			if e and type(e) == "table" and e.text then
				local text = ""
				if type(e.text) == "string" then
					text = e.text
				end
				if type(e.text) == "function" then
					text = e.text(c)
				end
				return {
					text,
					function()
						if e.func then
							e.func(c)
						end
					end,
				}
			end
		end

		local class = c.class or ""
		for regex, entries in pairs(custom_menu) do
			if string.find(class, regex) then
				for _, e in ipairs(entries) do
					local menu_entry = generate_menu_entry(e)
					if menu_entry then
						table.insert(list, menu_entry)
					end
				end
			end
		end
	end

	return list
end

local rounded_corner_shape = function(radius, position)
	if position == "bottom" then
		return function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, false, false, true, true, radius)
		end
	elseif position == "top" then
		return function(cr, width, height)
			gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, radius)
		end
	end
	return nil
end

local add_hot_corner = function(args)
	args = args or {}
	local position = args.position or ""
	local placement = awful.placement[position]
	if not placement then
		return
	end
	local actions = args.buttons or {}
	local s = args.screen or awful.screen.focused()
	local width = args.width
	local height = args.height
	local color = args.color

	local corner = awful.popup({
		screen = s,
		placement = placement,
		ontop = true,
		border_width = 0,
		minimum_height = height,
		maximum_height = height,
		minimum_width = width,
		maximum_width = width,
		bg = color,
		widget = wibox.container.background,
	})

	-- this will run for every screen, so we have to make sure to only add one signal handler for every assigned signal
	local must_connect_signal = (s.index == 1)

	local function signal_name(pos, action)
		return "hot_corners::" .. pos .. "::" .. action
	end

	local defs = {
		{ name = "left_click", button = 1 },
		{ name = "middle_click", button = 2 },
		{ name = "right_click", button = 3 },
		{ name = "wheel_up", button = 4 },
		{ name = "wheel_down", button = 5 },
		{ name = "back_click", button = 8 },
		{ name = "forward_click", button = 9 },
	}

	local buttons = {}
	for _, btn in ipairs(defs) do
		if actions[btn.name] then
			local signal = signal_name(position, btn.name)
			table.insert(
				buttons,
				awful.button({}, btn.button, function()
					awesome.emit_signal(signal)
				end)
			)
			if must_connect_signal then
				awesome.connect_signal(signal, glib_context(actions[btn.name]))
			end
		end
	end
	corner:buttons(buttons)

	for _, action in pairs({ "enter", "leave" }) do
		if actions[action] then
			local signal = signal_name(position, action)
			corner:connect_signal("mouse::" .. action, function()
				awesome.emit_signal(signal)
			end)
			if must_connect_signal then
				awesome.connect_signal(signal, glib_context(actions[action]))
			end
		end
	end
end

local function new(config)
	local cfg = config or {}
	local positions = cfg.positions or { "left", "right", "top", "bottom" }
	local button_positions = cfg.button_positions or { "top" }
	local border_width = cfg.border_width or dpi(6)
	local rounded_corner = cfg.rounded_corner or nil

	local color_normal = cfg.color_normal or "#56666f"
	local color_focus = cfg.color_focus or "#a1bfcf"
	local color_hover = cfg.color_hover or nil
	local color_floating = cfg.color_floating or nil
	local color_maximized = cfg.color_maximized or nil

	local button_size = cfg.button_size or dpi(40)
	local spacing_widget = cfg.spacing_widget or nil

	local button_maximize_size = cfg.button_maximize_size or button_size
	local button_minimize_size = cfg.button_minimize_size or button_size
	local button_floating_size = cfg.button_floating_size or button_size
	local button_top_size = cfg.button_top_size or button_size
	local button_sticky_size = cfg.button_sticky_size or button_size
	local button_close_size = cfg.button_close_size or button_size

	local color_maximize_normal = cfg.color_maximize_normal or "#a9dd9d"
	local color_maximize_focus = cfg.color_maximize_focus or "#a9dd9d"
	local color_maximize_hover = cfg.color_maximize_hover or "#c3f7b7"

	local color_minimize_normal = cfg.color_minimize_normal or "#f0eaaa"
	local color_minimize_focus = cfg.color_minimize_focus or "#f0eaaa"
	local color_minimize_hover = cfg.color_minimize_hover or "#f6ffea"

	local color_close_normal = cfg.color_close_normal or "#fd8489"
	local color_close_focus = cfg.color_close_focus or "#fd8489"
	local color_close_hover = cfg.color_close_hover or "#ff9ea3"

	local color_floating_normal = cfg.color_floating_normal or "#ddace7"
	local color_floating_focus = cfg.color_floating_focus or "#ddace7"
	local color_floating_hover = cfg.color_floating_hover or "#f7c6ff"

	local color_sticky_normal = cfg.color_sticky_normal or "#fb8965"
	local color_sticky_focus = cfg.color_sticky_focus or "#fb8965"
	local color_sticky_hover = cfg.color_sticky_hover or "#ffa37f"

	local color_top_normal = cfg.color_top_normal or "#7fc1ca"
	local color_top_focus = cfg.color_top_focus or "#7fc1ca"
	local color_top_hover = cfg.color_top_hover or "#99dbe4"

	local stealth = cfg.stealth or false

	local snapping = cfg.snapping or false
	local snapping_center_mouse = cfg.snapping_center_mouse or false
	local snapping_max_distance = cfg.snapping_max_distance or nil

	local hot_corners = cfg.hot_corners or {}
	local hot_corners_color = cfg.hot_corners_color or "#00000000"
	local hot_corners_width = cfg.hot_corners_width or dpi(1)
	local hot_corners_height = cfg.hot_corners_height or dpi(1)

	local show_button_tooltips = cfg.show_button_tooltips or false -- tooltip might intercept mouseclicks; not recommended!
	local show_title_tooltip = cfg.show_title_tooltip or false -- might fuck up sloppy mouse focus; not recommended!

	local custom_menu_entries = cfg.custom_menu_entries or {}
	menu_selection_symbol = cfg.menu_selection_symbol or " ✔"

	local layout = cfg.layout or "fixed" -- "fixed" | "ratio"
	local button_ratio = cfg.button_ratio or 0.2

	local align_horizontal = cfg.align_horizontal or "right" -- "left" | "center" | "right"
	local align_vertical = cfg.align_vertical or "center" -- "top" | "center" | "bottom"
	local buttons = cfg.buttons or { "floating", "minimize", "maximize", "close" }

	local button_left_click = cfg.button_left_click
		or function(c)
			if c.maximized then
				c.maximized = false
			end
			c:emit_signal("request::activate", "mouse_click", { raise = true })
			awful.mouse.client.move(c)
		end
	local button_double_click = cfg.button_double_click or function(c)
		c.maximized = not c.maximized
	end
	local button_middle_click = cfg.middle_click
		or function(c)
			c:emit_signal("request::activate", "mouse_click", { raise = true })
			awful.mouse.client.resize(c)
		end
	local button_right_click = cfg.right_click
		or function(c)
			if c.client_menu then
				c.client_menu:hide()
			end
			c.client_menu = awful.menu(module.menu_client(custom_menu_entries, c))
			c.client_menu:toggle()
		end

	local resize_factor = cfg.resize_factor or 0.01
	local button_wheel_up = cfg.button_wheel_up or function(_)
		awful.client.incwfact(resize_factor)
	end
	local button_wheel_down = cfg.button_wheel_down or function(_)
		awful.client.incwfact(-1 * resize_factor)
	end
	local button_back = cfg.button_back or function(_)
		awful.client.swap.byidx(-1)
	end
	local button_forward = cfg.button_forward or function(_)
		awful.client.swap.byidx(1)
	end

	local button_funcs = {}

	local left_click_function = function(c)
		if doubleclicked(c) then
			button_double_click(c)
		else
			button_left_click(c)
		end
	end

	client.connect_signal("smart_borders::left_click", left_click_function)
	client.connect_signal("smart_borders::middle_click", button_middle_click)
	client.connect_signal("smart_borders::right_click", button_right_click)
	client.connect_signal("smart_borders::wheel_up", button_wheel_up)
	client.connect_signal("smart_borders::wheel_down", button_wheel_down)
	client.connect_signal("smart_borders::back_click", button_back)
	client.connect_signal("smart_borders::forward_click", button_forward)

	button_funcs[1] = function(c)
		c:emit_signal("smart_borders::left_click")
	end

	button_funcs[2] = function(c)
		c:emit_signal("smart_borders::middle_click")
	end
	button_funcs[3] = function(c)
		c:emit_signal("smart_borders::right_click")
	end
	button_funcs[4] = function(c)
		c:emit_signal("smart_borders::wheel_up")
	end
	button_funcs[5] = function(c)
		c:emit_signal("smart_borders::wheel_down")
	end
	button_funcs[8] = function(c)
		c:emit_signal("smart_borders::back_click")
	end
	button_funcs[9] = function(c)
		c:emit_signal("smart_borders::forward_click")
	end
	local function handle_button_press(c, button)
		local func = button_funcs[button]
		if func then
			func(c)
		end
	end

	local button_definitions = {}
	button_definitions["maximize"] = {
		name = "maximize",
		color_normal = color_maximize_normal,
		color_focus = color_maximize_focus,
		color_hover = color_maximize_hover,
		button_size = button_maximize_size,
		action = function(cl)
			cl.maximized = not cl.maximized
		end,
	}

	button_definitions["minimize"] = {
		name = "minimize",
		color_normal = color_minimize_normal,
		color_focus = color_minimize_focus,
		color_hover = color_minimize_hover,
		button_size = button_minimize_size,
		action = function(cl)
			-- for whatever reason setting minimized does not work without wrapping it.
			awful.spawn.easy_async_with_shell("sleep 0", function()
				cl.minimized = true
			end)
		end,
	}

	button_definitions["floating"] = {
		name = "floating",
		color_normal = color_floating_normal,
		color_focus = color_floating_focus,
		color_hover = color_floating_hover,
		button_size = button_floating_size,
		action = function(cl)
			cl.floating = not cl.floating
		end,
	}

	button_definitions["close"] = {
		name = "close",
		color_normal = color_close_normal,
		color_focus = color_close_focus,
		color_hover = color_close_hover,
		button_size = button_close_size,
		action = function(cl)
			cl:kill()
		end,
	}

	button_definitions["sticky"] = {
		name = "sticky",
		color_normal = color_sticky_normal,
		color_focus = color_sticky_focus,
		color_hover = color_sticky_hover,
		button_size = button_sticky_size,
		action = function(cl)
			cl.sticky = not cl.sticky
		end,
	}

	button_definitions["top"] = {
		name = "top",
		color_normal = color_top_normal,
		color_focus = color_top_focus,
		color_hover = color_top_hover,
		button_size = button_top_size,
		action = function(cl)
			cl.ontop = not cl.ontop
		end,
	}

	for s in screen do
		for pos, btns in pairs(hot_corners) do
			add_hot_corner({
				buttons = btns,
				screen = s,
				position = pos,
				color = hot_corners_color,
				width = hot_corners_width,
				height = hot_corners_height,
			})
		end
	end

	if layout ~= "fixed" and layout ~= "ratio" then
		layout = "fixed"
	end

	if type(button_positions) == "string" then
		button_positions = { button_positions }
	end

	if snapping then
		if awful and awful.mouse and awful.mouse.append_global_mousebindings then
			local mouse_closest_client = function()
				local s = awful.screen.focused()
				local m_x = mouse.coords().x
				local m_y = mouse.coords().y

				local closest_distance, closest_c

				for _, c in ipairs(s.all_clients) do
					if c:isvisible() then
						local x = c.x + (c.width / 2)
						local y = c.y + (c.height / 2)
						local dx = math.max(math.abs(m_x - x) - (c.width / 2), 0)
						local dy = math.max(math.abs(m_y - y) - (c.height / 2), 0)
						local distance = math.sqrt(dx * dx + dy * dy)

						if
							(not snapping_max_distance or (distance <= snapping_max_distance))
							and (not closest_distance or distance < closest_distance)
						then
							closest_distance = distance
							closest_c = c
						end
					end
				end

				if closest_c and closest_c.valid then
					closest_c:emit_signal("request::activate", "smart_borders::snapping", { raise = true })
				end

				return closest_c
			end

			awful.mouse.append_global_mousebindings({
				awful.button({}, 1, function()
					local c = mouse_closest_client()
					if c then
						if snapping_center_mouse then
							mouse.coords({ x = c.x + c.width / 2, y = c.y + c.height / 2 })
						end
						left_click_function(c)
					end
				end),
				awful.button({}, 2, function()
					local c = mouse_closest_client()
					if c then
						button_middle_click(c)
					end
				end),
				awful.button({}, 3, function()
					local c = mouse_closest_client()
					if c then
						button_right_click(c)
					end
				end),
				awful.button({}, 4, function()
					local c = mouse_closest_client()
					if c then
						button_wheel_up(c)
					end
				end),
				awful.button({}, 5, function()
					local c = mouse_closest_client()
					if c then
						button_wheel_down(c)
					end
				end),
				awful.button({}, 8, function()
					local c = mouse_closest_client()
					if c then
						button_back(c)
					end
				end),
				awful.button({}, 9, function()
					local c = mouse_closest_client()
					if c then
						button_forward(c)
					end
				end),
			})
		else
			naughty.notify({ title = "smart_borders", text = "snapping requires awesomewm git version!", timeout = 0 })
		end
	end

	local smart_border_titlebars = function(c)
		local border_bg = wibox.widget.base.make_widget_declarative({
			{ widget = wibox.container.margin },
			id = "border_bg",
			bg = color_normal,
			widget = wibox.container.background,
		})

		border_bg:connect_signal("button::press", function(_, _, _, button)
			handle_button_press(c, button)
		end)

		if color_hover then
			border_bg:connect_signal("mouse::enter", function()
				border_bg.bg = color_hover
			end)
			border_bg:connect_signal("mouse::leave", function()
				if client.focus == c then
					border_bg.bg = color_focus
				else
					border_bg.bg = color_normal
				end
			end)
		end

		local border_expander, border_expander_center

		if layout == "fixed" then
			border_expander_center = wibox.widget.base.make_widget_declarative({
				fill_vertical = true,
				fill_horizontal = true,
				content_fill_vertical = true,
				content_fill_horizontal = true,
				border_bg,
				widget = wibox.container.place,
			})
			border_expander = wibox.widget.base.make_widget_declarative({
				{ layout = wibox.layout.fixed.horizontal },
				border_bg,
				{ layout = wibox.layout.fixed.horizontal },
				widget = wibox.layout.align.horizontal,
			})
		end

		local _button_positions = list2map(button_positions)

		for _, pos in pairs(positions) do
			local tb = awful.titlebar(c, { size = border_width, position = pos, bg = "#00000000" })

			local btn_layout
			if layout == "fixed" then
				btn_layout = ori(pos) == "v" and wibox.layout.fixed.vertical or wibox.layout.fixed.horizontal
			end
			if layout == "ratio" then
				btn_layout = ori(pos) == "v" and wibox.layout.ratio.vertical or wibox.layout.ratio.horizontal
			end

			if _button_positions[pos] then
				-- border with buttons
				local button_layout = wibox.widget.base.make_widget_declarative({
					id = "button_layout",
					spacing_widget = spacing_widget,
					layout = btn_layout,
				})

				local titlebar_widget

				if layout == "fixed" then
					if ori(pos) == "v" then
						local expander = align_vertical == "center" and border_expander_center or border_expander
						titlebar_widget = wibox.widget.base.make_widget_declarative({
							align_vertical == "top" and button_layout or expander,
							align_vertical == "center" and button_layout or expander,
							align_vertical == "bottom" and button_layout or expander,
							expand = align_vertical == "center" and "none" or "inside",
							layout = wibox.layout.align.vertical,
						})
					else
						local expander = align_horizontal == "center" and border_expander_center or border_expander
						titlebar_widget = wibox.widget.base.make_widget_declarative({
							align_horizontal == "left" and button_layout or expander,
							align_horizontal == "center" and button_layout or expander,
							align_horizontal == "right" and button_layout or expander,
							expand = align_horizontal == "center" and "none" or "inside",
							layout = wibox.layout.align.horizontal,
						})
					end
				end

				if layout == "ratio" then
					titlebar_widget = wibox.widget.base.make_widget_declarative({
						button_layout,
						id = "titlebar_widget",
						bg = color_normal,
						widget = wibox.container.background,
					})
				end

				tb:setup({
					titlebar_widget,
					bg = "#00000000",
					shape = rounded_corner and rounded_corner_shape(rounded_corner, pos) or nil,
					widget = wibox.container.background(),
				})

				local ratio_button_layout = wibox.widget.base.make_widget_declarative({
					homogeneous = layout == "ratio" and true or false,
					expand = true,
					layout = ori(pos) == "h" and wibox.layout.grid.horizontal or wibox.layout.grid.vertical,
				})

				local list_of_buttons = {}
				for _, btn in pairs(buttons) do
					local b = button_definitions[btn]

					if not b then
						-- custom button
						b = {}
						b.name = cfg["button_" .. btn .. "_name"] or btn
						b.button_size = cfg["button_" .. btn .. "_size"] or button_size
						b.color_focus = cfg["color_" .. btn .. "_focus"] or "#ff00ff"
						b.color_normal = cfg["color_" .. btn .. "_normal"] or "#ff00ff"
						b.color_hover = cfg["color_" .. btn .. "_hover"] or "#ff1aff"
						b.action = cfg["button_" .. btn .. "_function"] or nil
					end

					local button_widget = wibox.widget.base.make_widget_declarative({
						{ widget = wibox.container.margin },
						id = b.name,
						forced_width = ori(pos) == "h" and b.button_size or nil,
						forced_height = ori(pos) == "v" and b.button_size or nil,
						bg = b.color_normal,
						widget = wibox.container.background,
					})

					if show_button_tooltips then
						awful.tooltip({
							objects = { button_widget },
							align = "top_left",
							timer_function = function()
								return b.name
							end,
						})
					end

					button_widget:connect_signal("mouse::enter", function()
						button_widget.bg = b.color_hover
					end)

					button_widget:connect_signal("mouse::leave", function()
						if stealth then
							if c == client.focus then
								button_widget.bg = color_focus
							else
								button_widget.bg = color_normal
							end
						else
							if c == client.focus then
								button_widget.bg = b.color_focus
							else
								button_widget.bg = b.color_normal
							end
						end
					end)

					button_widget:connect_signal("button::press", function(_, _, _, button)
						if button == 1 then
							if b.action then
								b.action(c)
							end
						else
							handle_button_press(c, button)
						end
					end)

					table.insert(list_of_buttons, button_widget)

					local update = function()
						if client.focus == c then
							button_widget.bg = stealth and color_focus or b.color_focus
							return
						end
						button_widget.bg = stealth and color_normal or b.color_normal
					end

					button_widget.update = update

					update_on_signal(c, "focus", button_widget)
					update_on_signal(c, "unfocus", button_widget)
				end

				if layout == "ratio" then
					ratio_button_layout:set_children(list_of_buttons)
					local ratio_children = {}
					table.insert(ratio_children, border_bg)
					table.insert(ratio_children, ratio_button_layout)
					table.insert(ratio_children, border_bg)
					button_layout:set_children(ratio_children)

					if
						(ori(pos) == "h" and align_horizontal == "left")
						or (ori(pos) == "v" and align_vertical == "top")
					then
						button_layout:ajust_ratio(2, 0, button_ratio, 1.0 - button_ratio)
					end
					if
						(ori(pos) == "h" and align_horizontal == "right")
						or (ori(pos) == "v" and align_vertical == "bottom")
					then
						button_layout:ajust_ratio(2, 1.0 - button_ratio, button_ratio, 0)
					end
					if
						(ori(pos) == "h" and align_horizontal == "center")
						or (ori(pos) == "v" and align_vertical == "center")
					then
						local side_ratio = (1.0 - button_ratio) / 2
						button_layout:ajust_ratio(2, side_ratio, button_ratio, side_ratio)
					end
				end

				if layout == "fixed" then
					button_layout:set_children(list_of_buttons)
				end
			else
				tb:setup({
					border_bg,
					bg = "#00000000",
					shape = rounded_corner and rounded_corner_shape(rounded_corner, pos) or nil,
					widget = wibox.container.background,
				})
			end
		end

		-- show client title tooltip on border hover
		if show_title_tooltip then
			awful.tooltip({
				objects = { border_bg },
				timer_function = function()
					return c.name
				end,
			})
		end

		local update_border = function()
			if client.focus == c then
				border_bg.bg = color_focus
				return
			end

			if color_maximized and c.maximized then
				border_bg.bg = color_maximized
				return
			end

			if color_floating and c.floating then
				border_bg.bg = color_floating
				return
			end

			border_bg.bg = color_normal
		end

		border_bg.update = update_border

		update_on_signal(c, "focus", border_bg)
		update_on_signal(c, "unfocus", border_bg)
		update_on_signal(c, "property::maximized", border_bg)
		update_on_signal(c, "property::floating", border_bg)
	end

	client.connect_signal("request::tag", smart_border_titlebars)
	client.connect_signal("property::disable_smart_borders", function(c)
		for _, pos in pairs(positions) do
			if c.disable_smart_borders then
				awful.titlebar.hide(c, pos)
			else
				awful.titlebar.show(c, pos)
			end
		end
	end)
end

return setmetatable(module, {
	__call = function(_, ...)
		new(...)
		return module
	end,
})
