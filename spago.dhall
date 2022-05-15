{ name = "heterogeneous-extrablatt"
, dependencies =
  [ "heterogeneous", "prelude", "record" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, license = "MIT-0"
, repository =
    "https://github.com/sigma-andex/purescript-heterogeneous-extrablatt.git"
}
