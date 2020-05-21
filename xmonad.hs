import System.IO

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run (spawnPipe)
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Layout.Spacing


term :: String
term = "urxvt"


main :: IO ()
main = do
  xmproc <- spawnPipe "xmobar -x 0"
  xmonad $ def
    { logHook = dynamicLogWithPP xmobarPP
                  { ppOutput = hPutStrLn xmproc
                  , ppTitle = xmobarColor "green" "" . shorten 50
                  }
    , layoutHook = smartSpacing 10 $ avoidStruts $ layoutHook defaultConfig
    , manageHook = manageDocks <+> manageHook defaultConfig
    , handleEventHook = handleEventHook defaultConfig <+> docksEventHook
    , terminal = term
    , borderWidth = 3
    } `additionalKeys`
    [ ((mod1Mask, xK_b), spawn "vimb")
    , ((mod1Mask .|. shiftMask, xK_l), spawn "gnome-screensaver-command -l")
    ]
