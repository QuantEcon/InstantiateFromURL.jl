module InstantiateFromURL

# Deps 
using Pkg, GitHub, HTTP, JSON
using BinaryProvider # Important to instantiate the gen_ commands. 

# Code
include("activate.jl")

# Exports
export activate_github

end
