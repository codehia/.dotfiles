Config { font    = "xft:JetBrainsMono Nerd Font:pixelsize=10:antialias=true:hinting=true"
       , bgColor = "#11111b"
       , fgColor = "#cdd6f4"
       , alpha = 255
       , position = TopHM 24 4 4 4 4
       , lowerOnStart = True
       , hideOnStart = False
       , allDesktops = False
       , persistent = True
       , overrideRedirect = True
       , commands = [ Run XPropertyLog "_XMONAD_LOG_0"
                    , Run Date "<fc=#81A1C1><fc=#D8DEE9>%I:%M %p</fc> %a %_d %b %Y</fc>" "date" 300             -- Time and date -- 30 seconds
                    , Run Com ".local/bin/checkupdate" [] "checkupdate" 72000                                   -- This script uses pacman-contrib package to work
                    , Run Wireless "wlp3s0" ["--template", "<fn=1><fc=#94e2d5><qualitybar>  <ssid></fc></fn>"
                                              , "-W"
                                              , "0"
                                              , "-f", "󰤭󰤯󰤟󰤢󰤥󰤨"
                                              , "-L", "5"
                                              , "-l", "#FF0000" ] 1200                                          -- Wireless Interface -- 2 minute 
                    , Run Com ".local/bin/trayer-padding-icon.sh" ["panel"] "trayerpad" 50                      -- Shift all icons to the left to accomodate system tray -- 5 seconds
		                , Run Battery ["--template", "<fc=#cba6f7><acstatus></fc>"
                                   , "-S", "󰁹 ", "-d", "0", "-m", "2" --suffix false(default), --ddigits 0 decimal places to show, --minWidth 2 characters(can be padded with -c/--padchars string)
                                   , "-L", "20", "-H", "80", "-p", "3" --Low , --High, --ppad pads percentage values with 3 characters
                                   , "-W", "0" --bwidth total number of characters used to draw bars (default 10)
                                   , "-f", "󰂎󰁺󰁻󰁼󰁽󰁾󰁿󰂀󰂁󰂂󰁹" -- Choose icon for leftbar depending on battery remaining --bfore characters used to draw bars (cyclically)
                                   , "--" -- Monitor specific data below
                                   , "-a", "notify-send -u critical 'Battery running out!'"
                                   , "-A", "10"
                                   , "-O", "<left><fn=1> 󰂄 </fn>"
                                   , "-o", "<left><fn=1> <leftbar> </fn>" -- Discharging
                                   , "-H", "8", "-L", "5" 
                                   , "-l", "green", "-m", "grey", "-h", "#f38ba8" -- Shows an approximation of rate of battery discharge
                    ] 600
        ]
       , sepChar = "%"
       , alignSep = "}{"
     , template = "<fn=1> 󰣛 </fn>%_XMONAD_LOG_0%}%date%{ %battery% %wlp3s0wi% %trayerpad%"
}
