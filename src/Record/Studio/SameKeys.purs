module Record.Studio.SameKeys (class SameKeys, class SameKeysRL) where

import Data.Symbol (class IsSymbol)
import Prim.Row (class Lacks)
import Prim.RowList (class RowToList)
import Prim.RowList as RL
import Prim.TypeError (class Fail, Beside, Quote, Text)
import Type.RowList (class ListToRow)

class SameKeys (r1 :: Row Type) (r2 :: Row Type)

instance (RowToList r1 rl1, RowToList r2 rl2, SameKeysRL rl1 rl2) => SameKeys r1 r2

class SameKeysRL (xs :: RL.RowList Type) (ys :: RL.RowList Type)

instance SameKeysRL RL.Nil RL.Nil
instance
  ( IsSymbol name
  , SameKeysRL tail1 tail2
  ) =>
  SameKeysRL (RL.Cons name ty1 tail1) (RL.Cons name ty2 tail2)
else instance
  ( ListToRow RL.Nil r
  , Fail (Beside (Text "The key ") (Beside (Quote name) (Text " is missing from the second record")))
  ) =>
  SameKeysRL (RL.Cons name ty tail) RL.Nil
else instance
  ( ListToRow RL.Nil r
  , Fail (Beside (Text "The key ") (Beside (Quote name) (Text " is missing from the first record")))
  ) =>
  SameKeysRL RL.Nil (RL.Cons name ty tail)
else instance
  ( ListToRow (RL.Cons name2 ty1 tail1) r
  , Lacks name1 r
  , Fail (Beside (Text "The key ") (Beside (Quote name1) (Text " is missing from the second record")))
  ) =>
  SameKeysRL (RL.Cons name1 ty1 tail1) (RL.Cons name2 ty2 tail2)
else instance
  ( ListToRow (RL.Cons name1 ty1 tail1) r
  , Lacks name2 r
  , Fail (Beside (Text "The key ") (Beside (Quote name2) (Text " is missing from the first record")))
  ) =>
  SameKeysRL (RL.Cons name1 ty1 tail1) (RL.Cons name2 ty2 tail2)
