function activate_github(reponame; tag = nothing, sha = nothing, force = false, add_default_environment = false)
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
        # Make a temporary directory for our use.
        tmpdir = tempdir()
        # Download the tarball to that directory.
        tarurl = "https://github.com/$(reponame)/archive/$(tarprefix).tar.gz"
        tarpath = joinpath(tmpdir, "$repostr-$tarprefix.tar.gz")
        printstyled("Downloading ", bold=true, color=:light_green); println("$reponame-$tarprefix → $projdir")
        try
            run(gen_download_cmd(tarurl, tarpath)) # Download the tarball.
        catch e
            if e isa MethodError
                printstyled("Package installation and activation not supported in this setup. You should add packages manually.", bold = true, color = :red)
                return nothing
            else
                throw(e)
            end
        end
        # Unpack the tarball to that directory.
        run(gen_unpack_cmd(tarpath, tmpdir))
        # Remove the tarball to avoid path conflict with the next steps.
        rm(tarpath)
        # Find the path of the unpacked tarball (could be a full SHA)
        sourcedir = filter(object -> occursin("$repostr", object), readdir(tmpdir))[1] # There will only be one of these.
        # Move to .projects
        mv(joinpath(tmpdir, sourcedir), target, force = true) # Force will overwrite existing dir.
        # Clean.
        isdir(joinpath(tmpdir, sourcedir)) == false || rm(joinpath(tmpdir, sourcedir), recursive = true) # Important for logic.
        # Instantiate and precompile.
        printstyled("Instantiating ", bold=true, color=:light_green); println(target)
        Pkg.activate(target)
        pkg"instantiate"
        pkg"precompile"
    end
    projpath = joinpath(target, "Project.toml")
    packages = parsefile(projpath)["deps"]
    if add_default_environment # seed the default environment with the new packages if true
        printstyled("Adding to the default environment... ", bold=true, color=:light_green);
        pkg"activate "
        @show pkglist = Array{String}(collect(keys(packages)))
        Pkg.add(pkglist)
        Pkg.activate(target) # go back to the activated environment
    end
    tarprefix, target, packages
end

function copy_env(reponame, oldtag, newtag)
    repostr = split(reponame, "/")[2]
    projdir = joinpath(pwd(), ".projects")
    olddir = joinpath(projdir, "$repostr-$oldtag")
    newdir = joinpath(projdir, "$repostr-$newtag")
    cp(olddir, newdir, force = true)
end

# Clone the TOML files from some git repo's _current state_ to the local dir
function activate_github_path(reponame; path = "", 
                                tag = "master",
                                force = false, 
                                activate = true)
    # conditions for a no-op exit 
    need_activation = (Base.active_project() != joinpath(pwd(), "Project.toml"))
    if "Project.toml" ∈ readdir(pwd()) && force == false 
        @warn "There's already a Project.toml in the current directory, and force = false."
        (activate && need_activation) ? pkg"activate ." : nothing
        return 0 
    end 
    
    # url construction and download 
    url_project = (path == "") ? join(["https://raw.githubusercontent.com", reponame, tag, "Project.toml"], "/") : join(["https://raw.githubusercontent.com", reponame, tag, path, "Project.toml"], "/") 
    url_manifest = (path == "") ? join(["https://raw.githubusercontent.com", reponame, tag, "Manifest.toml"], "/") : join(["https://raw.githubusercontent.com", reponame, tag, path, "Manifest.toml"], "/") 
    try # project 
        resp_project = HTTP.get(url_project);
        io = open("Project.toml", "w")
        println(io, String(resp_project.body))
        close(io)
    catch e 
        @warn "There was an error retrieving the Project.toml"
        throw(e) 
    end 
    try # manifest  
        resp_manifest = HTTP.get(url_manifest);
        io = open("Manifest.toml", "w")
        println(io, String(resp_manifest.body))
        close(io)    
    catch e 
        # do nothing, since we aren't too fussed about the Manifest.
    end 

    # package operations 
    if activate && need_activation
        pkg"activate ."
        pkg"instantiate" # do this the first time 
        pkg"precompile"
    end 
end
