module SingletonRecordSpec where

import Prelude

import Record.Studio.SingletonRecord (key)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Type.Proxy (Proxy(..))

spec :: Spec Unit
spec =
  describe "key" do
    it "should get the only key of a singleton record as a `Proxy`" do
      let
        input = { a: 10 }

        -- inputFails1 = key {}
        -- ^ The record provided to `key` must have exactly one field
        -- inputFails2 = key { a: 10, b: "a" }
        -- ^ The record provided to `key` must have exactly one field
        expected = Proxy :: Proxy "a"

      (key input) `shouldEqual` expected
