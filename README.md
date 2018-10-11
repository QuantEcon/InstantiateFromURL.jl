# InstantiateFromURL

A way to bind and version dependency information to Julia assets like scripts and Jupyter notebooks (i.e., without the need to pass around TOML files). 

Based on [Valentin Churavy](https://github.com/vchuravy)'s idea in https://github.com/JuliaLang/IJulia.jl/issues/673#issuecomment-425306944.

## Overview

At a high level, the function `activate_github()` accepts GitHub repositories containing Julia TOML. Various input flavors are supported: 

* A repository name, which will be interpreted as "grab the current `master`."
* A repository name and SHA commit hash. 
* A repository name and version tag. 
* All three (will pull based on the hash).

The versioned TOML will be stored persistently in the user depot at `~/.julia/.projects`.

The TOML must (currently) be in a public repository. 

## Considerations 

* Notebook environments are perfectly reproducible, so long as you specify a static object for activation (a hash or tag). 
* Notebooks can be moved around the local machine without consequence, and traded between machines. 
* The only thing which determines the notebook's state is the notebook itself (through the TOML requirement). 