
reponame = "arnavs/InstantiationTest"
version = "v0.1.0"
sha = "2d1291c4372c1d1a41f655292f60e1c5b8d5af57" # Arbitrary commit. 

isdir(".projects") == false || rm(".projects", recursive = true) # Clean the environment before testing. 

# Test master branch success
oursha, ourdir = activate_github(reponame)
@test Base.active_project() == joinpath(ourdir, "Project.toml") 
@test oursha == branch(reponame, "master").commit.sha 

# Test version 
oursha, ourdir = activate_github(reponame, version = version)
@test Base.active_project() == joinpath(ourdir, "Project.toml") 
@test oursha == tag(reponame, version).object["sha"]

# Test sha 
oursha, ourdir = activate_github(reponame, sha = sha)
@test Base.active_project() == joinpath(ourdir, "Project.toml")
@test oursha == sha

# Test error handling 
@warn "Should see a URL not found here"
@test_throws ArgumentError activate_github(reponame, version = version, sha = sha)
@test_throws ErrorException activate_github(reponame, sha = "2d1291c4372c1d1a41f655292f60e1c5b8d5af58") # Wrong SHA. 
@test_throws ErrorException activate_github(reponame, version = "v2.0.3") # Version not found. 
@test_throws ErrorException activate_github("arnavs/InstantiationTests", version = "v0.1.0") # Misspelled repo. 

# Test forcing (should visibly see a new install)
@warn "Forcing beginning now; should see a new install"
oursha, ourdir = activate_github(reponame, force = true)
@test Base.active_project() == joinpath(ourdir, "Project.toml") 
@test oursha == branch(reponame, "master").commit.sha 

# Activation (should not see a new install)
@warn "Activating existing environment; should not see a new install"
activate_github(reponame)
@test Base.active_project() == joinpath(ourdir, "Project.toml") 
@test oursha == branch(reponame, "master").commit.sha 
