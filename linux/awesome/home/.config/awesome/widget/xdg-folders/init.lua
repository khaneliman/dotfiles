local awful = require('awful')
local wibox = require('wibox')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi
local home = require('widget.xdg-folders.home')
local documents = require('widget.xdg-folders.documents')
local downloads = require('widget.xdg-folders.downloads')
local pictures = require('widget.xdg-folders.pictures')
local videos = require('widget.xdg-folders.videos')
local trash = require('widget.xdg-folders.trash')

local create_xdg_widgets = function()
	local separator =  wibox.widget {
		orientation = 'horizontal',
		forced_height = dpi(1),
		forced_width = dpi(1),
		span_ratio = 0.55,
		widget = wibox.widget.separator
	}

	return wibox.widget {
		layout = wibox.layout.align.vertical,
	  	{
			separator,
			home(),
			documents(),
			downloads(),
			pictures(),
			videos(),
			separator,
			trash(),
			layout = wibox.layout.fixed.vertical,
	  	},
	}
end

return create_xdg_widgets
