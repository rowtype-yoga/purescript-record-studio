module Record.Studio.Sequence where

import Prelude

import Data.Symbol (class IsSymbol)
import Heterogeneous.Folding (class FoldingWithIndex, class FoldlRecord, class HFoldlWithIndex, hfoldlWithIndex)
import Prim.Row as Row
import Prim.RowList (class RowToList)
import Record.Builder (Builder)
import Record.Builder as Builder
import Type.Proxy (Proxy)

-- Helper for type inference
data SequenceRecord (f :: Type -> Type) = SequenceRecord

-- Matches if the type of the current field in the record is f a and therefore needs to be sequenced.
instance
  ( Applicative f
  , IsSymbol sym
  , Row.Lacks sym rb
  , Row.Cons sym a rb rc
  ) =>
  FoldingWithIndex
    (SequenceRecord f)
    (Proxy sym)
    (f (Builder { | ra } { | rb }))
    (f a)
    (f (Builder { | ra } { | rc })) where
  foldingWithIndex _ prop rin a = (>>>) <$> rin <*> (Builder.insert prop <$> a)

-- Matches if the type of the current field in the record is another record and therefore needs to be recursed.
else instance
  ( Applicative f
  , IsSymbol sym
  , Row.Lacks sym rb
  , RowToList x xRL
  , Row.Cons sym { | y } rb rc
  , FoldlRecord
      (SequenceRecord f)
      (f (Builder (Record ()) (Record ())))
      xRL
      x
      (f (Builder (Record ()) (Record y)))
  ) =>
  FoldingWithIndex
    (SequenceRecord f)
    (Proxy sym)
    (f (Builder { | ra } { | rb }))
    { | x }
    (f (Builder { | ra } { | rc })) where
  foldingWithIndex _ prop rin x = (>>>) <$> rin <*> (fx <#> Builder.insert prop)
    where
    fx = sequenceRecord x

-- Matches if the type of the current field in the record is any other type independent of sequencing.
else instance
  ( Applicative f
  , IsSymbol sym
  , Row.Lacks sym rb
  , Row.Cons sym x rb rc
  ) =>
  FoldingWithIndex
    (SequenceRecord f)
    (Proxy sym)
    (f (Builder { | ra } { | rb }))
    x
    (f (Builder { | ra } { | rc })) where
  foldingWithIndex _ prop rin x = (_ >>> Builder.insert prop x) <$> rin

-- | Recursively sequence a record. E.g.
-- | ```purescript
-- | sequenceRecord { a : { b : { c : { d: Just 10, e : Just "hello" }, f : Just true }
-- | -- Just { a : { b : { c : { d: 10, e : "hello" }, f : true }
-- | ```
sequenceRecord
  :: forall f rin rout
   . Applicative f
  => HFoldlWithIndex (SequenceRecord f) (f (Builder {} {})) { | rin } (f (Builder {} { | rout }))
  => { | rin }
  -> f { | rout }
sequenceRecord =
  map (flip Builder.build {})
    <<< hfoldlWithIndex (SequenceRecord :: SequenceRecord f) (pure identity :: f (Builder {} {}))
