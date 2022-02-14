local module_path = (...):match ("(.+/)[^/]+$") or ""

package.loaded.net_widgets = nil

local net_widgets = {
    indicator   = require("widget.net_widgets.indicator"),
    wireless    = require("widget.net_widgets.wireless"),
    internet    = require("widget.net_widgets.internet")
}

return net_widgets
