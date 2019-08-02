# Code for the refactor in https://github.com/QuantEcon/InstantiateFromURL.jl/issues/37

# Without versions for now (so that we don't force downgrades, etc.)... can get version information easily enough, though.
function add_to_default() # no arg, since it operates on the activated environment
    if (Base.active_project() == Base.load_path_expand("@v#.#"))
        @info "Your default environment is activated; nothing to do."
        return 
    end

    ctx = Pkg.Types.Context();
    packages = collect(keys(ctx.env.project.deps)); # collect: KeySet -> Array{String}
    original_env = ctx.env.project_file;
    default_env = Base.load_path_expand("@v#.#");
    Pkg.activate(default_env)
    Pkg.add(packages) 
    Pkg.activate(original_env)
end 

function github_path(reponame; # e.g., "QuantEcon/quantecon-notebooks-jl"
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
    url_project = (path == "") ? join(["https://raw.githubusercontent.com", reponame, version, "Project.toml"], "/") : join(["https://raw.githubusercontent.com", reponame, version, path, "Project.toml"], "/") 
    url_manifest = (path == "") ? join(["https://raw.githubusercontent.com", reponame, version, "Manifest.toml"], "/") : join(["https://raw.githubusercontent.com", reponame, version, path, "Manifest.toml"], "/")

    # unified display for all cases
    function display()
        ctx = Pkg.Types.Context();
        project_information = parsefile(ctx.env.project_file);
        @info "Activated project: $(ctx.env.project_file)"

        if project_information["version"] != version 
            @info "Present version ($(project_information["version"])) differs from requested ($version). Proceeding since force = false."
        else 
            display("Activated project version: $(project_information["version"])")
        end 

        if project_information["name"] != nothing 
            display("Activated project name: $(project_information["name"])")
        end 
    end 

    # use a local project if it exists and we don't have it set to force
    if !is_project_local && does_local_project_exist && !force
        Pkg.activate(joinpath(pwd(), "Project.toml"));
        display()
        return 
    end 

    # if we're satisfied with the project activated, just display 
    if is_project_activated && !force 
        display()
        return 
    end 

    # at this point, need to do downloading/overwriting/etc.
    if force && is_project_local
        display("removing local TOML...")
        rm(joinpath(pwd(), "Project.toml"), force = true) # force = true so non-existing path doesn't error
        rm(joinpath(pwd(), "Manifest.toml"), force = true)
    end 

    Base.download(url_project, joinpath(pwd(), "Project.toml"))
    # try/catch on Manifest because it isn't always required
    try Base.download(url_manifest, joinpath(pwd(), "Manifest.toml"));
    catch e
        @info "No Manifest present at URL."
    end 
    
    @suppress Pkg.activate(joinpath(pwd(), "Project.toml"))
    @suppress Pkg.instantiate()
    @suppress pkg"precompile"
    display()
    return # return nothing
end
