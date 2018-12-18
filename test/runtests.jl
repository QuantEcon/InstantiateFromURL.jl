# Standard deps.
using InstantiateFromURL, Test, Pkg

# TOML deps.
TOMLpath = joinpath(dirname(Sys.BINDIR), "share", "julia", "stdlib", "v1.0", "Pkg", "ext", "TOML")
include(joinpath(TOMLpath, "src", "TOML.jl"))

@testset "Main Tests" begin include("maintest.jl") end # arnavs/InstantationTest
@testset "TOML Tests" begin include("tomltest.jl") end
