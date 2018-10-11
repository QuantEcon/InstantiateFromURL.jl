
reponame = "QuantEcon/Expectations.jl"
version = "v1.0.1"
sha = "f039628e2b29e2183e8cf41422010d53e65e142c" # Arbitrary commit. 

activate_github(reponame)
activate_github(reponame, version = version)
activate_github(reponame, version = version, sha = sha)

@test 1 == 1 # Will run if the above things don't break. 