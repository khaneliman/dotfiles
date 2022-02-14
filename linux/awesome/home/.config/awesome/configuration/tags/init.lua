local awful = require('awful')
local gears = require('gears')
local beautiful = require('beautiful')
local icons = require('theme.icons')
local apps = require('configuration.apps')
local bling = require("bling")
local naughty = require("naughty")
local wibox = require("wibox")

local tags = {
	{
		type = 'terminal',
		icon = icons.terminal,
		default_app = apps.default.terminal,
		gap = beautiful.useless_gap
	},
	{
		type = 'internet',
		icon = icons.web_browser,
		default_app = apps.default.web_browser,
		gap = beautiful.useless_gap
	},
	{
		type = 'code',
		icon = icons.text_editor,
		default_app = apps.default.text_editor,
		gap = beautiful.useless_gap
	},
	{
		type = 'files',
		icon = icons.file_manager,
		default_app = apps.default.file_manager,
		gap = beautiful.useless_gap,
		layout = awful.layout.suit.tile
	},
	{
		type = 'multimedia',
		icon = icons.multimedia,
		default_app = apps.default.multimedia,
		gap = beautiful.useless_gap,
		layout = awful.layout.suit.max,
		gap = 0
	},
	{
		type = 'games',
		icon = icons.games,
		default_app = apps.default.game,
		gap = beautiful.useless_gap,
		layout = awful.layout.suit.max
	},
	{
		type = 'graphics',
		icon = icons.graphics,
		default_app = apps.default.graphics,
		gap = beautiful.useless_gap
	},
	{
		type = 'sandbox',
		icon = icons.sandbox,
		default_app = apps.default.sandbox,
		layout = awful.layout.suit.tile,
		gap = 0
	},
	{
		type = 'any',
		icon = icons.development,
		default_app = apps.default.development,
		gap = beautiful.useless_gap,
		layout = awful.layout.suit.tile
	}
	-- {
	--   type = 'social',
	--   icon = icons.social,
	--   default_app = 'discord',
	--   gap = beautiful.useless_gap
	-- }
}

-- Set tags layout
tag.connect_signal(
	'request::default_layouts',
	function()
	    awful.layout.append_default_layouts({
			awful.layout.suit.spiral.dwindle,
			awful.layout.suit.tile,
			awful.layout.suit.floating,
			awful.layout.suit.max
	    })
	end
)

-- Create tags for  screen
screen.connect_signal(
	'request::desktop_decoration',
	function(s)
		for i, tag in pairs(tags) do
			awful.tag.add(
				i,
				{
					icon = tag.icon,
					icon_only = true,
					layout = tag.layout or awful.layout.suit.spiral.dwindle,
					gap_single_client = true,
					gap = tag.gap,
					screen = s,
					default_app = tag.default_app,
					selected = i == 2
				}
			)
		end
	end
)

local update_gap_and_shape = function(t)
	-- Get current tag layout
	local current_layout = awful.tag.getproperty(t, 'layout')
	-- If the current layout is awful.layout.suit.max
	if (current_layout == awful.layout.suit.max) then
		-- Set clients gap to 0 and shape to rectangle if maximized
		t.gap = 0
		for _, c in ipairs(t:clients()) do
			if not c.floating or not c.round_corners or c.maximized or c.fullscreen then
				c.shape = beautiful.client_shape_rectangle
			else
				c.shape = beautiful.client_shape_rounded
			end
		end
	else
		t.gap = beautiful.useless_gap
		for _, c in ipairs(t:clients()) do
			if not c.round_corners or c.maximized or c.fullscreen then
				c.shape = beautiful.client_shape_rectangle
			else
				c.shape = beautiful.client_shape_rounded
			end
		end
	end
end

-- Focus on urgent clients
awful.tag.attached_connect_signal(
	s,
	'property::selected',
	function()
		local urgent_clients = function (c)
			return awful.rules.match(c, {urgent = true})
		end
		for c in awful.client.iterate(urgent_clients) do
			if c.first_tag == mouse.screen.selected_tag then
				c:emit_signal('request::activate')
				c:raise()
			end
		end
	end
)

-- Change tag's client's shape and gap on change
tag.connect_signal(
	'property::layout',
	function(t)
		update_gap_and_shape(t)
	end
)

-- Change tag's client's shape and gap on move to tag
tag.connect_signal(
	'tagged',
	function(t)
		update_gap_and_shape(t)
	end
)

-- TODO : HOOK UP BLING TAG PREVIEWS

-- tag.connect_signal(
-- 	'mouse::enter',
-- 	function(t)
-- 		naughty.notify({ title = "bling", text = "blingy mcbling", timeout = 0 })
-- 		-- BLING: Only show widget when there are clients in the tag
-- 		if t.clients() > 0 then
-- 			-- BLING: Update the widget with the new tag
-- 			awesome.emit_signal("bling::tag_preview::update", t)
-- 			-- BLING: Show the widget
-- 			awesome.emit_signal("bling::tag_preview::visibility", s, true)
-- 		end

-- 		if self.bg ~= '#ff0000' then
-- 			self.backup     = self.bg
-- 			self.has_backup = true
-- 		end

-- 		self.bg = '#ff0000'
-- 	end
-- )

-- tag.connect_signal(
-- 	'mouse::leave', 
-- 	function(t)
-- 		-- BLING: Turn the widget off
-- 		awesome.emit_signal("bling::tag_preview::visibility", s, false)

-- 		if self.has_backup then self.bg = self.backup end
-- 	end
-- )

bling.widget.tag_preview.enable {
    show_client_content = false,  -- Whether or not to show the client content
    x = 10,                       -- The x-coord of the popup
    y = 10,                       -- The y-coord of the popup
    scale = 0.25,                 -- The scale of the previews compared to the screen
    honor_padding = false,        -- Honor padding when creating widget size
    honor_workarea = false,       -- Honor work area when creating widget size
    placement_fn = function(c)    -- Place the widget using awful.placement (this overrides x & y)
        awful.placement.top_left(c, {
            margins = {
                top = 30,
                left = 30
            }
        })
    end,
    background_widget = wibox.widget {    -- Set a background image (like a wallpaper) for the widget 
        image = beautiful.wallpaper,
        horizontal_fit_policy = "fit",
        vertical_fit_policy   = "fit",
        widget = wibox.widget.imagebox
    }
}
