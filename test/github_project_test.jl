github_project("QuantEcon/InstantiateFromURL.jl", version = "0.3.0")
ctx = Pkg.Types.Context().env;
@test dirname(ctx.project_file) == pwd()
@test dirname(ctx.manifest_file) == pwd()
@test Pkg.TOML.parsefile(ctx.project_file)["name"] == "InstantiateFromURL"
@test Pkg.TOML.parsefile(ctx.project_file)["version"] == "0.3.0"
packages_to_default_environment() # tests will fail if this fails 

rm("Project.toml")
rm("Manifest.toml")

# with force 
github_project("QuantEcon/InstantiateFromURL.jl", version = "master", force = true)
ctx = Pkg.Types.Context().env;
@test dirname(ctx.project_file) == pwd()
@test dirname(ctx.manifest_file) == pwd()

rm("Project.toml")
rm("Manifest.toml")
