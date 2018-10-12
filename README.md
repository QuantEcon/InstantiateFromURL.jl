# InstantiateFromURL

A way to bind dependency information to Julia assets without the need to pass around TOML files.

Will download, unpack, and activate a tarball of the resources in `pwd/.projects`

Based on [Valentin Churavy](https://github.com/vchuravy)'s idea in https://github.com/JuliaLang/IJulia.jl/issues/673#issuecomment-425306944.

## Overview

All of the following are valid calls:

* `activate_github("arnavs/InstantiationTest")`
* `activate_github("arnavs/InstantiationTest", version = "v0.1.0")`
* `activate_github("arnavs/InstantiationTest", sha = "2d1291c4372c1d1a41f655292f60e1c5b8d5af57")`

You can also call any of the above with `; force = true`, which will force a re-download of the source resources. 

The last command above would saveto `pwd/.projects/InstantiationTest-2d1291c4372c1d1a41f655292f60e1c5b8d5af57/`, and likewise for the other commands (with the appropriate SHA1 hashes).