local awful = require('awful')
local naughty = require('naughty')
local wibox = require('wibox')
local gears = require('gears')

local watch = awful.widget.watch

local apps = require('configuration.apps')

local clickable_container = require('widget.clickable-container')
local dpi = require('beautiful').xresources.apply_dpi

local config_dir = gears.filesystem.get_configuration_dir()
local widget_icon_dir = config_dir .. 'widget/package-updater/icons/'

local update_available = false
local number_of_updates_available = nil
local update_package = nil

local return_button = function()

	local widget = wibox.widget {
		{
			id = 'icon',
			widget = wibox.widget.imagebox,
			image = widget_icon_dir .. 'package.svg',
			resize = true
		},
		layout = wibox.layout.align.horizontal
	}

	local widget_button = wibox.widget {
		{
			widget,
			margins = dpi(7),
			widget = wibox.container.margin
		},
		widget = clickable_container
	}

	widget_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					awful.spawn(apps.default.package_manager, false)
				end
			)
		)
	)

	awful.tooltip(
		{
			objects = {widget_button},
			mode = 'outside',
			align = 'right',
			margin_leftright = dpi(8),
			margin_topbottom = dpi(8),
			timer_function = function()

				if update_available then
					return update_package:gsub('\n$', '')
				else
					return 'We are up-to-date!'
				end
			
			end,
			preferred_positions = {'right', 'left', 'top', 'bottom'}
		}
	)

	watch(
		'checkupdates',
		60,
		function(_, stdout)

			-- TODO: Use checkupdates | wc -l to get the number of updates
			-- Check if there is an update available by counting lines in output
			local __, replacements = string.gsub(stdout, "\n", "\n")
			number_of_updates_available = tonumber(replacements)
			update_package = stdout

			-- Toggle icon depending on whether there is an update available
			local icon_name = nil
			if number_of_updates_available > 0 then
				update_available = true
				icon_name = 'package-up'
			else
				update_available = false
				icon_name = 'package'
				
			end

			-- Update widget icon
			widget.icon:set_image(widget_icon_dir .. icon_name .. '.svg')
			collectgarbage('collect')
		end
	)

	return widget_button
end

return return_button
