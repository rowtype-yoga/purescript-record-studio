module Record.Studio.SingletonRecord
  ( class SingletonRecord
  , class SingletonRecordFields
  , key
  , value
  , singletonRecordFields
  ) where

import Prelude

import Data.Symbol (class IsSymbol)
import Prim.Row as Row
import Prim.RowList (class RowToList)
import Prim.RowList as RL
import Prim.TypeError (class Fail, Beside, Quote, QuoteLabel, Text)
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

class SingletonRecord :: forall k1 k2. k1 -> Type -> Row Type -> k2 -> Constraint
class SingletonRecord key value rec recRL | rec -> key value recRL where
  -- | Get the key of a record with only one field as a `Proxy`
  key :: Record rec -> Proxy key
  value :: Record rec -> value

foreign import unsafeGetFirstField :: forall r a. { | r } -> a

instance
  ( RowToList rec recRL
  , SingletonRecordFields key a rec recRL
  ) =>
  SingletonRecord key a rec rl where
  key = singletonRecordFields (Proxy :: Proxy recRL)
  value = unsafeGetFirstField
else instance (Fail (Text "The record must have exactly one field")) => SingletonRecord key a rec recRL where
  key _ = unsafeCoerce unit
  value _ = unsafeCoerce unit

class SingletonRecordFields :: forall k1 k2. k1 -> Type -> Row Type -> k2 -> Constraint
class
  SingletonRecordFields key value rec recRL
  | rec -> key value
  where
  singletonRecordFields :: Proxy recRL -> { | rec } -> Proxy key

instance
  ( RowToList rec (RL.Cons key a RL.Nil)
  , Row.Cons key a () rec
  , IsSymbol key
  ) =>
  SingletonRecordFields key a rec (RL.Cons key a RL.Nil) where
  singletonRecordFields _ _ = (Proxy :: Proxy key)

instance
  ( Fail (Beside ErrorMsg (Text "instead of {}"))
  ) =>
  SingletonRecordFields key a rec RL.Nil where
  singletonRecordFields _ _ = unsafeCoerce unit

else instance
  ( Fail
      ( ErrorMsg
          ++ ButReceivedStart
          ++ (QuoteLabel key ++ DblCol ++ Quote a)
          ++ Comma
          ++ (QuoteLabel key1 ++ DblCol ++ Quote a1)
          ++ ButReceivedEnd
      )
  ) =>
  SingletonRecordFields key a rec (RL.Cons key a (RL.Cons key1 a1 rl)) where
  singletonRecordFields _ _ = unsafeCoerce unit

type ErrorMsg = (Text "Must provide a record with exactly one field ")
type ButReceivedStart = (Text "instead of { ")
type ButReceivedEnd = (Text ", ... }")
type DblCol = (Text " :: ")
type Comma = (Text ", ")

infixl 3 type Beside as ++
