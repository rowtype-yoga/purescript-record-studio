module Record.Studio.SingletonRecord where

import Prelude

import Data.Symbol (class IsSymbol)
import Prim.Row as Row
import Prim.RowList (class RowToList)
import Prim.RowList as RL
import Prim.TypeError (class Fail, Text)
import Type.Proxy (Proxy(..))
import Unsafe.Coerce (unsafeCoerce)

class SingletonRecord :: forall k1 k2 k3. k1 -> k2 -> Row Type -> k3 -> Constraint
class SingletonRecord key value rec recRL | rec -> key value recRL where
  -- | Get the key of a record with only one field as a `Proxy`
  key :: Record rec -> Proxy key

instance
  ( RowToList rec recRL
  , SingletonRecordFields key a rec recRL
  ) =>
  SingletonRecord key a rec (RL.Cons key a RL.Nil) where
  key = singletonRecordFields (Proxy :: Proxy recRL)
else instance (Fail (Text "The record must have exactly one field")) => SingletonRecord key a rec recRL where
  key _ = unsafeCoerce unit

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
  ( Fail ErrorMsg
  ) =>
  SingletonRecordFields key a rec RL.Nil where
  singletonRecordFields _ _ = unsafeCoerce unit

else instance
  ( Fail ErrorMsg
  ) =>
  SingletonRecordFields key a rec (RL.Cons key a (RL.Cons key1 a1 rl)) where
  singletonRecordFields _ _ = unsafeCoerce unit

type ErrorMsg = (Text "The record provided to `key` must have exactly one field")
