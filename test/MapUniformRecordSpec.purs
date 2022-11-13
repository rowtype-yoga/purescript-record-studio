module MapUniformRecordSpec where

import Prelude

import Record.Studio.MapUniform (mapUniformRecord)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec =
  describe "mapUniformRecord" do
    it "should map a function over a uniform record" do
      let
        input = { a: 10, b: 12 }

        f = (_ + 4)

        expected =
          { a: 14
          , b: 16
          }
      (mapUniformRecord f input) `shouldEqual` expected
