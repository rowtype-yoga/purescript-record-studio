module Extrablatt.Heterogeneous.Heterogeneous where

import Prelude
import Data.Symbol (class IsSymbol)
import Heterogeneous.Folding (class FoldingWithIndex, class FoldlRecord, class HFoldlWithIndex, hfoldlWithIndex)
import Prim.Row as Row
import Prim.RowList (class RowToList)
import Record.Builder (Builder)
import Record.Builder as Builder
import Type.Proxy (Proxy)

-- Helper for type inference
data HSequenceRec (f :: Type -> Type)
  = HSequenceRec

-- Matches if the type of the current field in the record is f a and therefore needs to be sequenced. 
instance hsequenceRec_1 ::
  ( Applicative f
  , IsSymbol sym
  , Row.Lacks sym rb
  , Row.Cons sym a rb rc
  ) =>
  FoldingWithIndex
    (HSequenceRec f)
    (Proxy sym)
    (f (Builder { | ra } { | rb }))
    (f a)
    (f (Builder { | ra } { | rc })) where
  foldingWithIndex _ prop rin a = (>>>) <$> rin <*> (Builder.insert prop <$> a)

-- Matches if the type of the current field in the record is another record and therefore needs to be recursed.
else instance hsequenceRec_2 ::
  ( Applicative f
  , IsSymbol sym
  , Row.Lacks sym rb
  , RowToList x xRL
  , Row.Cons sym { | y } rb rc
  , FoldlRecord
      (HSequenceRec f)
      (f (Builder (Record ()) (Record ())))
      xRL
      x
      (f (Builder (Record ()) (Record y)))
  ) =>
  FoldingWithIndex
    (HSequenceRec f)
    (Proxy sym)
    (f (Builder { | ra } { | rb }))
    { | x }
    (f (Builder { | ra } { | rc })) where
  foldingWithIndex _ prop rin x = (>>>) <$> rin <*> (fx <#> Builder.insert prop)
    where
    fx = hsequenceRec x

-- Matches if the type of the current field in the record is any other type independent of sequencing.
else instance hsequenceRec_3 ::
  ( Applicative f
  , IsSymbol sym
  , Row.Lacks sym rb
  , Row.Cons sym x rb rc
  ) =>
  FoldingWithIndex
    (HSequenceRec f)
    (Proxy sym)
    (f (Builder { | ra } { | rb }))
    x
    (f (Builder { | ra } { | rc })) where
  foldingWithIndex _ prop rin x = (_ >>> Builder.insert prop x) <$> rin

-- | Recursively sequence a record. E.g.
-- | ```purescript
-- | hsequenceRec { a : { b : { c : { d: Just 10, e : Just "hello" }, f : Just true } 
-- | -- Just { a : { b : { c : { d: 10, e : "hello" }, f : true }
-- | ```
hsequenceRec ::
  forall f rin rout.
  Applicative f =>
  HFoldlWithIndex (HSequenceRec f) (f (Builder {} {})) { | rin } (f (Builder {} { | rout })) =>
  { | rin } ->
  f { | rout }
hsequenceRec =
  map (flip Builder.build {})
    <<< hfoldlWithIndex (HSequenceRec :: HSequenceRec f) (pure identity :: f (Builder {} {}))

-- Helper for type inference
data HMapRec a b
  = HMapRec (a -> b)

-- Matches if the type of the current field in the record is a and therefore needs to be mapped. 
instance hmapRec_1 ::
  ( IsSymbol sym
  , Row.Lacks sym rb
  , Row.Cons sym b rb rc
  ) =>
  FoldingWithIndex
    (HMapRec a b)
    (Proxy sym)
    (Builder { | ra } { | rb })
    a
    (Builder { | ra } { | rc }) where
  foldingWithIndex (HMapRec f) prop rin a = (rin >>> Builder.insert prop (f a))

-- Matches if the type of the current field in the record is another record and therefore needs to be recursed.
else instance hmapRec_2 ::
  ( IsSymbol sym
  , Row.Lacks sym rb
  , RowToList x xRL
  , Row.Cons sym { | y } rb rc
  , FoldlRecord
      (HMapRec a b)
      (Builder (Record ()) (Record ()))
      xRL
      x
      (Builder (Record ()) (Record y))
  ) =>
  FoldingWithIndex
    (HMapRec a b)
    (Proxy sym)
    (Builder { | ra } { | rb })
    { | x }
    (Builder { | ra } { | rc }) where
  foldingWithIndex (HMapRec f) prop rin x = (rin >>> Builder.insert prop fx)
    where
    fx = hmapRec f x

-- Matches if the type of the current field in the record is any other type independent of mapping.
else instance hmapRec_3 ::
  ( IsSymbol sym
  , Row.Lacks sym rb
  , Row.Cons sym x rb rc
  ) =>
  FoldingWithIndex
    (HMapRec a b)
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
-- | hmapRec  f { a : { b : 10, c : { d: 20, e : Just "hello" }}, f : 30 }
-- | -- { a : { b : "11", c : { d: "21", e : Just "hello" }, f : "31" }
-- | ```
hmapRec ::
  forall a b rin rout.
  HFoldlWithIndex (HMapRec a b) (Builder {} {}) { | rin } (Builder {} { | rout }) =>
  (a -> b) ->
  { | rin } ->
  { | rout }
hmapRec f =
  (flip Builder.build {})
    <<< hfoldlWithIndex (HMapRec f :: HMapRec a b) (identity :: Builder {} {})

-- Helper for type inference
data HMapKRec f g
  = HMapKRec (f ~> g)

-- Matches if the type of the current field in the record is f a and therefore needs to be naturally transformed. 
instance hmapKRec_1 ::
  ( IsSymbol sym
  , Row.Lacks sym rb
  , Row.Cons sym (g a) rb rc
  ) =>
  FoldingWithIndex
    (HMapKRec f g)
    (Proxy sym)
    (Builder { | ra } { | rb })
    (f a)
    (Builder { | ra } { | rc }) where
  foldingWithIndex (HMapKRec nt) prop rin fa = (rin >>> Builder.insert prop (nt fa))

-- Matches if the type of the current field in the record is another record and therefore needs to be recursed.
else instance hmapKRec_2 ::
  ( IsSymbol sym
  , Row.Lacks sym rb
  , RowToList x xRL
  , Row.Cons sym { | y } rb rc
  , FoldlRecord
      (HMapKRec f g)
      (Builder (Record ()) (Record ()))
      xRL
      x
      (Builder (Record ()) (Record y))
  ) =>
  FoldingWithIndex
    (HMapKRec f g)
    (Proxy sym)
    (Builder { | ra } { | rb })
    { | x }
    (Builder { | ra } { | rc }) where
  foldingWithIndex (HMapKRec nt) prop rin x = (rin >>> Builder.insert prop fx)
    where
    fx = hmapKRec nt x

-- Matches if the type of the current field in the record is any other type independent of the natural transformation.
else instance hmapKRec_3 ::
  ( IsSymbol sym
  , Row.Lacks sym rb
  , Row.Cons sym x rb rc
  ) =>
  FoldingWithIndex
    (HMapKRec f g)
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
-- | hmapKRec { a : { b : { c : { d: Right 10, e : Left "hello" }, f : Right true }  
-- | -- Just { a : { b : { c : { d: Just 10, e : Nothing }, f : Just true }
-- | ```
hmapKRec ::
  forall f g rin rout.
  HFoldlWithIndex (HMapKRec f g) (Builder {} {}) { | rin } (Builder {} { | rout }) =>
  (f ~> g) ->
  { | rin } ->
  { | rout }
hmapKRec nt =
  (flip Builder.build {})
    <<< hfoldlWithIndex (HMapKRec nt :: HMapKRec f g) (identity :: Builder {} {})
