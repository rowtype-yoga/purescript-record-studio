module MapRecordSpec where

import Prelude

import Data.Maybe (Maybe(..))
import Record.Studio (mapRecord)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

type MapInput = { a :: Int, b :: String, c :: { d :: Maybe String, e :: Int, f :: { g :: Boolean, h :: Int } }, i :: Int }

type MapOutput = { a :: String, b :: String, c :: { d :: Maybe String, e :: String, f :: { g :: Boolean, h :: String } }, i :: String }

spec :: Spec Unit
spec =
  describe "mapRecord" do
    it "should recursively map a function over a record" do
      let
        input :: MapInput
        input =
          { a: 10
          , b: "hello"
          , c:
              { d: Just "world"
              , e: 20
              , f: { g: true, h: 30 }
              }
          , i: 40
          }

        f :: Int -> String
        f i = show (i + 1)

        expected :: MapOutput
        expected =
          { a: "11"
          , b: "hello"
          , c:
              { d: Just "world"
              , e: "21"
              , f: { g: true, h: "31" }
              }
          , i: "41"
          }
      (mapRecord f input) `shouldEqual` expected
