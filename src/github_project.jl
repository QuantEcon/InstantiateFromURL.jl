# Code for the refactor in https://github.com/QuantEcon/InstantiateFromURL.jl/issues/37

# Without versions for now (so that we don't force downgrades, etc.)... can get version information easily enough, though.
function packages_to_default_environment() # no arg, since it operates on the activated environment
    if (Base.active_project() == Base.load_path_expand("@v#.#"))
        @info "No project activated."
        return 
    end

    ctx = Pkg.Types.Context();
    packages = collect(keys(ctx.env.project.deps)); # collect: KeySet -> Array{String}
    original_env = ctx.env.project_file;
    default_env = Base.load_path_expand("@v#.#");
    Pkg.activate(default_env)
    Pkg.add(packages) 
    Pkg.activate(original_env)
    return
end 

function github_project(reponame; # e.g., "QuantEcon/quantecon-notebooks-jl"
    path = "", # relative path within the repo (root by default)
    version = "master",
    force = false)

    #= summary variables for logic
        - is_project_activated = are we using a non-default project 
        - is_project_local = are we using a project in our pwd
        - does_local_project_exist = need this, because scripts/REPLs will not always activate the local project 
        - url... = online resource paths 
    =#
    current_proj = Base.active_project()
    is_project_activated = !(Base.active_project() == Base.load_path_expand("@v#.#")) 
    is_project_local = dirname(current_proj) == pwd() 
    does_local_project_exist = isfile(joinpath(pwd(), "Project.toml"))
    url_project = (path == "") ? join(["https://raw.githubusercontent.com", reponame, "v" * version, "Project.toml"], "/") : join(["https://raw.githubusercontent.com", reponame, version, path, "Project.toml"], "/") 
    url_manifest = (path == "") ? join(["https://raw.githubusercontent.com", reponame, "v" * version, "Manifest.toml"], "/") : join(["https://raw.githubusercontent.com", reponame, version, path, "Manifest.toml"], "/")

    # unified display for all cases
    function displayproj()
        ctx = Pkg.Types.Context();
        project_information = parsefile(ctx.env.project_file);
        project_file = ctx.env.project_file;
        project_version = haskey(project_information, "version") ? project_information["version"] : "NA"
        project_name = haskey(project_information, "name") ? project_information["name"] : "NA"
        @info "Using $(project_file). Name: $project_name. Version: $project_version."
        if project_version != version 
            @info "Found version doesn't match requested."
        end 
    end 

    # use a local project if it exists and we don't have it set to force
    if !is_project_local && does_local_project_exist && !force
        Pkg.activate(pwd());
        displayproj()
        return 
    end 

    # if we're satisfied with the project activated, just display 
    # this case catches most scenarios
    if is_project_activated && !force 
        displayproj()
        return 
    end 

    # at this point, need to do downloading/overwriting/etc.
    if does_local_project_exist 
        @info "local TOML exists; will be replaced"
        rm(joinpath(pwd(), "Project.toml"), force = true) # force = true so non-existing path doesn't error
        rm(joinpath(pwd(), "Manifest.toml"), force = true)
    end 

    try @suppress Base.download(url_project, joinpath(pwd(), "Project.toml")); 
    catch e 
        @warn "Can't download Project. Make sure the URL is accurate."
        throw(e)
    end 

    # try/catch on Manifest because it isn't always required
    try @suppress Base.download(url_manifest, joinpath(pwd(), "Manifest.toml"));
    catch e
        @info "Can't download Manifest."
    end 
    
    Pkg.activate(pwd())
    Pkg.instantiate()
    pkg"precompile"
    displayproj()
    return # return nothing
end
