using InstantiateFromURL, Test, Pkg
using TOML 

@testset begin include("maintest.jl") end # arnavs/InstantationTest
@testset begin include("tomltest.jl") end 
