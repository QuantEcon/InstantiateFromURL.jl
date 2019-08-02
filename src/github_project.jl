# Code for the refactor in https://github.com/QuantEcon/InstantiateFromURL.jl/issues/37

# Without versions for now (so that we don't force downgrades, etc.)... can get version information easily enough, though.
function add_to_default() # no arg, since it operates on the activated environment
    if (Base.active_project() == Base.load_path_expand("@v#.#"))
        display("Your default environment is activated; nothing to do.")
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
