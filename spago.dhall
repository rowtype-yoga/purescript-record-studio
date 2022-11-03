{ name = "record-studio"
, dependencies = [ "heterogeneous", "lists", "prelude", "record" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "MIT-0"
, repository =
    "https://github.com/rowtype-yoga/purescript-record-studio.git"
}
