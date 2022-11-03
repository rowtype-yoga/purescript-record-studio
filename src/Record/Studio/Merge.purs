module Record.Studio.Merge where

import Prelude

import Prim.Row (class Nub, class Union)
import Record (merge)

-- | Like `merge` but with its arguments flipped. I.e. merges two records with the seconds record's labels taking precedence in the
-- | case of overlaps.
-- |
-- | For example:
-- |
-- | ```purescript
-- | mergeFlipped { x: 1, y: "y" } { y: 2, z: true }
-- |  = { x: 1, y: 2, z: true }
-- | ```
mergeFlipped
  :: forall r1 r2 r3 r4
   . Union r1 r2 r3
  => Nub r3 r4
  => Record r2
  -> Record r1
  -> Record r4
mergeFlipped = flip merge

-- | `record1 // record2` is equivalent to JS's
-- | `{ ...record1, ...record2 }`
infixr 1 mergeFlipped as //
