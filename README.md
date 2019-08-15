# InstantiateFromURL

[![Build Status](https://travis-ci.com/QuantEcon/InstantiateFromURL.jl.svg?branch=master)](https://travis-ci.com/QuantEcon/InstantiateFromURL.jl)

A way to bind dependency information to Julia assets without the need to pass around TOML files.

The use case is that your notebooks would have something like the following in their first cell:

```
using InstantiateFromURL
github_project("QuantEcon/QuantEconLecturePackages")
```

Based on [Valentin Churavy](https://github.com/vchuravy)'s idea in https://github.com/JuliaLang/IJulia.jl/issues/673#issuecomment-425306944

## Overview/Method Signature

[**Note**] To account for changes in `IJulia` (where notebooks will now look recursively up the tree for TOML, and use either what they find or the default `v1.x` environment), we've introduced the new function/entrypoint below. The functions we had previously provided are still around, in the subsequent **deprecated** section. 

The signature is:

```
function github_project(reponame; # e.g., "QuantEcon/quantecon-notebooks-jl"
    path = "", # relative path within the repo (root by default)
    version = "master",
    force = false)
```

Where: 

* `reponame` and `path` identify the TOML on the internet. Reponame is something like `"QuantEcon/QuantEconLecturePackages"` The path refers to the path to the TOML within the source repo, and is `""` by default (i.e., referring to top-level.)

* `version` refers to a specific version of the TOML, corresponding to a **github tag** of the `reponame` repo.

* `force` decides whether or not we're comfortable using whatever project-specific IJulia finds (if there is any.) Essentially, **the `force` parameter decides whether to use a soft or hard match.**

The logic here is: 

* If a **local project** is activated (i.e., if there is TOML up the source tree), use that unless `force = true`, and print intelligent information about it (e.g., if we asked for version `v0.2.1`, and version `v0.2.0` is found, it will still use `v0.2.0`, and alert you to the difference.)

* ...But, if `force = true`, then regardless of what is activated, the precise set of `Project.toml, Manifest.toml` will be pulled down to the notebook's directory from the specified internet location. 

## Utilities

We also defined: 

* `packages_to_default_environment()`, which will take the current environment's packages, and `Pkg.add()` them to your `v1.x` environment. Useful for "seeding" or setting up new Julia installs, or making sure that deps for one project are available for other projects, etc.

## Deprecated Methods


For `activate_github`, the signature is:

```
function activate_github(reponame; # like "QuantEcon/QuantEconLecturePackages"
                        tag = nothing, # could be "master" or a git tag
                        sha = nothing, # could point to a specific commit
                        force = false, # will overwrite the local version of this TOML if true
                        add_default_environment = false) # will add these projects to the default (e.g., v1.1) TOML if true
```

Example calls include:

* `activate_github("QuantEcon/QuantEconLecturePackages")`
* `activate_github("QuantEcon/QuantEconLecturePackages", tag = "master")`
* `activate_github("QuantEcon/QuantEconLecturePackages", tag = "v0.9.5")`
* `activate_github("QuantEcon/QuantEconLecturePackages", sha = "0c2985")`

For `activate_github_path`, the signature is:

```
function activate_github_path(reponame; # something like "QuantEcon/SimpleDifferentialOperators.jl"
                                path = "", # like "docs/examples", or where in the (master) source tree the TOML is
                                tag = "master",
                                force = false,
                                activate = true) # decide whether to `activate; instantiate; precompile` or not
```

**Note:** Because switching project files currently leads to repeat precompilations in Julia, `activate` will only bind if the current Project.toml (i.e., `Base.active_project()`) is in a different location than the pwd (i.e., `joinpath(pwd(), "Project.toml")`.)
