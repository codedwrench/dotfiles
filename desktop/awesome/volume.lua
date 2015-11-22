 -- Codedwrench, modified from https://awesome.naquadah.org/wiki/Davids_volume_widget
 
 local awful = require("awful")
 local wibox = require("wibox") 
 -- Color constants
 local ncolor = '#DCDCCC'
 local boost_color = '#e4dc8c'
 local mute_color = '#af652f'
 local vol_text = wibox.widget.textbox()
 -- Functions to fetch volume information (pulseaudio)
 function get_volume() -- returns the volume as a float (1.0 = 100%)
     local fd = io.popen("pulseaudio-ctl full-status | awk '{ print $1;}'")
     local volume_str = fd:read("*all")
     fd:close()
     if(type(tonumber(volume_str)) == "number") then
     	return tonumber(volume_str) / 100
     else
	return 0
     end
 end
 
 function get_mute() -- returns a true value if muted or a false value if not
     fd = io.popen("pulseaudio-ctl full-status | awk '{ print $2;}'")
     local mute_str = fd:read("*all")
     fd:close()
     return string.find(mute_str, "yes")
 end
 
 -- Updates the volume widget's display
 function update_volume(widget)
     local volume = get_volume()
     local mute = get_mute() 
     -- color
     color = ncolor
     if volume > 1 then
         color = boost_color
     end
     color = (mute and mute_color) or color
     --icon
     if volume > 0.5 then
	icon = ""
     elseif volume > 0.01 then
	icon = ""
     else 
	icon = ""
     end 
 
     volume_widget:set_markup("  <span color='#45403D'>|</span>  <span font='FontAwesome 9' color='" .. tostring(color) .. "'>"..icon.." </span><span font='Liberation Sans 8' color='"..tostring(color).."'>"..math.floor((volume*100)+0.5).."%</span> ")
 end
 
 -- Volume control functions for external use
 function inc_volume(widget)
     awful.util.spawn("pulseaudio-ctl up", false)
     update_volume(widget)
 end
 
 function dec_volume(widget)
     awful.util.spawn("pulseaudio-ctl down", false)
     update_volume(widget)
 end
 
 function mute_volume(widget)
     awful.util.spawn("pulseaudio-ctl mute", false)
     update_volume(widget)
 end
 
 function create_volume_widget()
     -- Define volume widget
     volume_widget = wibox.widget.textbox()
 
     -- Init the widget
     update_volume(volume_widget)
 
     -- Update the widget on a timer
     mytimer = timer({ timeout = 1 })
     mytimer:connect_signal("timeout", function () update_volume(volume_widget) end)
     mytimer:start()
 
     return volume_widget
 end

