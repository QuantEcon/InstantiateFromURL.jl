# Standard deps.
using InstantiateFromURL, Test, Pkg

# TOML deps.
import Pkg.TOML: parsefile

@testset "Main Tests" begin include("maintest.jl") end
@testset "TOML Tests" begin include("tomltest.jl") end
@testset "Directory Names Tests" begin include("namestest.jl") end # same as maintest, but in a different directory
@testset "Test activate_github_path" begin include("pathtest.jl") end 
