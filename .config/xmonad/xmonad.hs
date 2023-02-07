--------------------------------------
-- IMPORT PACKAGES
--------------------------------------
import XMonad
import qualified XMonad.StackSet as W
import XMonad.Layout.Renamed (renamed, Rename (Replace))
import XMonad.Layout.Spacing (spacing)
import XMonad.Layout.LimitWindows (limitWindows)
import XMonad.Layout.MultiToggle.Instances (StdTransformers(MIRROR, NBFULL, NOBORDERS))
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.Reflect (REFLECTX(REFLECTX), REFLECTY (REFLECTY))
import XMonad.Layout.OneBig (OneBig(OneBig))
import XMonad.Hooks.ManageDocks (ToggleStruts(..))
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??), Toggle (Toggle))
import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.SimplestFloat (simplestFloat)
import XMonad.Hooks.EwmhDesktops 
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import XMonad.Actions.CycleWS
import XMonad.Actions.CycleWindows
import XMonad.Actions.GroupNavigation
import qualified Data.Map as Map


import XMonad.Actions.WithAll (killAll, sinkAll)
import XMonad.Actions.CopyWindow (copyToAll, killAllOtherCopies)
import XMonad.Util.EZConfig (additionalKeysP)

import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Actions.Navigation2D 

import XMonad.Util.Cursor (setDefaultCursor)
-- import XMonad.Hooks.DynamicLog 
import XMonad.Layout.IndependentScreens
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.WorkspaceCompare (getSortByIndex)
import XMonad.Hooks.RefocusLast (shiftRLWhen, isFloat)

--------------------------------------
-- Variables Initialization
--------------------------------------
-- myFont :: String
-- myFont = "xft:JetBrainsMonoMedium Nerd Font:weight=book:pixelsize=12:antialias=true:hinting=true"

myTerminal :: String
myTerminal = "kitty"

myBrowser :: String
myBrowser = "brave"

myFileManager :: String
myFileManager = "thunar"

myEditor :: String
myEditor = myTerminal ++ "-e nvim"

myNormalBorderColor :: String
myNormalBorderColor = "#f6f4f3"

myFocusedBorderColor :: String
myFocusedBorderColor = "#890620"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

myClickJustFocuses :: Bool
myClickJustFocuses  = False

myBorderWidth :: Dimension
myBorderWidth = 4

windowCount :: X(Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset


--------------------------------------
-- Autostart
--------------------------------------
myStartupHook :: X ()
myStartupHook = do
    spawnOnce "picom --experimental-backends &"
    spawnOnce "feh --bg-fill --randomize ~/.wallpapers/* &"  -- feh set random wallpaper
    spawnOnce "trayer --iconspacing 5 --edge top --align right --widthtype request --heighttype pixel --padding 5 --SetDockType true --SetPartialStrut false --expand true --monitor primary --transparent true --alpha 0 --tint 0x282c34  --height 22"
    setDefaultCursor xC_left_ptr -- Set cursor theme


--------------------------------------
-- Generating Layouts and Naming Them
--------------------------------------

tall = renamed[Replace "tall"] $ smartBorders $ limitWindows 12 $ spacing 4 $ Tall 1 (3/100)(2/3)
grid = renamed[Replace "grid"] $ limitWindows 12 $ spacing 4 $ mkToggle(single MIRROR) $ Grid(16/10)
oneBig = renamed[Replace "oneBig"] $ limitWindows 6 $ spacing 4 $ Mirror $ mkToggle (single MIRROR) $ mkToggle (single REFLECTX) $ mkToggle (single REFLECTY) $ OneBig (5/9) (8/12)
monocle = renamed[Replace "monocle"] $ limitWindows 20 Full
floats = renamed [Replace "floats"] $ limitWindows 20 simplestFloat

addKeys conf@(XConfig { modMask = modm }) = Map.fromList $
    [((m .|. modm, k), windows $ onCurrentScreen f i)
        | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]


myKeys :: [(String, X ())]
myKeys = [ 
  -- Windows
  ("M-S-a", killAll)                                                     -- Kill all windows on current workspace
  -- Windows navigation
 ,("M-S-s", windows copyToAll)                                          -- Copy the winow to ALL workspaces
 ,("M-C-c", killAllOtherCopies)                                         -- Kill all the copies apart from the focused 

 -- Move between current and the last open windows
 -- TODO: current and last open windows of the same screen
 ,("M-x", nextMatch History (return True))
 ,("M-z", toggleWS)

 -- Cycle windows
 ,("M4-s", cycleRecentWindows [xK_Super_L] xK_s xK_w)
 ,("M-i", rotUnfocusedUp)
 ,("M-o", rotUnfocusedDown)
 ,("M-c-i", rotFocusedUp)
 
 -- Directional navigation of screens
 ,("M-r", screenGo L False)
 ,("M-u", screenGo R False)

 -- Swap workspaces on adjacent screens
 ,("M-C-r", screenSwap L False)
 ,("M-C-u", screenSwap R False)

 -- Send window to adjacent screen
 ,("M-S-r", windowToScreen L False)
 ,("M-S-u", windowToScreen R False)

 -- Layouts
 ,("M-S-n", sendMessage(Toggle NOBORDERS))
 ,("M-S-=", sendMessage(Toggle NBFULL) >> sendMessage ToggleStruts)

 -- Floating Windows
 ,("M-S-f", sendMessage (T.Toggle "floats"))                           -- Toggles my 'floats' layout
 ,("M-t", withFocused $ windows . W.sink)                              -- Push floating window back to tile
 ,("M-S-t", sinkAll)                                                   -- Push ALL floating windows to tile

 -- Application Spawn
 ,("M-b", spawn myBrowser)                                             -- (Alt + b)
 ,("M-n", spawn myEditor)                                              -- (Alt + n)
 ,("M-f", spawn myFileManager)                                         -- (Alt + f)
 ,("M-p", spawn "rofi -show drun")                                     -- (Alt + p)
 ,("M-S-p", spawn "rofi -show window")                                   -- (Alt + x)
 ] 

myLayoutHook = smartBorders $ T.toggleLayouts floats $
        mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
        where
         myDefaultLayout = oneBig ||| noBorders monocle ||| tall |||  grid ||| floats

--------------------------------------
-- Workspace Names that go on XMobar
--------------------------------------

myWorkspaces :: [String]
myWorkspaces = ["  \x0031 ", "\x0032 ", "\x0033 ", "\x0034 ", "\x0035 ", "\x0036 ", "\x0037 ", "\x0038 ", "\x0039"]
-- myWorkspaces = ["1", "2", "3", "4", "5"]

ppLeft :: PP
ppRight :: PP
ppLeft =  xmobarPP {ppCurrent = xmobarColor "#94e2d5" "" . wrap "<fn=1>" "</fn>"    -- Workspace that I am viewing now
      , ppVisible = xmobarColor "#98be65" "" . wrap "<fn=1>" "</fn>"              -- Workspace that is open on any monitor other than this one
      , ppHidden = xmobarColor "#2ac3de" "" . wrap "<fn=1>" "</fn>"               -- Hidden workspaces that have any open software in it but not open on any monitors
      , ppHiddenNoWindows = xmobarColor "#c0caf5" "" . wrap "<fn=1>" "</fn>"      -- Workspaces with no open softwares and not open on any monitors
      , ppTitle = xmobarColor "#c0caf5" "" . shorten 15               -- Title of active window
      , ppSep =  "<fc=#444b6a> | </fc>"                               -- Separator character
      , ppUrgent = xmobarColor "#EBCB8B" "" . wrap "!<fn=1>" "</fn>!" -- Urgent workspace
      , ppExtras  = [windowCount]                                     -- # of windows current workspace
      } 

ppRight = xmobarPP{ppCurrent = xmobarColor "#94e2d5" "" . wrap "<fn=1>" "</fn>"    -- Workspace that I am viewing now
      , ppVisible = xmobarColor "#98be65" "" . wrap "<fn=1>" "</fn>"              -- Workspace that is open on any monitor other than this one
      , ppHidden = xmobarColor "#2ac3de" "" . wrap "<fn=1>" "</fn>"               -- Hidden workspaces that have any open software in it but not open on any monitors
      , ppHiddenNoWindows = xmobarColor "#c0caf5" "" . wrap "<fn=1>" "</fn>"      -- Workspaces with no open softwares and not open on any monitors
      , ppTitle = xmobarColor "#c0caf5" "" . shorten 15               -- Title of active window
      , ppSep =  "<fc=#444b6a> | </fc>"                               -- Separator character
      , ppUrgent = xmobarColor "#EBCB8B" "" . wrap "!<fn=1>" "</fn>!" -- Urgent workspace
      , ppExtras  = [windowCount]                                     -- # of windows current workspace
      }

xmobarLeft :: StatusBarConfig
xmobarRight :: StatusBarConfig
xmobarLeft = statusBarPropTo "_XMONAD_LOG_1" "xmobar -x 0 $HOME/.config/xmonad/xmobar/xmobarrc0.hs" $ pure $ marshallPP 0 ppLeft
xmobarRight = statusBarPropTo "_XMONAD_LOG_2" "xmobar -x 1 $HOME/.config/xmonad/xmobar/xmobarrc1.hs" $ pure $ marshallPP 1 ppRight

barSpawner :: ScreenId -> IO StatusBarConfig
barSpawner 0 = pure xmobarLeft 
barSpawner 1 = pure xmobarRight
barSpawner _ = mempty -- nothing on the rest of the screens

manageZoomHook =
  composeAll $
    [ (className =? zoomClassName) <&&> shouldFloat <$> title --> doFloat,
      (className =? zoomClassName) <&&> shouldSink <$> title --> doSink
    ]
  where
    zoomClassName = "zoom"
    tileTitles =
      [ "Zoom - Free Account", -- main window
        "Zoom - Licensed Account", -- main window
        "Zoom", -- meeting window on creation
        "Zoom Meeting" -- meeting window shortly after creation
      ]
    shouldFloat title = title `notElem` tileTitles
    shouldSink title = title `elem` tileTitles
    doSink = (ask >>= doF . W.sink) <+> doF W.swapDown

main :: IO()
main = do
    nScreens <- countScreens
    xmonad $ ewmhFullscreen $ ewmh $  dynamicEasySBs barSpawner $ withNavigation2DConfig def $ def
        {layoutHook = myLayoutHook,
         terminal=myTerminal,
         focusFollowsMouse = myFocusFollowsMouse,
         clickJustFocuses = myClickJustFocuses, 
         borderWidth = myBorderWidth,
         normalBorderColor = myNormalBorderColor,
         focusedBorderColor = myFocusedBorderColor,
         startupHook = myStartupHook,
         workspaces = withScreens nScreens myWorkspaces,
         manageHook = manageZoomHook,
         keys = \c -> addKeys c `Map.union` keys def c
         } 
         `additionalKeysP` myKeys
