module Record.Studio
  ( module Record.Studio.Sequence
  , module Record.Studio.Map
  , module Record.Studio.MapKind
  , module Record.Studio.MapUniform
  , module Record.Studio.Merge
  , module Record.Studio.Keys
  , module Record.Studio.Shrink
  , module Record.Studio.SameKeys
  , module Record.Studio.SingletonRecord
  ) where

import Record.Studio.Sequence (SequenceRecord(..), sequenceRecord)
import Record.Studio.Map (MapRecord(..), mapRecord)
import Record.Studio.MapKind (MapRecordKind(..), mapRecordKind)
import Record.Studio.MapUniform (class MapUniformRecord, mapUniformRecord, mapUniformRecordBuilder)
import Record.Studio.Keys (class Keys, keys, recordKeys)
import Record.Studio.Shrink (shrink)
import Record.Studio.Merge (mergeFlipped, (//))
import Record.Studio.SameKeys (class SameKeys)
import Record.Studio.SingletonRecord (class SingletonRecord, key, value)
