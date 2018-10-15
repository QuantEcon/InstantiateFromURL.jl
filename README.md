# InstantiateFromURL

A way to bind dependency information to Julia assets without the need to pass around TOML files

Will download, unpack, and activate a tarball of the resources in `pwd/.projects`

Based on [Valentin Churavy](https://github.com/vchuravy)'s idea in https://github.com/JuliaLang/IJulia.jl/issues/673#issuecomment-425306944

## Overview

GitHub repositories are expected to include a `Project.toml` and `Manifest.toml` file in the root directory, and all other files are ignored.  See [QuantEcon/QuantEconLecturePackages](https://github.com/QuantEcon/QuantEconLecturePackages) for an example respository

All of the following are valid calls:

* `activate_github("QuantEcon/QuantEconLecturePackages")`, which saves to `.projects/QuantEconLecturePackages-master`
* `activate_github("QuantEcon/QuantEconLecturePackages", tag = "master")`, which gives us the same thing. 
* `activate_github("QuantEcon/QuantEconLecturePackages", tag = "v0.1.0")`, which saves that version to `.projects/QuantEconLecturePackages-v0.1.0`
* `activate_github("QuantEcon/QuantEconLecturePackages", sha = "0c2985")` - which saves that commit to `.projects/QuantEconLecturePackages-0c2985`

You can also call any of the above with `; force = true`, which will force a re-download of the source resources. 

There's also a non-exported `copy_env(reponame, oldprefix, newprefix)` which will "check out" a new copy of, say, `master`, that is protected from future updates (here, "prefix" is the tarball prefix, or everything after the `-` in the directories above). So:

```
activate_github("QuantEcon/QuantEconLecturePackages")
copy_env("QuantEcon/QuantEconLecturePackages", "master", "mymaster")
activate_github("QuantEcon/QuantEconLecturePackages", tag = "mymaster") # Protected from future updates. 
``` 

