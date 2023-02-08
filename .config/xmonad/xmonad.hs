--------------------------------------
-- IMPORT PACKAGES
--------------------------------------
import XMonad
    ( xmonad, (<+>), doF, doFloat, (-->), title, (<&&>), (=?), className, composeAll,
      (|||), spawn, withFocused, sendMessage, xK_w, xK_s, xK_Super_L, shiftMask, xK_9,
      xK_1, windows, xC_left_ptr, MonadReader(ask), Default(def), (.|.),
      XConfig(XConfig, keys, modMask, layoutHook, terminal,
              focusFollowsMouse, clickJustFocuses, borderWidth,
              normalBorderColor, focusedBorderColor, startupHook, workspaces,
              manageHook),
      Full(Full),
      Mirror(Mirror),
      Tall(Tall),
      ScreenId, X, Dimension )

import XMonad.Layout.Renamed (renamed, Rename (Replace))
import XMonad.Layout.Spacing (spacing)
import XMonad.Layout.LimitWindows (limitWindows)
import XMonad.Layout.MultiToggle.Instances (StdTransformers(MIRROR, NBFULL, NOBORDERS))
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.Reflect (REFLECTX(REFLECTX), REFLECTY (REFLECTY))
import XMonad.Layout.OneBig (OneBig(OneBig))
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??), Toggle (Toggle))
import XMonad.Layout.NoBorders (smartBorders, noBorders)
import XMonad.Layout.SimplestFloat (simplestFloat)

import XMonad.Hooks.EwmhDesktops ( ewmh, ewmhFullscreen ) 
import XMonad.Hooks.ManageDocks (ToggleStruts(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import XMonad.Actions.CycleWS ( toggleWS )
import XMonad.Actions.CycleWindows ( rotFocusedUp, rotUnfocusedDown, rotUnfocusedUp, cycleRecentWindows )
import XMonad.Actions.GroupNavigation ( nextMatch, Direction(History) )
import qualified Data.Map as Map

import qualified XMonad.StackSet as W
import XMonad.Actions.WithAll (killAll, sinkAll)
import XMonad.Actions.CopyWindow (copyToAll, killAllOtherCopies)
import XMonad.Util.EZConfig (additionalKeysP)

import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Actions.Navigation2D ( withNavigation2DConfig, windowToScreen, screenSwap, screenGo, Direction2D(R, L)) 

import XMonad.Util.Cursor (setDefaultCursor)
import XMonad.Layout.IndependentScreens ( withScreens, countScreens, marshallPP, workspaces', onCurrentScreen)
import XMonad.Hooks.StatusBar
    ( dynamicEasySBs, statusBarPropTo, StatusBarConfig )
import XMonad.Hooks.StatusBar.PP ( xmobarPP, wrap, xmobarColor,
    PP(ppExtras, ppCurrent, ppVisible, ppHidden, ppHiddenNoWindows, ppTitle, ppSep, ppUrgent, ppLayout))
import qualified Graphics.X11.Types
import XMonad.Util.Loggers (logTitleOnScreen, shortenL, padL, xmobarColorL, logLayoutOnScreen)

--------------------------------------
-- Variables Initialization
--------------------------------------

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

addKeys :: XConfig l -> Map.Map
     (Graphics.X11.Types.KeyMask, Graphics.X11.Types.KeySym) (X ())
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

ppLeft :: PP
ppRight :: PP

ppLeft =  xmobarPP {ppCurrent = xmobarColor "#cba6f7" "" . wrap "<fn=1>" "</fn>"    -- Workspace that I am viewing now
      , ppVisible = xmobarColor "#6c7086" "" . wrap "<fn=1>" "</fn>"              -- Workspace that is open on any monitor other than this one
      , ppHidden = xmobarColor "#6c7086" "" . wrap "<fn=1>" "</fn>"               -- Hidden workspaces that have any open software in it but not open on any monitors
      , ppHiddenNoWindows = xmobarColor "#313244" "" . wrap "<fn=1>" "</fn>"      -- Workspaces with no open softwares and not open on any monitors
      , ppSep =  "<fc=#444b6a> | </fc>"                               -- Separator character
      , ppUrgent = xmobarColor "#EBCB8B" "" . wrap "!<fn=1>" "</fn>!" -- Urgent workspace
      , ppTitle = \x -> ""
      , ppLayout = \x -> ""
      , ppExtras  = [logLayoutOnScreen 0, xmobarColorL "#EBCB8B" "" . padL . shortenL 15 $ logTitleOnScreen 0]                                    
      } 

ppRight = xmobarPP{ppCurrent = xmobarColor "#cba6f7" "" . wrap "<fn=1>" "</fn>"    -- Workspace that I am viewing now
      , ppVisible = xmobarColor "#6c7086" "" . wrap "<fn=1>" "</fn>"              -- Workspace that is open on any monitor other than this one
      , ppHidden = xmobarColor "#6c7086" "" . wrap "<fn=1>" "</fn>"               -- Hidden workspaces that have any open software in it but not open on any monitors
      , ppHiddenNoWindows = xmobarColor "#313244" "" . wrap "<fn=1>" "</fn>"      -- Workspaces with no open softwares and not open on any monitors
      , ppSep =  "<fc=#444b6a> | </fc>"                               -- Separator character
      , ppUrgent = xmobarColor "#EBCB8B" "" . wrap "!<fn=1>" "</fn>!" -- Urgent workspace
      , ppTitle = \x -> ""
      , ppLayout = \x -> ""
      , ppExtras  = [logLayoutOnScreen 1, xmobarColorL "#EBCB8B" "" . padL . shortenL 15 $ logTitleOnScreen 1]
      }

xmobarLeft :: StatusBarConfig
xmobarRight :: StatusBarConfig
xmobarLeft = statusBarPropTo "_XMONAD_LOG_1" "xmobar -x 0 $HOME/.config/xmobar/xmobarrc0.hs" $ pure $ marshallPP 0 ppLeft
xmobarRight = statusBarPropTo "_XMONAD_LOG_2" "xmobar -x 1 $HOME/.config/xmobar/xmobarrc1.hs" $ pure $ marshallPP 1 ppRight

barSpawner :: ScreenId -> IO StatusBarConfig
barSpawner 0 = pure xmobarLeft 
barSpawner 1 = pure xmobarRight
barSpawner _ = mempty -- nothing on the rest of the screens

manageZoomHook =
  composeAll
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
