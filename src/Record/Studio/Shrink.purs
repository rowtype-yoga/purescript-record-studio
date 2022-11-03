module Record.Studio.Shrink (shrink) where

import Prim.Row (class Union)
import Prim.RowList (class RowToList)
import Record.Studio.Keys (class Keys, recordKeys)
import Type.Proxy (Proxy(..))

foreign import shrinkImpl :: forall r1 r2. Array String -> Record r1 -> Record r2

shrink
  :: forall a b bl r
   . RowToList b bl
  => Union b r a
  => Keys bl
  => Record a
  -> Record b
shrink = shrinkImpl (recordKeys (Proxy :: _ b))
