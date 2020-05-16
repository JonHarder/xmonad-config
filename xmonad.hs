import System.IO

import XMonad
import XMonad.Actions.Volume
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run (spawnPipe)
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Layout.Spacing


main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ defaultConfig
    { logHook = dynamicLogWithPP xmobarPP
                  { ppOutput = hPutStrLn xmproc
                  , ppTitle = xmobarColor "green" "" . shorten 50
                  }
    , layoutHook = smartSpacing 10 $ avoidStruts $ layoutHook defaultConfig
    , manageHook = manageDocks <+> manageHook defaultConfig
    , handleEventHook = handleEventHook defaultConfig <+> docksEventHook
    , terminal = "termonad"
    , borderWidth = 3
    } `additionalKeys`
    [ ((mod1Mask, xK_b), spawn "vimb")
    , ((mod1Mask .|. shiftMask, xK_l), spawn "gnome-screensaver-command -l")
    , ((0, xK_F11), lowerVolume 4 >> return ())
    , ((0, xK_F12), raiseVolume 4 >> return ())
    ]
