module InstantiateFromURL

# Deps. `using BinaryProvider` needed to instantiate gen_ commands.
using Pkg, BinaryProvider, Suppressor
using HTTP # for activate_github_path
# TOML module
import Pkg.TOML: parsefile

# Code
include("activate.jl")

# Exports
export activate_github, activate_github_path
end
