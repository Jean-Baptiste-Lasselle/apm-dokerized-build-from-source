# The APM Atom Package Manager : A Build From Source Recipe


### What's this ?

Well actually it started with a build from source recipe, but suddenly :
* I manage to tear off Atom IDE, its package manager : `APM`
* `APM`'s build from source recipe packages `APM` **with** an embedded `NPM`
* `APM`'s build from source recipe packages `APM` **without** an embedded `NodeJS` runtime.
* `APM` is meant to run on amachine where it was installed with the `Atom IDE` : I bet `Atom IDE` is packged with an embedded `NodeJS` runtime.
* So what I did, is that I design a container :
  * `FROM` a `node:"${NODE_SEMVER_VERSION}-alpine"` container, So we have the `NodeJS` runtime.
  * with Python installed in it at Docker Build Time, using [`PyEnv`](https://github.com/pyenv/pyenv). `PyEnv` is what [`NVM`](https://github.com/nvm-sh/nvm) is to `NodeJS`, but for managing `Python` Environments, instead of `NodeJS` Environments. So Using `PyEnv`, I made this recipe tasty to the `APM_BUILD_PYTHON_VERSION` build parameter's taste. (You can change the `APM_BUILD_PYTHON_VERSION`)  

### How to use

* Just `git` clone and `docker-compose up -d`

### Note ...

This recipe is made, with an aim in mind: splitting `Atom IDE` into smaller dockerized parts. Why? To make Atom faster, much faster.
faster hot reconfiguration, to switch from one pipeline, to another, as quickly as possible.

Recette de provision du package manager Atom : APM
https://github.com/atom/apm

apm est habituallement installé avec Atom. Cette recette permet de l'installer en autonome, pour éclater Atom en différents conteneurs Docker.
