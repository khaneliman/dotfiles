local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')
local icons = require('theme.icons')
local dpi = beautiful.xresources.apply_dpi
local clickable_container = require('widget.clickable-container')
local task_list = require('widget.task-list')

local top_panel = function(s, offset)

	local offsetx = 0
	if offset == true then
		offsetx = dpi(45)
	end

	local panel = wibox
	{
		ontop = true,
		screen = s,
		type = 'dock',
		height = dpi(28),
		width = s.geometry.width - offsetx,
		x = s.geometry.x + offsetx,
		y = s.geometry.y,
		stretch = false,
		bg = beautiful.background,
		fg = beautiful.fg_normal
	}

	panel:struts
	{
		top = dpi(28)
	}

	panel:connect_signal(
		'mouse::enter',
		function() 
			local w = mouse.current_wibox
			if w then
				w.cursor = 'left_ptr'
			end
		end
	)

	s.systray = wibox.widget {
		visible = false,
		base_size = dpi(20),
		horizontal = true,
		screen = 'primary',
		widget = wibox.widget.systray
	}

	local clock 			= require('widget.clock')(s)
	local layout_box 		= require('widget.layoutbox')(s)
	local add_button 		= require('widget.open-default-app')(s)
	s.tray_toggler  		= require('widget.tray-toggle')
	s.updater 				= require('widget.package-updater')()
	s.screen_rec 			= require('widget.screen-recorder')()
	s.mpd       			= require('widget.mpd')()
	s.bluetooth   			= require('widget.bluetooth')()
	-- s.battery     			= require('widget.battery')()
	s.network       		= require('widget.network')()
	s.info_center_toggle	= require('widget.info-center-toggle')()
	local cpu_widget 		= require("awesome-wm-widgets.cpu-widget.cpu-widget")
	local ram_widget 		= require("awesome-wm-widgets.ram-widget.ram-widget")
	local volume_widget 	= require('awesome-wm-widgets.volume-widget.volume')
	local weather_widget 	= require("awesome-wm-widgets.weather-widget.weather")
	local logout_menu_widget = require("awesome-wm-widgets.logout-menu-widget.logout-menu")


	panel : setup {
		layout = wibox.layout.align.horizontal,
		expand = 'none',
		{
			layout = wibox.layout.fixed.horizontal,
			task_list(s),
			add_button
		}, 
		{
			layout = wibox.layout.fixed.horizontal,
			clock,
			weather_widget({
				api_key='4184bc59dc96244b65463149c3a9d4c4',
				coordinates = {44.1858, -88.4626},
				time_format_12h = true,
				units = 'imperial',
				both_units_widget = true,
				font_name = 'Carter One',
				icons = 'VitalyGorbachev',
				icons_extension = '.svg',
				show_hourly_forecast = true,
				show_daily_forecast = true,
			}),
		},
		{
			layout = wibox.layout.fixed.horizontal,
			spacing = dpi(5),
			{
				s.systray,
				margins = dpi(5),
				widget = wibox.container.margin
			},
			s.tray_toggler,
			cpu_widget,
			ram_widget,
			s.updater,
			s.screen_rec,
			s.mpd,
			volume_widget,
			s.network,
			s.bluetooth,
			-- logout_menu_widget, -- not working yet
			-- s.battery,
			layout_box,
			s.info_center_toggle,
		}
	}

	return panel
end


return top_panel
