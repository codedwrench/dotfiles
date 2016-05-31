local wibox         = require("wibox")
local awful         = require("awful")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local module_path = (...):match ("(.+/)[^/]+$") or ""

local wireless = {}
local function worker(args)
    local args = args or {}

    widgets_table = {}
    local connected = false

    -- Settings
    local interface     = args.interface or "wlan0"
    local timeout       = args.timeout or 5
    local font          = args.font or beautiful.font
    local popup_signal  = args.popup_signal or false
    local onclick       = args.onclick
    local widget 	= args.widget == nil and wibox.layout.fixed.horizontal() or args.widget == false and nil or args.widget
    local indent 	= args.indent or 3

    local net_text = wibox.widget.textbox()
    net_text:set_text(" N/A ")
    local net_timer = timer({ timeout = timeout })
    local signal_level = 0
    local function net_update()
        signal_level = tonumber(awful.util.pread("awk 'NR==3 {printf \"%3.0f\" ,($3/70)*100}' /proc/net/wireless"))
        if signal_level == nil then
            connected = false
            net_text:set_text(" N/A ")
	else
            connected = true
            net_text:set_markup(" <span color='#45403D'>|</span>  <span color='#9FDA74'> </span> <span color='#45403D'>|</span>" )
	    if signal_level > 60 then
            	net_text:set_markup(" <span color='#45403D'>|</span>  <span color='#9FDA74'> </span> <span color='#45403D'>|</span>" )
	    elseif signal_level > 40 then
            	net_text:set_markup(" <span color='#45403D'>|</span>  <span color='#edb76b'> </span> <span color='#45403D'>|</span>" )
            elseif signal_level > 0 then
            	net_text:set_markup(" <span color='#45403D'>|</span>  <span color='#ed6b6b'> </span> <span color='#45403D'>|</span>" )
	    end
	end
    end
    net_update()
    net_timer:connect_signal("timeout", net_update)
    net_timer:start()
    
    widgets_table["textbox"]	= net_text
    if widget then
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
            msg =
                "<span font_desc=\""..font.."\">"..
                "Wireless information:\n\n"..
                "Network:\t"..essid.."\n"..
                "IP adress:\t"..inet.."\n"..
                "Signal:\t\t"..signal_level.."%\n</span>"


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
		    position = "bottom_right",
		    text = text_grabber(),
		    timeout = t_out,
            screen = mouse.screen
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
