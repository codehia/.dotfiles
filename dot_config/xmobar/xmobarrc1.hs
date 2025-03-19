-- This is XMOBAR CONFIG for monitor 1
-- If you have more monitors, make separate configs, then call these from xmonad
-- Font used : Fira Code, CaskaydiaCove Nerd Font for icons
Config { font    = "xft:JetBrainsMonoMedium Nerd Font:weight=bold:pixelsize=12:antialias=true:hinting=true"
       -- , additionalFonts = [ "xft:JetBrainsMonoMedium Nerd Font:weight=book:pixelsize=12:antialias=true:hinting=true"]
       , bgColor = "#11111b"
       , fgColor = "#cdd6f4"
       , alpha = 254
       , position = TopSize L 100 24 
       , lowerOnStart = True
       , hideOnStart = False
       , allDesktops = False
       , persistent = True
       -- , iconRoot = ".config/xmonad/xpm/"
       , overrideRedirect = True
       , commands = [ Run XPropertyLog "_XMONAD_LOG_1"
                      -- Time and date -- 30 seconds
                    , Run Date "<fc=#81A1C1><fc=#D8DEE9>%I:%M %p</fc> %a %_d %b %Y</fc>" "date" 300
                      -- Disk space free -- 30 minute 
                    , Run DiskU [("/", "<fc=#88C0D0><fn=1> </fn><free></fc>")] [] 18000 -- Shows total free space on the root partition
                      -- Ram used number and percent -- 2 seconds
                    , Run Memory ["--template", "<fc=#A3BE8C><fn=1> </fn>[<used>M]</fc>", "-S", "On"] 20
                      -- Cpu usage in percent -- 5 seconds
                    , Run Cpu ["--template", "<fc=#EBCB8B><fn=1> </fn><total></fc>" , "-S", "On" ,"-H","50" ,"--high","red"] 50
                      -- Show CPU temperature -- 1 minute
                      -- This script uses pacman-contrib package to work
                    , Run Com ".local/bin/checkupdate" [] "checkupdate" 72000
                      -- Network up and down -- 2 seconds
                    , Run DynNetwork ["--template", "<fc=#98be65><rx> <fc=#39ff14><fn=1> </fn></fc><fc=#ff9f00><fn=1></fn></fc> <tx> </fc>" , "-S", "True"] 20
                      -- Wireless Interface -- 2 minute 
                    -- , Run Wireless "wlp2s0" ["--template", "<fn=1><fc=#ecd534><qualitybar> </fc></fn>"
                    --                            , "-W", "0"
                    --                            , "-f", "睊直直直直直直直直"
                    --                            , "-L", "5", "-l", "#FF0000"
                    --                           ] 1200
                      -- Runs a standard shell command 'uname -r' to get kernel version -- 2 hour
                    , Run Com "uname" ["-s","-r"] "" 0
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "<fn=1>   </fn>%_XMONAD_LOG_1% }<box width=4 color=#00BCD4 type=Bottom>%date%</box>{ <box width=4 color=#673AB7 ml=2 type=Bottom>%disku%</box> <action=`kitty -e htop`>%memory%</action> %cpu% <fc=#D08770><fn=1> </fn>%uname% %checkupdate%</fc> %dynnetwork%"
       
