This is a remix of an amazing Numix theme.(http://numixproject.org) Remixed by Vitaly Korolev (vitaly.korolev@gmail.com) because blue is nice too.

All credits should go to the Numix team:
Simon Steinbeiß <simon.steinbeiss@univie.ac.at>
Joern Konopka <cldx3000@googlemail.com>
Georgi Karavasilev <motorslav@gmail.com>
David Barr <dpbarr@gmail.com>

All I did is replace red color with blue in the window controls. The rest of the theme follows default GTK highlight color which you can set with Theme Config. You can also change highlight color for Window Manager effects with Unity Tweak Tool. (resize, maximize and expose highlight effect)

Here are detailed steps to get this theme working:
1. Copy Numix-Blue-Remix to /usr/share/themes/
2. Install Theme Configuration app (sudo apt-get install gtk-theme-config) and use it to set highlight color to blue. I suggest #3465a4 and that's what I used for window controls.
3. Install Unity Tweak (sudo apt-get install unity-tweak-tool) and use it to change colors in "Window Manager" > "Window snapping" and "Additional".

Finally, the original Numix theme removed borders around icons in the launcher. I prefer to have those and so I hacked the theme by removing all launcher* icons in unity folder. If you'd like to restore those, simply copy the icons from the original theme.

