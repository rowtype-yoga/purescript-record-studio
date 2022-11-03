module Record.Studio.Map where

import Prelude
import Data.Symbol (class IsSymbol)
import Heterogeneous.Folding (class FoldingWithIndex, class FoldlRecord, class HFoldlWithIndex, hfoldlWithIndex)
import Prim.Row as Row
import Prim.RowList (class RowToList)
import Record.Builder (Builder)
import Record.Builder as Builder
import Type.Proxy (Proxy)

-- Helper for type inference
data MapRecord a b = MapRecord (a -> b)

-- Matches if the type of the current field in the record is a and therefore needs to be mapped.
instance
  ( IsSymbol sym
  , Row.Lacks sym rb
  , Row.Cons sym b rb rc
  ) =>
  FoldingWithIndex
    (MapRecord a b)
    (Proxy sym)
    (Builder { | ra } { | rb })
    a
    (Builder { | ra } { | rc }) where
  foldingWithIndex (MapRecord f) prop rin a = (rin >>> Builder.insert prop (f a))

-- Matches if the type of the current field in the record is another record and therefore needs to be recursed.
else instance
  ( IsSymbol sym
  , Row.Lacks sym rb
  , RowToList x xRL
  , Row.Cons sym { | y } rb rc
  , FoldlRecord
      (MapRecord a b)
      (Builder (Record ()) (Record ()))
      xRL
      x
      (Builder (Record ()) (Record y))
  ) =>
  FoldingWithIndex
    (MapRecord a b)
    (Proxy sym)
    (Builder { | ra } { | rb })
    { | x }
    (Builder { | ra } { | rc }) where
  foldingWithIndex (MapRecord f) prop rin x = (rin >>> Builder.insert prop fx)
    where
    fx = mapRecord f x

-- Matches if the type of the current field in the record is any other type independent of mapping.
else instance
  ( IsSymbol sym
  , Row.Lacks sym rb
  , Row.Cons sym x rb rc
  ) =>
  FoldingWithIndex
    (MapRecord a b)
    (Proxy sym)
    (Builder { | ra } { | rb })
    x
    (Builder { | ra } { | rc }) where
  foldingWithIndex _ prop rin x = (rin >>> Builder.insert prop x)

-- | Recursively maps a record using a function f.
-- | ```purescript
-- | let
-- |   f :: Int -> String
-- |   f i = show (i + 1)
-- | mapRecord  f { a : { b : 10, c : { d: 20, e : Just "hello" }}, f : 30 }
-- | -- { a : { b : "11", c : { d: "21", e : Just "hello" }, f : "31" }
-- | ```
mapRecord
  :: forall a b rin rout
   . HFoldlWithIndex (MapRecord a b) (Builder {} {}) { | rin } (Builder {} { | rout })
  => (a -> b)
  -> { | rin }
  -> { | rout }
mapRecord f =
  (flip Builder.build {})
    <<< hfoldlWithIndex (MapRecord f :: MapRecord a b) (identity :: Builder {} {})
