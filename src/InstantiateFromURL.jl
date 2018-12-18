module InstantiateFromURL

# Deps. `using BinaryProvider` needed to instantiate gen_ commands.
using Pkg, BinaryProvider, Suppressor

# TOML module
TOMLpath = joinpath(dirname(Sys.BINDIR), "share", "julia", "stdlib", "v1.0", "Pkg", "ext", "TOML")
include(joinpath(TOMLpath, "src", "TOML.jl"))

# Code
include("activate.jl")

# Exports
export activate_github

end
