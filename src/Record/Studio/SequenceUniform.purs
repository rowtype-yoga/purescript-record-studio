module Record.Studio.SequenceUniform where

import Prelude

import Data.Symbol (class IsSymbol)
import Prim.Row as Row
import Prim.RowList as RL
import Record as R
import Record.Builder (Builder)
import Record.Builder as Builder
import Type.Proxy (Proxy(..))

sequenceUniformRecord
  :: forall row row' rl m
   . RL.RowToList row rl
  => SequenceUniformRecord rl row () row' m
  => Record row
  -> m (Record row')
sequenceUniformRecord a = Builder.build <@> {} <$> builder
  where
  builder = sequenceUniformRecordImpl (Proxy :: _ rl) a

class
  Functor m <=
  SequenceUniformRecord (rl :: RL.RowList Type) row from to m
  | rl -> row from to m
  where
  sequenceUniformRecordImpl :: Proxy rl -> Record row -> m (Builder { | from } { | to })

instance
  ( IsSymbol name
  , Row.Cons name (m ty) trash row
  , Functor m
  , Row.Lacks name ()
  , Row.Cons name ty () to
  ) =>
  SequenceUniformRecord (RL.Cons name (m ty) RL.Nil) row () to m where
  sequenceUniformRecordImpl _ a =
    Builder.insert namep <$> valA
    where
    namep = Proxy :: _ name
    valA = R.get namep a

else instance
  ( IsSymbol name
  , Row.Cons name (m ty) trash row
  , Apply m
  , SequenceUniformRecord tail row from from' m
  , Row.Lacks name from'
  , Row.Cons name ty from' to
  ) =>
  SequenceUniformRecord (RL.Cons name (m ty) tail) row from to m where
  sequenceUniformRecordImpl _ a =
    fn <$> valA <*> rest
    where
    namep = Proxy :: _ name
    valA = R.get namep a
    tailp = Proxy :: _ tail
    rest = sequenceUniformRecordImpl tailp a
    fn valA' rest' = Builder.insert namep valA' <<< rest'

instance Applicative m => SequenceUniformRecord RL.Nil row () () m where
  sequenceUniformRecordImpl _ _ = pure identity
