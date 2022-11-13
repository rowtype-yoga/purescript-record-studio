module Record.Studio.MapUniform where

import Prelude

import Data.Symbol (class IsSymbol)
import Prim.Row as Row
import Prim.RowList (class RowToList, RowList)
import Prim.RowList as RL
import Record as R
import Record.Builder (Builder)
import Record.Builder as Builder
import Type.Proxy (Proxy(..))

mapUniformRecord
  :: forall row xs a b row'
   . RowToList row xs
  => MapUniformRecord xs row a b () row'
  => (a -> b)
  -> Record row
  -> Record row'
mapUniformRecord fn = Builder.buildFromScratch
  <<< mapUniformRecordBuilder (Proxy :: Proxy xs) fn

class
  MapUniformRecord (xs :: RowList Type) (row :: Row Type) a b (from :: Row Type) (to :: Row Type)
  | xs -> row a b from to where
  mapUniformRecordBuilder :: Proxy xs -> (a -> b) -> Record row -> Builder { | from } { | to }

-- Start the recursion
instance MapUniformRecord RL.Nil row a b () () where
  mapUniformRecordBuilder _ _ _ = identity

instance
  ( IsSymbol name
  , Row.Cons name a rest row
  , Row.Lacks name from'
  , Row.Cons name b from' to
  , MapUniformRecord tail row a b from from'
  ) =>
  MapUniformRecord (RL.Cons name a tail) row a b from to where
  mapUniformRecordBuilder _ fn r = first <<< rest
    where
    first = Builder.insert nameP value
    rest = mapUniformRecordBuilder tailP fn r
    value = fn (R.get nameP r)
    nameP = Proxy :: Proxy name
    tailP = Proxy :: Proxy tail
