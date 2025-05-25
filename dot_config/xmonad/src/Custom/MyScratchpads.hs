module Custom.MyScratchpads where

import Custom.MyManagementPositioning
import XMonad (appName, className)
import XMonad.ManageHook ((=?))
import XMonad.Util.NamedScratchpad

myScratchpads :: [NamedScratchpad]
myScratchpads =
  [ NS "postman" spawnPostman findPostman manageFloating,
    NS "slack" spawnSlack findSlack manageFloating,
    NS "signal" spawnSignal findSignal manageFloating,
    NS "ym" spawnYM findYM manageFloating,
    NS "kitty" spawnKitty findKitty manageFloating,
    NS "telegram" spawnTelegram findTelegram manageFloating,
    NS "spotify" spawnSpotify findSpotify manageFloating
  ]
  where
    spawnPostman = "postman"
    findPostman = className =? "Postman"
    spawnSlack = "slack"
    findSlack = className =? "Slack"
    spawnSignal = "flatpak run org.signal.Signal"
    findSignal = className =? "Signal"
    spawnTelegram = "flatpak run org.telegram.desktop"
    findTelegram = className =? "TelegramDesktop"
    spawnYM = "youtube-music"
    findYM = className =? "YouTube Music"
    spawnKitty = "kitty"
    findKitty = className =? "kitty"
    spawnSpotify = "flatpak run com.spotify.Client"
    findSpotify = className =? "Spotify"


{-
To get WM_CLASS of a visible window, run "xprop | grep 'CLASS'" and select the window.
appName :: Query String
Return the application name; i.e., the first string returned by WM_CLASS.

resource :: Query String
Backwards compatible alias for appName.

className :: Query String
Return the resource class; i.e., the second string returned by WM_CLASS. -}
