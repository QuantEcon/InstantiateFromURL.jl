function activate_github(reponame; version = nothing, sha = nothing, force = false)
    # Make sure that our .projects environment is kosher. 
        projdir = joinpath(pwd(), ".projects") # DEPOT_PATH[1] is our .julia 
        mkpath(projdir) 
    # For each case of inputs, end up with a concrete URL to download. 
    if sha != nothing 
        length(sha) == 40 ? 0 : throw(ArgumentError("Hash needs to be a 40-character string/hexadecimal number.")) # Check that it's a valid SHA1 hash. 
        oursha = sha 
    elseif version != nothing # Given a version but no SHA. 
        tagobj = tag(reponame, version)
        oursha = tagobj.object["sha"]
    else # Download master.
        oursha = branch(reponame, "master").commit.sha
    end 
    # Turn this into a url. 
    oururl = "https://github.com/$(reponame)/archive/$(oursha).tar.gz"
    # Download that url to projects and unzip. 
    run(gen_download_cmd(oururl, "$projdir/$oursha.tar.gz"))
    run(gen_unpack_cmd("$projdir/$oursha.tar.gz", "$projdir")) # Will have package name. 
    # Remove the tarball. 
    rm("$projdir/$oursha.tar.gz")
end 