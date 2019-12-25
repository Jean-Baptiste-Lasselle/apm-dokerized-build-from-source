# The APM Atom Package Manager : A Build From Source Recipe


### What's this ?

An automated `APM` Build From Source. The recipe also shows how to standalone run `APM`, and was originally shared at https://github.com/atom/apm/issues/871

Well actually it started with a build from source recipe, but suddenly :
* I manage to tear off Atom IDE, its package manager : `APM`
* `APM`'s build from source recipe packages `APM` **with** an embedded `NPM`
* `APM`'s build from source recipe packages `APM` **without** an embedded `NodeJS` runtime.
* `APM` is meant to run on amachine where it was installed with the `Atom IDE` : I bet `Atom IDE` is packged with an embedded `NodeJS` runtime.
* So what I did, is that I design a container :
  * `FROM` a `node:"${NODE_SEMVER_VERSION}-alpine"` container, So we have the `NodeJS` runtime.
  * with Python installed in it at Docker Build Time, using [`PyEnv`](https://github.com/pyenv/pyenv). `PyEnv` is what [`NVM`](https://github.com/nvm-sh/nvm) is to `NodeJS`, but for managing `Python` Environments, instead of `NodeJS` Environments. So Using `PyEnv`, I made this recipe tasty to the `APM_BUILD_PYTHON_VERSION` build parameter's taste. (You can change the `APM_BUILD_PYTHON_VERSION`)  

### How to use

* modify the build env. variable `VERSION_APM` inside the `docker-compose.yml` : 
  * the value of that variable should be a valid (an existing) tag on the `APM` source code reference git repo, see https://github.com/atom/apm/releases .
  * setting this variable allows you to set which version of APM's source code, will be used to build APM from source. 
* Note that I succeeded building APM version `2.4.3`, but it seems we have [a problem with latest `2.4.4`, and `2.4.5`](#aproblemwith2.4.4and2.4.5). 
* Just `git` clone and `docker-compose up -d`

### Note ...

This recipe is made, with an aim in mind: splitting `Atom IDE` into smaller dockerized parts. Why? To make Atom faster, much faster.
faster hot reconfiguration, to switch from one pipeline, to another, as quickly as possible.

Recette de provision du package manager Atom : APM
https://github.com/atom/apm

apm est habituallement installé avec Atom. Cette recette permet de l'installer en autonome, pour éclater Atom en différents conteneurs Docker.


# IAAC

```bash
export GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa'

export URI_DE_CE_REPO=git@gitlab.com:second-bureau/pegasus/atom-ide/provision-apm-atom-package-manager.git

export COMMIT_MESSAGE=""
export COMMIT_MESSAGE="COMMIT_MESSAGE Votre msg de commit"


git clone "$URI_DE_CE_REPO" .

atom .

# git add --all && git commit -m "COMMIT_MESSAGE" && git push -u origin master
```

# Run

```bash

export GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa'

export URI_DE_CE_REPO=git@gitlab.com:second-bureau/pegasus/atom-ide/provision-apm-atom-package-manager.git

git clone "$URI_DE_CE_REPO" .

docker-compose up -d
docker-compose logs -f

# docker exec -it apm_build_from_src sh -c "/pipeline/ops/bin/apm update"

# docker exec -it apm_build_from_src sh -c "/pipeline/ops/bin/apm install hydrogen"

```
