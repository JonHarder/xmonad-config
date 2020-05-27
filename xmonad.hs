import System.IO
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.DynamicBars
import XMonad.Util.Run (spawnPipe)
import XMonad.Hooks.ManageDocks
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Layout.Spacing


term :: String
term = "urxvt"


myLogHook :: [Handle] -> X ()
myLogHook bars = dynamicLogWithPP xmobarPP
  { ppOutput = \x -> mapM_ (\bar -> hPutStrLn bar x) bars
  , ppTitle = xmobarColor "green" "" . shorten 50
  }


myLayoutHook = smartSpacing 10 $ avoidStruts $ layoutHook def


myKeyMap :: [((KeyMask, KeySym), X ())]
myKeyMap = 
  [ ((mod1Mask, xK_b), spawn "vimb")
  , ((mod1Mask .|. shiftMask, xK_p), spawn "emacs")
  ]


defaults bars = def
  { logHook = myLogHook bars
  , layoutHook = myLayoutHook
  , manageHook = manageDocks <+> manageHook def
  , handleEventHook = handleEventHook def <+> docksEventHook
  , terminal = term
  , borderWidth = 3
  } `additionalKeys` myKeyMap


startBar :: MonadIO m => Int -> m Handle
startBar i = spawnPipe $ "xmobar -x " ++ show i

-- TODO: look into XMonad.Hooks.DynamicBars to handle per display bar
main :: IO ()
main = do
  bars <- mapM startBar [0..1]
  xmonad $ defaults bars
