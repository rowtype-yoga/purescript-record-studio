module SameKeysSpec where

import Prelude

import Record.Studio.SameKeys (class SameKeys)
import Test.Spec (Spec, describe, it)

spec :: Spec Unit
spec =
  describe "same keys" do
    it "asserts the same keys" do
      -- let _ = sameKeys { b: "hi", a: 4, c: 4 } { b: "hu", a: "ha" }
      -- The key "c" is missing from the second record

      -- let _ = sameKeys { b: "hi", a: 4 } { b: "hu", a: "ha", c: 4 }
      -- The key "c" is missing from the first record

      -- let _ = sameKeys { b: "hi", a: 4 } { b: "hu" }
      -- The key "a" is missing from the second record

      -- let _ = sameKeys { b: "hi", a: 4 } { b: "hu" }
      -- The key "a" is missing from the second record

      let _ = sameKeys { b: "hi", z: 1 } { z: "", b: { c: false } }
      pure unit

sameKeys :: forall r1 r2. SameKeys r1 r2 => {|r1} -> {|r2} -> Unit
sameKeys _ _ = unit
