module InstantiateFromURL

# Deps. `using BinaryProvider` needed to instantiate gen_ commands. 
using Pkg, BinaryProvider, Suppressor
using TOML 

# Code
include("activate.jl")

# Exports
export activate_github

end
