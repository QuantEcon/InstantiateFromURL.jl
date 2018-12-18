module InstantiateFromURL

# Deps. `using BinaryProvider` needed to instantiate gen_ commands.
using Pkg, BinaryProvider, Suppressor
# TOML module
import Pkg.TOML: parsefile

# Code
include("activate.jl")

# Exports
export activate_github

end
