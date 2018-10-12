
reponame = "QuantEcon/QuantEconLecturePackages"
version = "v0.1.0"
sha = "12bd6847559b79d29bd9cdcd3d4e841bc90bc19f" # Arbitrary commit. 

activate_github(reponame)
activate_github(reponame, version = version)
activate_github(reponame, version = version, sha = sha)

@test 1 == 1 # Will run if the above things don't break. 
@test_throws ArgumentError activate_github(reponame, sha = "12bd6847559b79d29bd9cdcd3d4e841bc90bc19") # Wrong length. 
@test_throws ErrorException activate_github(reponame, sha = "13bd6847559b79d29bd9cdcd3d4e841bc90bc19f") # Wrong SHA. 
@test_throws ErrorException activate_github(reponame, version = "v2.0.3") # Version not found. 
@test_throws ErrorException activate_github("QuantEcon/QuantEconLecturePackagess", version = "v0.1.0") # Misspelled repo. 