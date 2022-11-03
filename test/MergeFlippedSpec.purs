module MergeFlippedSpec where

import Prelude

import Record.Studio ((//))
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec =
  describe "Record Operations" do
    describe "mergeFlipped (//)" do
      it "should merge disjoint records" do
        ({ a: 1, b: 2 } // { c: 3 }) `shouldEqual` { a: 1, b: 2, c: 3 }
      it "should prioritise the right-hand-side" do
        ({ a: 1, b: 2 } // { b: 3 }) `shouldEqual` { a: 1, b: 3 }
      it "should prioritise the right-hand-side type" do
        ({ a: 1, b: 2 } // { b: "a" }) `shouldEqual` { a: 1, b: "a" }
      it "should work with larger records" do
        ({ a: 1, b: 2 } // { c: 3, d: 4 }) `shouldEqual` { a: 1, b: 2, c: 3, d: 4 }
