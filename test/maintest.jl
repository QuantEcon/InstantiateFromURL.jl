reponame = "arnavs/InstantiationTest"
tag1 = "master"
tag2 = "v0.1.0"
sha = "181f673" # 7 chars
pdir = pwd()

# Clean environment. 
isdir(".projects") == false || rm(".projects", recursive = true)

prefix, path = activate_github(reponame)
@test prefix == "master"
@test path == joinpath(pdir, ".projects", "InstantiationTest-master") 
@test Base.active_project() == joinpath(path, "Project.toml")

@warn "Shouldn't take too long on new precompilations, etc."
prefix, path = activate_github(reponame, tag = tag1)
@test prefix == "master"
@test path == joinpath(pdir, ".projects", "InstantiationTest-master") 
@test Base.active_project() == joinpath(path, "Project.toml")

prefix, path = activate_github(reponame, tag = tag2)
@test prefix == "v0.1.0"
@test path == joinpath(pdir, ".projects", "InstantiationTest-v0.1.0") 
@test Base.active_project() == joinpath(path, "Project.toml")

InstantiateFromURL.copy_env(reponame, "v0.1.0", "v0.1.0-edit")
prefix, path = activate_github(reponame, tag = "v0.1.0-edit")
@test prefix == "v0.1.0-edit"
@test path == joinpath(pdir, ".projects", "InstantiationTest-v0.1.0-edit") 
@test Base.active_project() == joinpath(path, "Project.toml")

prefix, path = activate_github(reponame, sha = sha)
@test prefix == sha
@test path == joinpath(pdir, ".projects", "InstantiationTest-$sha") 
@test Base.active_project() == joinpath(path, "Project.toml")
