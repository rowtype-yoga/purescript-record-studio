module SequenceRecordSpec where

import Prelude

import Data.Maybe (Maybe(..))
import Record.Studio (sequenceRecord)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

type SequenceInput = { a :: Maybe Int, b :: String, c :: { d :: Maybe String, e :: Boolean, f :: { g :: Maybe Boolean } }, h :: Int }

type SequenceOutput = { a :: Int, b :: String, c :: { d :: String, e :: Boolean, f :: { g :: Boolean } }, h :: Int }

spec :: Spec Unit
spec =
  describe "sequenceRecord" do
    it "should recursively sequence a valid record" do
      let
        input :: SequenceInput
        input =
          { a: Just 10
          , b: "hello"
          , c:
              { d: Just "world"
              , e: true
              , f: { g: Just true }
              }
          , h: 10
          }

        expected :: Maybe SequenceOutput
        expected = Just
          { a: 10
          , b: "hello"
          , c:
              { d: "world"
              , e: true
              , f: { g: true }
              }
          , h: 10
          }
      (sequenceRecord input) `shouldEqual` expected
    it "should recursively sequence an invalid record" do
      let
        input :: SequenceInput
        input =
          { a: Just 10
          , b: "hello"
          , c:
              { d: Just "world"
              , e: true
              , f: { g: Nothing }
              }
          , h: 10
          }

        expected :: Maybe SequenceOutput
        expected = Nothing
      (sequenceRecord input) `shouldEqual` expected
