module Record.Studio
  ( module Record.Studio.Sequence
  , module Record.Studio.Map
  , module Record.Studio.MapKind
  , module Record.Studio.Merge
  , module Record.Studio.Keys
  , module Record.Studio.Shrink
  ) where

import Record.Studio.Sequence (SequenceRecord(..), sequenceRecord)
import Record.Studio.Map (MapRecord(..), mapRecord)
import Record.Studio.MapKind (MapRecordKind(..), mapRecordKind)
import Record.Studio.Keys (class Keys, recordKeys)
import Record.Studio.Shrink (shrink)
import Record.Studio.Merge (mergeFlipped, (//))
