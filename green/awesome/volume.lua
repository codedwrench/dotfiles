 -- Codedwrench, modified from https://awesome.naquadah.org/wiki/Davids_volume_widget
 
 local awful = require("awful")
 local wibox = require("wibox") 
 -- Color constants
 local ncolor = '#DDDDDD'
 local boost_color = '#e4dc8c'
 local mute_color = '#af652f'
 local vol_text = wibox.widget.textbox()
 -- Functions to fetch volume information (pulseaudio)
 function get_volume() -- returns the volume as a float (1.0 = 100%)
     local fd = io.popen("ponymix get-volume")
     local volume_str = fd:read("*all")
     fd:close()
     if(type(tonumber(volume_str)) == "number") then
     	return tonumber(volume_str) / 100
     else
	return 0
     end
 end
 
 function get_mute() -- returns a true value if muted or a false value if not
     fd = io.popen("if `ponymix is-muted`;then echo 1;fi")
     local mute_str = fd:read("*all")
     return string.find(mute_str, "1")
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
 
     volume_widget:set_markup("  <span color='#45403D'>|</span>  <span font='FontAwesome 10' color='" .. tostring(color) .. "'>"..icon.."  </span><span font='Liberation Sans 9' color='"..tostring(color).."'>"..math.floor((volume*100)+0.5).."%</span> ")
 end
 
 -- Volume control functions for external use
 function inc_volume(widget)
     awful.util.spawn("ponymix increase 5", false)
     update_volume(widget)
 end
 
 function dec_volume(widget)
     awful.util.spawn("ponymix decrease 5", false)
     update_volume(widget)
 end
 
 function mute_volume(widget)
     awful.util.spawn("ponymix toggle", false)
     update_volume(widget)
 end
 
 function create_volume_widget()
     -- Define volume widget
     volume_widget = wibox.widget.textbox()
 
     -- Init the widget
     update_volume(volume_widget)
 
     -- scroll
     volume_widget:buttons(awful.util.table.join(
     	awful.button({ }, 4, function () inc_volume(volume_widget) end),
     	awful.button({ }, 5, function () dec_volume(volume_widget) end),
     	awful.button({ }, 2, function () mute_volume(volume_widget) end),
     	awful.button({ }, 1, function () awful.util.spawn("pavucontrol") end)
     ))
     -- Update the widget on a timer
     mytimer = timer({ timeout = 1 })
     mytimer:connect_signal("timeout", function () update_volume(volume_widget) end)
     mytimer:start()
 
     return volume_widget
 end

