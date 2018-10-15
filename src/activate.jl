function activate_github(reponame; tag = nothing, sha = nothing, force = false)
    # Make sure that our .projects environment is kosher. 
    projdir = joinpath(pwd(), ".projects") 
    mkpath(projdir) 
    # For each case of inputs, end up with a concrete URL to download. 
    if sha != nothing 
        length(sha) >= 6 || throw(ArgumentError("SHA needs to be at least 6 characters."))
        tag == nothing || throw(ArgumentError("You can't give both a tag and an SHA hash."))
        tarprefix = sha   
    elseif tag != nothing # Given a version but no SHA. 
        tarprefix = tag
    else # Default to master if nothing is given. 
        tarprefix = "master"
    end 
    # Common objects for all cases. 
    repostr = split(reponame, "/")[2] 
    target = joinpath(projdir, "$repostr-$tarprefix") 
    # Branches of logic. 
    if isdir(target) && tarprefix != "master" && force == false # Static prefix that's already downloaded, no force. 
        Pkg.activate(target)
    else 
        # Download the tarball. 
        tarurl = "https://github.com/$(reponame)/archive/$(tarprefix).tar.gz"
        tarpath = joinpath(projdir, "$repostr-$tarprefix.tar.gz") 
        printstyled("Downloading ", bold=true, color=:light_green); println("$reponame-$tarprefix → $projdir")
        run(gen_download_cmd(tarurl, tarpath)) # Download the tarball. 
        # Unpack the tarball to a tmp directory. 
        tmpdir = joinpath(projdir, "tmp")
        mkpath(tmpdir)
        @suppress_out begin run(gen_unpack_cmd(tarpath, tmpdir)) end
        # Move the tmp directory to the target. 
        subtmpdir = readdir(tmpdir)[1] # Has only one subdirectory. 
        mv("$tmpdir/$subtmpdir", target, force = true) # Force will overwrite existing dir. 
        # Clean. 
        rm(tarpath)
        rm(tmpdir)
        # Instantiate and precompile.
        printstyled("Instantiating ", bold=true, color=:light_green); println(target)
        Pkg.activate(target)
        pkg"instantiate"
        pkg"precompile"
    end 
    tarprefix, target
end 

function copy_env(reponame, oldtag, newtag)
    repostr = split(reponame, "/")[2]
    projdir = joinpath(pwd(), ".projects")
    olddir = joinpath(projdir, "$repostr-$oldtag")
    newdir = joinpath(projdir, "$repostr-$newtag")
    cp(olddir, newdir, force = true)
end 