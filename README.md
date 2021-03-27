# purescript-heterogeneous-extrablatt 📰

Some additions of common use-cases when working with records and purescript-heterogeneous.


## Usage guide 


### `hsequenceRec`
Recursively sequence a type constructor out of a record.

```purescript
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
```

### `hmapRec`

Recursively map a function over a record. 
```purescript
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
```

### `hmapKRec`

Recursively map a natural transformation over a record.

```purescript 
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
```
