function activate_github(reponame; version = nothing, sha = nothing, force = false)
    # Make sure that our .projects environment is kosher. 
        projdir = joinpath(pwd(), ".projects") # DEPOT_PATH[1] is our .julia 
        mkpath(projdir)     
    # For each case of inputs, end up with a concrete URL to download. 
        if sha != nothing 
            length(sha) == 40 || throw(ArgumentError("Hash needs to be a 40-character string/hexadecimal number.")) # Check that it's a valid SHA1 hash. 
            oursha = sha 
        elseif version != nothing # Given a version but no SHA. 
            tagobj = tag(reponame, version)
            oursha = tagobj.object["sha"]
        else # Download master.
            oursha = branch(reponame, "master").commit.sha
        end 
    # Check if the version is already installed. If it is, skip download unless we force. 
        repostr = split(reponame, "/")[2] # This refers to a git path, not anything local. 
        ourdir = joinpath(projdir, "$repostr-$oursha")
        if isdir(ourdir) == false || force == true 
        # Turn this into a url. 
            oururl = "https://github.com/$(reponame)/archive/$(oursha).tar.gz"
        # Download that url to projects and unzip. 
            tarpath = joinpath(projdir, "$oursha.tar.gz")
            run(gen_download_cmd(oururl, tarpath))
            run(gen_unpack_cmd(tarpath, projdir)) # Will have package name. 
        # Remove the tarball. 
            rm("$projdir/$oursha.tar.gz")
            Pkg.activate(ourdir)
            pkg"instantiate" 
            pkg"precompile"
        else 
            Pkg.activate(ourdir)
        end 
    # Return some objects. 
        return oursha, ourdir 
end 