module Record.Studio.Keys where

import Prelude

import Data.List (List, (:))
import Data.List as List
import Data.Symbol (class IsSymbol, reflectSymbol)
import Prim.RowList as RL
import Type.Proxy (Proxy(..))

class Keys (xs :: RL.RowList Type) where
  keysImpl :: Proxy xs -> List String

instance Keys RL.Nil where
  keysImpl _ = mempty

instance (IsSymbol name, Keys tail) => Keys (RL.Cons name ty tail) where
  keysImpl _ = first : rest
    where
    first = reflectSymbol (Proxy :: _ name)
    rest = keysImpl (Proxy :: _ tail)

recordKeys
  :: forall g row rl
   . RL.RowToList row rl
  => Keys rl
  => g row -- this will work for any type with the row as a param!
  -> Array String
recordKeys _ = List.toUnfoldable $ keysImpl (Proxy :: _ rl)
