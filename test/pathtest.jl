reponame = "QuantEcon/SimpleDifferentialOperators.jl"
path = "docs/notebooks"

# vanilla call
activate_github_path(reponame, path = path, activate = false)
@test "Project.toml" ∈ readdir()
@test "Manifest.toml" ∈ readdir()

# vanilla call repeated (should return 0)
@test_logs (:warn, "There's already a Project.toml in the current directory, and force = false.") activate_github_path(reponame, path = path, force = false, activate = false)

# clean
rm("Project.toml")
rm("Manifest.toml")

# error handling
@test_throws Exception activate_github_path(reponame * "flerg", path, force = false, activate = false)
@test_throws Exception activate_github_path(reponame, path = "src") # no TOML here
