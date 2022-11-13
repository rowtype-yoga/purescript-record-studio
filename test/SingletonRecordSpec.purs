module SingletonRecordSpec where

import Prelude

import Record.Studio.SingletonRecord (key, value)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Type.Proxy (Proxy(..))

spec :: Spec Unit
spec =
  describe "key" do
    it "should get the only key of a singleton record as a `Proxy`" do
      let
        input = { a: 10 }

      -- | These should fail to compile with a helpful message
      -- inputFails1 = key {}
      -- inputFails2 = key { a: 10, b: "a" }
      -- inputFails3 = value {}
      -- inputFails4 = value { a: 10, b: "a" }

      (key input) `shouldEqual` (Proxy :: Proxy "a")
      (value input) `shouldEqual` 10
