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
, repo = "https://github.com/sigma-andex/purescript-heterogeneous-extrablatt.git"
}
