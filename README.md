# InstantiateFromURL

[![Build Status](https://travis-ci.com/QuantEcon/InstantiateFromURL.jl.svg?branch=master)](https://travis-ci.com/QuantEcon/InstantiateFromURL.jl)

A way to bind dependency information to Julia assets without the need to pass around TOML files

Will download, unpack, and activate a tarball of the resources in `pwd/.projects`

Based on [Valentin Churavy](https://github.com/vchuravy)'s idea in https://github.com/JuliaLang/IJulia.jl/issues/673#issuecomment-425306944

## Overview

We have two main methods, `activate_github` (dealing with a versioned, dedicated TOML repo, like [QuantEcon/QuantEconLecturePackages](https://github.com/QuantEcon/QuantEconLecturePackages)), and `activate_github_path` (pulling down unversioned TOML from a git repository; i.e., if notebooks live with TOML in a repository.)

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
