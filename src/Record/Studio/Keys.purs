module Record.Studio.Keys (class Keys, keys, class KeysRL, keysImpl, recordKeys) where

import Prelude

import Data.List (List, (:))
import Data.List as List
import Data.Symbol (class IsSymbol, reflectSymbol)
import Prim.RowList as RL
import Type.Proxy (Proxy(..))

class Keys (r :: Row Type) where
  keys :: (Proxy r) -> Array String

instance (RL.RowToList r rl, KeysRL rl) => Keys r where
  keys _ = List.toUnfoldable $ keysImpl (Proxy :: _ rl)

class KeysRL (xs :: RL.RowList Type) where
  keysImpl :: Proxy xs -> List String

instance KeysRL RL.Nil where
  keysImpl _ = mempty

instance (IsSymbol name, KeysRL tail) => KeysRL (RL.Cons name ty tail) where
  keysImpl _ = first : rest
    where
    first = reflectSymbol (Proxy :: _ name)
    rest = keysImpl (Proxy :: _ tail)

recordKeys :: forall r. Keys r => { | r } -> Array String
recordKeys _ = keys (Proxy :: _ r)
