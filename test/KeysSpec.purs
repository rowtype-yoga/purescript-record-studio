module KeysSpec where

import Prelude

import Record.Studio (recordKeys)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec =
  describe "keys" do
    it "gets the keys of {}" do
      recordKeys {} `shouldEqual` []
    it "gets the keys of { a :: String }" do
      recordKeys { a: "" } `shouldEqual` [ "a" ]
    it "gets the keys of { a :: String, b :: Int }" do
      recordKeys { a: "", b: 1 } `shouldEqual` [ "a", "b" ]
