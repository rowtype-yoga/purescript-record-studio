module Heterogeneous.Extrablatt.RecSpec where

import Prelude

import Data.Either (Either(..), hush)
import Data.Maybe (Maybe(..))
import Heterogeneous.Extrablatt.Rec (hmapRec, hmapKRec, hsequenceRec)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

type SequenceInput
  = { a :: Maybe Int, b :: String, c :: { d :: Maybe String, e :: Boolean, f :: { g :: Maybe Boolean } }, h :: Int }

type SequenceOutput
  = { a :: Int, b :: String, c :: { d :: String, e :: Boolean, f :: { g :: Boolean } }, h :: Int }

type MapInput
  = { a :: Int, b :: String, c :: { d :: Maybe String, e :: Int, f :: { g :: Boolean, h :: Int } }, i :: Int }

type MapOutput
  = { a :: String, b :: String, c :: { d :: Maybe String, e :: String, f :: { g :: Boolean, h :: String } }, i :: String }

type MapKInput
  = { a :: Either String Int, b :: String, c :: { d :: Either String String, e :: Int, f :: { g :: Either String Boolean, h :: Either String Int } }, i :: Maybe Int }

type MapKOutput
  = { a :: Maybe Int, b :: String, c :: { d :: Maybe String, e :: Int, f :: { g :: Maybe Boolean, h :: Maybe Int } }, i :: Maybe Int }

spec :: Spec Unit
spec =
  describe "Heterogeneous.Extrablatt.Rec" do
    describe "hsequenceRec" do
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
        (hsequenceRec input) `shouldEqual` expected
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
        (hsequenceRec input) `shouldEqual` expected

    describe "hmapRec" do
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
        (hmapRec f input) `shouldEqual` expected
    describe "hmapKRec" do
      it "should recursively mapK a natural transformation over a record" do
        let
          input :: MapKInput
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

          expected :: MapKOutput
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
        (hmapKRec nt input) `shouldEqual` expected
