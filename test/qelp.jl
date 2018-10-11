
reponame = "QuantEcon/QuantEconLecturePackages"
version = "v0.1.0"
sha = "c97915098580a8999a99a7e1df4be805a3aaa289" # Arbitrary commit. 

activate_github(reponame)
activate_github(reponame, version = version)
activate_github(reponame, version = version, sha = sha)

@test 1 == 1 # Will run if the above things don't break. 
@test_throws AssertionError activate_github(reponame, sha = "c97915098580a8999a99a7e1df4be805a3aaa28") # Wrong length. 
@test_throws ErrorException activate_github(reponame, sha = "c98915098580a8999a99a7e1df4be805a3aaa289") # Wrong SHA. 
@test_throws ErrorException activate_github(reponame, version = "v2.0.3") # Version not found. 
@test_throws ErrorException activate_github("QuantEcon/QuantEconLecturePackagess", version = "v0.1.0") # Misspelled repo. 