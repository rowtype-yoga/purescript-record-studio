module Record.Studio.Shrink (shrink) where

import Prim.Row (class Union)
import Record.Studio.Keys (class Keys, keys)
import Type.Proxy (Proxy(..))

foreign import shrinkImpl :: forall r1 r2. Array String -> Record r1 -> Record r2

shrink :: forall a b r. Union b r a => Keys b => { | a } -> { | b }
shrink = shrinkImpl (keys (Proxy :: Proxy b))
