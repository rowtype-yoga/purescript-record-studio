module MapRecordKindSpec where

import Prelude

import Data.Either (Either(..), hush)
import Data.Maybe (Maybe(..))
import Record.Studio (mapRecordKind)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

type MapKindInput = { a :: Either String Int, b :: String, c :: { d :: Either String String, e :: Int, f :: { g :: Either String Boolean, h :: Either String Int } }, i :: Maybe Int }

type MapKindOutput = { a :: Maybe Int, b :: String, c :: { d :: Maybe String, e :: Int, f :: { g :: Maybe Boolean, h :: Maybe Int } }, i :: Maybe Int }

spec :: Spec Unit
spec =
  describe "mapRecordKind" do
    it "should recursively a natural transformation over a record" do
      let
        input :: MapKindInput
        input =
          { a: Right 10
          , b: "hello"
          , c:
              { d: Left "world"
              , e: 20
              , f: { g: Right true, h: Left "broken" }
              }
          , i: Just 40
          }

        nt :: Either String ~> Maybe
        nt = hush

        expected :: MapKindOutput
        expected =
          { a: Just 10
          , b: "hello"
          , c:
              { d: Nothing
              , e: 20
              , f: { g: Just true, h: Nothing }
              }
          , i: Just 40
          }
      (mapRecordKind nt input) `shouldEqual` expected
