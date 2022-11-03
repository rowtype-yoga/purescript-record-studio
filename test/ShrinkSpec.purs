module ShrinkSpec where

import Prelude

import Foreign.Object as Object
import Record.Studio (shrink)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Unsafe.Coerce (unsafeCoerce)

spec :: Spec Unit
spec =
  describe "shrink" do
    it "shrinks down records all the way" do
      shrink { a: 1, b: 2, c: "c" } `shouldEqual` {}
    it "shrinks down records a bit" do
      shrink { a: 1, b: 2, c: 3, d: 4 } `shouldEqual` { a: 1, b: 2, c: 3 }
    it "shrinks to the correct runtime representation" do
      let
        shrunk :: { c :: Int, e :: Int }
        shrunk = shrink { a: 1, b: 2, c: 3, d: 4, e: 5 }
      unsafeCoerce shrunk `shouldEqual` Object.fromHomogeneous { c: 3, e: 5 }
    it "shrinks heterogeneous records" do
      shrink { a: "a", b: { e: 4 }, c: false } `shouldEqual` { c: false }
