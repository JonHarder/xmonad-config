import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Util.Run (spawnPipe)
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Layout.Spacing


term :: String
term = "urxvt"


myLogHook :: Handle -> X ()
myLogHook bar = dynamicLogWithPP xmobarPP
  { ppOutput = hPutStrLn bar
  , ppTitle = xmobarColor "green" "" . shorten 50
  }


myLayoutHook = smartSpacing 10 $ avoidStruts $ layoutHook defaultConfig


myKeyMap :: [((KeyMask, KeySym), X ())]
myKeyMap = 
  [ ((mod1Mask, xK_b), spawn "vimb")
  , ((mod1Mask .|. shiftMask, xK_p), spawn "emacs")
  ]


defaults bar = def
  { logHook = myLogHook bar
  , layoutHook = myLayoutHook
  , manageHook = manageDocks <+> manageHook def
  , handleEventHook = handleEventHook def <+> docksEventHook
  , terminal = term
  , borderWidth = 3
  } `additionalKeys` myKeyMap


main :: IO ()
main = xmonad =<< defaults <$> spawnPipe "xmobar"
