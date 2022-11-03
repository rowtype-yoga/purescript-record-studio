module Record.Studio.MapKind where

import Prelude
import Data.Symbol (class IsSymbol)
import Heterogeneous.Folding (class FoldingWithIndex, class FoldlRecord, class HFoldlWithIndex, hfoldlWithIndex)
import Prim.Row as Row
import Prim.RowList (class RowToList)
import Record.Builder (Builder)
import Record.Builder as Builder
import Type.Proxy (Proxy)

-- Helper for type inference
data MapRecordKind :: forall k. (k -> Type) -> (k -> Type) -> Type
data MapRecordKind f g = MapRecordKind (f ~> g)

-- Matches if the type of the current field in the record is f a and therefore needs to be naturally transformed.
instance
  ( IsSymbol sym
  , Row.Lacks sym rb
  , Row.Cons sym (g a) rb rc
  ) =>
  FoldingWithIndex
    (MapRecordKind f g)
    (Proxy sym)
    (Builder { | ra } { | rb })
    (f a)
    (Builder { | ra } { | rc }) where
  foldingWithIndex (MapRecordKind nt) prop rin fa = (rin >>> Builder.insert prop (nt fa))

-- Matches if the type of the current field in the record is another record and therefore needs to be recursed.
else instance
  ( IsSymbol sym
  , Row.Lacks sym rb
  , RowToList x xRL
  , Row.Cons sym { | y } rb rc
  , FoldlRecord
      (MapRecordKind f g)
      (Builder (Record ()) (Record ()))
      xRL
      x
      (Builder (Record ()) (Record y))
  ) =>
  FoldingWithIndex
    (MapRecordKind f g)
    (Proxy sym)
    (Builder { | ra } { | rb })
    { | x }
    (Builder { | ra } { | rc }) where
  foldingWithIndex (MapRecordKind nt) prop rin x = (rin >>> Builder.insert prop fx)
    where
    fx = mapRecordKind nt x

-- Matches if the type of the current field in the record is any other type independent of the natural transformation.
else instance
  ( IsSymbol sym
  , Row.Lacks sym rb
  , Row.Cons sym x rb rc
  ) =>
  FoldingWithIndex
    (MapRecordKind f g)
    (Proxy sym)
    (Builder { | ra } { | rb })
    x
    (Builder { | ra } { | rc }) where
  foldingWithIndex _ prop rin x = (rin >>> Builder.insert prop x)

-- | Recursively mapK a record using a natural transformation. E.g.
-- | ```purescript
-- | let
-- |   nt :: Either String ~> Maybe
-- |   nt = hush
-- | mapRecordKind { a : { b : { c : { d: Right 10, e : Left "hello" }, f : Right true }
-- | -- Just { a : { b : { c : { d: Just 10, e : Nothing }, f : Just true }
-- | ```
mapRecordKind
  :: forall f g rin rout
   . HFoldlWithIndex (MapRecordKind f g) (Builder {} {}) { | rin } (Builder {} { | rout })
  => (f ~> g)
  -> { | rin }
  -> { | rout }
mapRecordKind nt =
  (flip Builder.build {})
    <<< hfoldlWithIndex (MapRecordKind nt :: MapRecordKind f g) (identity :: Builder {} {})
