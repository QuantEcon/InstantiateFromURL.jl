module InstantiateFromURL

# Deps. `using BinaryProvider` needed to instantiate gen_ commands. 
using Pkg, GitHub, HTTP, JSON, BinaryProvider 

# Code
include("activate.jl")

# Exports
export activate_github

end
