# Standard deps.
using InstantiateFromURL, Test, Pkg

# TOML deps.
import Pkg.TOML: parsefile

@testset "Main Tests" begin include("maintest.jl") end # arnavs/InstantationTest
@testset "TOML Tests" begin include("tomltest.jl") end
