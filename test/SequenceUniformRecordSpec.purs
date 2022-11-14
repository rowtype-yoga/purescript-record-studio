module SequenceUniformRecordSpec where

import Prelude

import Data.Maybe (Maybe(..))
import Record.Studio.SequenceUniform (sequenceUniformRecord)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec =
  describe "sequenceUniformRecord" do
    it "should sequence an homogeneous record" do
      let input = { a: Just 4, b: Nothing :: Maybe String }
      sequenceUniformRecord input `shouldEqual` Nothing
    it "should sequence another homogeneous record" do
      let input = { a: Just 4, b: Just "a" }
      sequenceUniformRecord input `shouldEqual` (Just { a: 4, b: "a" })
