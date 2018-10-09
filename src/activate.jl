function activate(url, sha, location = ".projects")
    # directory where a package is going to be checkedout
    env = joinpath(@__DIR__, location, sha)

    # if the directory exists, assume it's been cloned, instantiated, and precompiled
    if (isdir(env)) 
        Pkg.activate(env)
    else
        # if not checkout, activate, instantiate, and precompile it
        mkpath(env) # make a dir
        LibGit2.clone(url, env)
        LibGit2.checkout!(LibGit2.GitRepo(env), sha, force = true)
        Pkg.activate(env)
        pkg"instantiate"
        pkg"precompile"
    end
end