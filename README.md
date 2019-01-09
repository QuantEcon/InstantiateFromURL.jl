# InstantiateFromURL

A way to bind dependency information to Julia assets without the need to pass around TOML files

Will download, unpack, and activate a tarball of the resources in `pwd/.projects`

Based on [Valentin Churavy](https://github.com/vchuravy)'s idea in https://github.com/JuliaLang/IJulia.jl/issues/673#issuecomment-425306944

## Overview

GitHub repositories are expected to include a `Project.toml` and `Manifest.toml` file in the root directory, and all other files are ignored. For ex: [QuantEcon/QuantEconLecturePackages](https://github.com/QuantEcon/QuantEconLecturePackages)

All of the following are valid calls:

* `activate_github("QuantEcon/QuantEconLecturePackages")`, which saves to `.projects/QuantEconLecturePackages-master`
* `activate_github("QuantEcon/QuantEconLecturePackages", tag = "master")`, which gives us the same thing. 
* `activate_github("QuantEcon/QuantEconLecturePackages", tag = "v0.9.5")`, which saves that version to `.projects/QuantEconLecturePackages-v0.9.5`
* `activate_github("QuantEcon/QuantEconLecturePackages", sha = "0c2985")`, which saves that commit to `.projects/QuantEconLecturePackages-0c2985`

You can also call any of the above with `; force = true`, which will force a re-download of the source resources. 

You can also include an `add_default_environment = true` in your calls, which will `Pkg.add()` (at once) the packages grabbed to your default (`~/.julia/environments/v1.0`) environment. This way, packages/versions you install via `InstantiateFromURL` are immediately available, and can avoid teaching people about environments. 

There's also a non-exported `copy_env(reponame, oldprefix, newprefix)` which will let you:

```
activate_github("QuantEcon/QuantEconLecturePackages")
copy_env("QuantEcon/QuantEconLecturePackages", "master", "mymaster")
activate_github("QuantEcon/QuantEconLecturePackages", tag = "mymaster") # Protected from future updates. 
``` 

No GitHub API calls are consumed, so rate-limiting is not an issue 
