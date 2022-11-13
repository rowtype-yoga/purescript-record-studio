# purescript-record-studio 📀📀📀

You finally scored a record deal.

## Usage guide

### Assert two records have the same keys with `SameKeys`

```purescript
-- An example of a function that requires `{|r1}` and `{|r2}` to have the same keys
sameKeys :: forall r1 r2. SameKeys r1 r2 => {|r1} -> {|r2} -> Unit
sameKeys _ _ = unit
let _ = sameKeys { b: "hi", a: 4, c: 4 } { b: "hu", a: "ha" }
-- Won't compile: The key "c" is missing from the second record
```

### Merge records with `//`
Easily merge two records:

```purescript
{ a: 5, b: "B" } // { b: false, c: "c" }
-- { a: 5, b: false, c: "c" }
```

This is similar to the `...` operator in ES6:

PureScript:
```purescript
import Record.Studio ((//))
rec1 = { a: 1 }
rec2 = { b: 4, c: 8 }
result = rec1 // rec2
```

JS:
```js
const rec1 = { a: 1 }
const rec2 = { b: 4, c: 8 }
const result = { ...rec1, ...rec2 }
```

### Shrink records with `shrink`
Easily adjust a record with too many keys:
```purescript
import Record.Studio (shrink)
-- We want to call this
-- fn :: { a :: Int } -> Int

-- We have this
myRec :: { a :: Int, b :: String }
myRec = { a: 4, b: "Hello!" }

-- Use shrink!
result = fn (shrink myRec)
```

### Get a record's keys at runtime with `keys`
```purescript
import Record.Studio (keys)

theKeys :: Array String
theKeys = keys { a: 3, b: "ooh" }
-- ["a", "b"]
```

### `sequenceRecord`
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
(sequenceRecord input) `shouldEqual` expected
```

### `mapUniformRecord`

Recursively map a function over a record where all entries have the same value.
This is often better at type inference than `mapRecord`
```purescript
  (mapUniformRecord (_ + 1) { a: 1, b: 2 }) `shouldEqual` { a: 2, b: 3}
```

### `mapRecord`

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
(mapRecord f input) `shouldEqual` expected
```

### `mapRecordKind`

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
(mapRecordKind nt input) `shouldEqual` expected
```

### `key` 

Get the only field name of a Record with one field as a `Proxy`

```purescript
SingletonRecord.key { foo: unit } `shouldEqual` (Proxy :: Proxy "foo")
```

## Licence
This is a fork of [heterogeneous-extrablatt](https://github.com/sigma-andex/purescript-heterogeneous-extrablatt), which is licenced under MIT. See the [original licence](./LICENCES/heterogeneous-extrablatt.LICENCE). This work is similarly licenced under [MIT](./LICENCE).
It includes part of [`purescript-record-extra`](https://github.com/justinwoo/purescript-record-extra) as an inline dependency, which is licenced under MIT, see [original licence](./LICENCES/record-extra.LICENCE).
