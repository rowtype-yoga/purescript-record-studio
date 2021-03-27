{ name = "purescript-heterogeneous-extrablatt"
, dependencies =
  [ "console"
  , "effect"
  , "heterogeneous"
  , "psci-support"
  , "spec"
  , "spec-discovery"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
, license = "MIT-0"
, repository = "https://github.com/sigma-andex/purescript-heterogeneous-extrablatt.git"
}
