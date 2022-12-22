# Network Widgets
If you use `netctl` or another network manager which doesn't provide any good tray icon or if you want something more native than `nm-applet`, this is for you.

![network widgets total](https://dl.dropbox.com/s/i3aljidy8l6v6mh/net_widgets_total.png?dl=0)
## How to use
First of all you should clone repository in your awesome config directory
```
git clone https://github.com/pltanton/net_widgets.git ~/.config/awesome/net_widgets
```
Then, paste this in your 'rc.lua'
```Lua
local net_widgets = require("net_widgets")
```
### Wireless widget.
![wireless widget](https://dl.dropbox.com/s/737pn4mdwv7x79g/wireless_widget.png)
Widget is simple as hell. Icon changes depend on signal level, if you put mouse pointer on it you can see some information about current connection.

Create widget by (make sure you place it after `beautiful.init` otherwise the font is not yet defined)
```Lua
net_wireless = net_widgets.wireless({interface="wlp1s0"})
```
After that just place `net_wireless` wherever you want. You can also change widget update timeout. By default it is `timeout=5`, `interface=wlan0`

To display metrics about ESSID, bit rate and more, make sure that you have `iw` installed on your system.

### Wired network indicator.
![wired widget](https://dl.dropbox.com/s/5hg1bo41luelzob/wired_icon.png)
If network is disconnected icon changes color to red. You can set multiple interfaces to indicate it. If you don't set interfaces or set it to `nil`, the widget will detect interfaces every time it checks status. In any case, any interfaces inthe `ignore_interfaces` argument will not be processed. There's also a popup which shows the IP and MAC addresses, plus associated routes and processes, for each queried or supplied interface.

Note that you can show your wireless interface in here, but it won't show wireless-specific properties like signal strength or SSID. Use the wireless widget for that.

Set `skipcmdline` to false if you want to show the command line of any process associated with the interface.  If true, it implies `skipvpncheck`.  **NB**: the cmdline functionality requires passwordless `sudo find` and `sudo grep`

Set `skiproutes` to false if you want to show the routes associated with the interface.  If true, implies `skipvpncheck`.

Set `skipvpncheck` to false if you want to auto-detect a full-route-coverage VPN and change the icon.  Supports OpenVPN, Cisco vpnc, and WireGuard.  **NB**: the WireGuard checks require passwordless `sudo wg`

To create widget put in `rc.lua`
```Lua
net_wired = net_widgets.indicator({
    interfaces  = {"enp2s0", "another_interface", "and_another_one"},
    timeout     = 5
})
```

By default `interfaces=nil`, `timeout=10`

### Internet access indicator.
<!---
http://imgur.com/a/eGP65
-->
![internet widget](http://i.imgur.com/tdJjvPM.png)
This indicator shows up when there is no internet access (detected by trying to connect to `8.8.8.8`). Set `showconnected` to `true` if you're extra precautionary about your internet connection and don't mind seeing a green check mark almost all the time.
```Lua
net_internet = net_widgets.internet({indent = 0, timeout = 5})
```

## Tips
#### Table looks bad
You can change font to monospace by `font` option.

#### Display the signal strength in the popup instead of next to icon
![strenght in popup](https://cloud.githubusercontent.com/assets/23966/6146605/a8eba74c-b1bc-11e4-826a-9468edf18009.png)

Set `popup_signal=true`.

#### Set action on click
Just set `onclick` argument, for example

```Lua
net_wireless = net_widgets.wireless({interface   = "wlp3s0",
                                     onclick     = terminal .. " -e sudo wifi-menu" })
```


#### Get table of wireless widgets or set container widget
Just set `widget` argument as `false`  to get table or some widget layout to change default layout, for example

```Lua
net_wireless = net_widgets.wireless({interface   = "wlp3s0",
                                     widget = false, })
```

or

```Lua
net_wireless = net_widgets.wireless({interface   = "wlp3s0",
                                     widget = wibox.layout.fixed.vertical(), })
```


By default `widget = wibox.layout.fixed.horizontal()`

#### Set indent in wireless textbox
Just set `indent`
```Lua
net_wireless = net_widgets.wireless({interface   = "wlp3s0",
                                     indent = 0, })
```

or

```Lua
net_wireless = net_widgets.wireless({interface   = "wlp3s0",
                                     indent = 5, })
```


By default `indent = 3`

#### Set the pop-up position

Helpful if the widget is placed on the bottom bar and you want the pop-up to appear near the widget rather than on top of the screen.

```Lua
net_wireless = net_widgets.wireless({interface   = "wlp3s0",
                                     popup_position = "bottom_right" })
```
