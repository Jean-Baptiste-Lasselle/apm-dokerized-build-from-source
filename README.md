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

export URI_DE_CE_REPO=git@github.com:Jean-Baptiste-Lasselle/apm-dokerized-build-from-source.git

export COMMIT_MESSAGE=""
export COMMIT_MESSAGE="COMMIT_MESSAGE Votre msg de commit"


git clone "$URI_DE_CE_REPO" .

atom .

# git add --all && git commit -m "COMMIT_MESSAGE" && git push -u origin master
```

# Run

```bash

export GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa'

export URI_DE_CE_REPO=https://github.com/Jean-Baptiste-Lasselle/apm-dokerized-build-from-source.git

git clone "$URI_DE_CE_REPO" .

docker-compose up -d
docker-compose logs -f

# docker exec -it apm_build_from_src sh -c "/pipeline/ops/bin/apm update"

# docker exec -it apm_build_from_src sh -c "/pipeline/ops/bin/apm install teletype"

```

# Issues I dealt with

## APM's `git-utils` dependency problem in APM latests releases 2.4.4 and 2.4.5

During LAte Summer / Autumn 2019, I created this repo, to try and build fromsource Atom's great `APM`. 

I then got the build proces to a certain point : hte buildwas successful, and I could even execute `apm --version` with the freshly built `APM` electron executable.

Weeks later, on the 25th of December 2019, I re-run my automated `docker-compose` recipe, and I suddenly have this new error : 


```bash
Step 38/41 : RUN ./bin/npm test
 ---> Running in 526e451e7f7a

> atom-package-manager@2.4.5 test /pipeline/ops
> node script/check-version.js && grunt test

Running "clean" task

Running "coffee:glob_to_multiple" (coffee) task
>> 42 files created.

Running "coffeelint:src" (coffeelint) task
>> 42 files lint free.

Running "coffeelint:test" (coffeelint) task
>> 26 files lint free.

Running "coffeelint:gruntfile" (coffeelint) task
>> 1 file lint free.

Running "shell:test" (shell) task
Exception loading: /pipeline/ops/spec/apm-cli-spec.coffee
Error: Error relocating /pipeline/ops/node_modules/git-utils/build/Release/git.node: git_net_url_dispose: symbol not found
  at Object.Module._extensions..node (module.js:682:18)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/node_modules/git-utils/src/git.js:3:22)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/lib/install.js:17:9)
  at Object.<anonymous> (/pipeline/ops/lib/install.js:831:4)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/lib/develop.js:18:13)
  at Object.<anonymous> (/pipeline/ops/lib/develop.js:143:4)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/lib/apm-cli.js:42:100)
  at Object.<anonymous> (/pipeline/ops/lib/apm-cli.js:258:4)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/spec/apm-cli-spec.coffee:4:7)
  at Object.<anonymous> (/pipeline/ops/spec/apm-cli-spec.coffee:1:1)
  at Module._compile (module.js:653:30)
  at Object.loadFile (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:16:19)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.jasmine.executeSpecsInFolder (/pipeline/ops/node_modules/jasmine-node/lib/jasmine-node/index.js:130:9)
  at Object.<anonymous> (/pipeline/ops/node_modules/jasmine-node/lib/jasmine-node/cli.js:235:9)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/node_modules/jasmine-node/bin/jasmine-node:6:1)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/node_modules/jasmine-focused/bin/jasmine-focused:4:1)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (module.js:566:32)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Function.Module.runMain (module.js:694:10)
  at startup (bootstrap_node.js:204:16)
  at bootstrap_node.js:625:3

Error: Error relocating /pipeline/ops/node_modules/git-utils/build/Release/git.node: git_net_url_dispose: symbol not found
  at Object.Module._extensions..node (module.js:682:18)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/node_modules/git-utils/src/git.js:3:22)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/lib/install.js:17:9)
  at Object.<anonymous> (/pipeline/ops/lib/install.js:831:4)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/lib/develop.js:18:13)
  at Object.<anonymous> (/pipeline/ops/lib/develop.js:143:4)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/lib/apm-cli.js:42:100)
  at Object.<anonymous> (/pipeline/ops/lib/apm-cli.js:258:4)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/spec/apm-cli-spec.coffee:4:7)
  at Object.<anonymous> (/pipeline/ops/spec/apm-cli-spec.coffee:1:1)
  at Module._compile (module.js:653:30)
  at Object.loadFile (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:16:19)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.jasmine.executeSpecsInFolder (/pipeline/ops/node_modules/jasmine-node/lib/jasmine-node/index.js:130:9)
  at Object.<anonymous> (/pipeline/ops/node_modules/jasmine-node/lib/jasmine-node/cli.js:235:9)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/node_modules/jasmine-node/bin/jasmine-node:6:1)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/node_modules/jasmine-focused/bin/jasmine-focused:4:1)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (module.js:566:32)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Function.Module.runMain (module.js:694:10)
  at startup (bootstrap_node.js:204:16)
  at bootstrap_node.js:625:3

Warning: Command failed: node node_modules/jasmine-focused/bin/jasmine-focused --captureExceptions --coffee spec
Error: Error relocating /pipeline/ops/node_modules/git-utils/build/Release/git.node: git_net_url_dispose: symbol not found
  at Object.Module._extensions..node (module.js:682:18)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/node_modules/git-utils/src/git.js:3:22)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/lib/install.js:17:9)
  at Object.<anonymous> (/pipeline/ops/lib/install.js:831:4)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/lib/develop.js:18:13)
  at Object.<anonymous> (/pipeline/ops/lib/develop.js:143:4)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/lib/apm-cli.js:42:100)
  at Object.<anonymous> (/pipeline/ops/lib/apm-cli.js:258:4)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/spec/apm-cli-spec.coffee:4:7)
  at Object.<anonymous> (/pipeline/ops/spec/apm-cli-spec.coffee:1:1)
  at Module._compile (module.js:653:30)
  at Object.loadFile (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:16:19)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.jasmine.executeSpecsInFolder (/pipeline/ops/node_modules/jasmine-node/lib/jasmine-node/index.js:130:9)
  at Object.<anonymous> (/pipeline/ops/node_modules/jasmine-node/lib/jasmine-node/cli.js:235:9)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/node_modules/jasmine-node/bin/jasmine-node:6:1)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (/pipeline/ops/node_modules/coffee-script/lib/coffee-script/register.js:45:36)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Module.require (module.js:597:17)
  at require (internal/module.js:11:18)
  at Object.<anonymous> (/pipeline/ops/node_modules/jasmine-focused/bin/jasmine-focused:4:1)
  at Module._compile (module.js:653:30)
  at Object.Module._extensions..js (module.js:664:10)
  at Module.load (module.js:566:32)
  at tryModuleLoad (module.js:506:12)
  at Function.Module._load (module.js:498:3)
  at Function.Module.runMain (module.js:694:10)
  at startup (bootstrap_node.js:204:16)
  at bootstrap_node.js:625:3

 Use --force to continue.

Aborted due to warnings.
npm ERR! Test failed.  See above for more details.
ERROR: Service 'hot_ide_workspace' failed to build: The command '/bin/sh -c ./bin/npm test' returned a non-zero code: 1
```

_**What I then did**_

# Plus


* I started with listening to npm's advice, and modified my `docker/autre3/Dockerfile`, adding the `--force` GNU option to the `npm test` command. 
* Then the build from source finally my `apm` executable, but when I ran after that, the `apm --version` command, the  `git_net_url_dispose: symbol not found` error popped out again. Completelyidetivcal error message. Well, actually, it totally makes sense, especially because my further inquiries, as you will read, confirmed to me that `git-utils` is a runtime (not build time) APM dependency.
* After that expectable failure, I then determined that this error was thrown by a runtime dependency of APM : https://github.com/atom/git-utils 
* Going further, I then realized that in [the git repo of that `git-utils` APM dependency])(https://github.com/atom/git-utils), a new version had been released : version `5.6.2` of `git-utils`. 
* I aslso noticed that the `5.6.2` release of `git-utils`, has been released pretty recently : `28` days before my tests, on  the `25th of December, 2019`.
* I then browsed to `APM`'s official source code git repo https://github.com/atom/apm.git, to check what version of `git-utils` was referenced inside the `package.json` : 
  * Well it turned out indeed, that `git-utils` was referenced inside the `package.json` of APM 's source code, in the `dependency` section, and not in the `devDepencies`. So positively a runtime dependency, not a build time dependency.
  * Furthermore, going into detailed `APM`'s git commit history, commits d'APM, I noticed that `28` days before my tests, on  the `25th of December, 2019`, the very same day version `5.6.2` of `git-utils` was released, a new commit was pushed to  to `APM`'s official source code git repo https://github.com/atom/apm.git, modifying the `package.json`, so that APM's uses its dependency `git-utils`, in version version `5.6.2`, instead of previously used version `4.0` : 

[![ecran diff du commit ayant changé version de 'git-utils'](https://gitlab.com/second-bureau/pegasus/atom-ide/provision-apm-atom-package-manager/raw/master/documentations/images/impr.ecran/Firefox_Screenshot_2019-12-25T18-34-58.012Z.png?inline=false) ](https://github.com/atom/apm/commit/5332714ecc839a9f90e4ce8bb118cd51ed0c7f11)

_lien vers le commit exact : https://github.com/atom/apm/commit/5332714ecc839a9f90e4ce8bb118cd51ed0c7f11_

* On the other hand, I also noticed some things happened, on `APM`'s official source code git repo https://github.com/atom/apm.git, during the period  starting `28`, say `30`, days before my tests, on the `25th of December, 2019`. Indeed, there were also not one, but **two new relases of `APM`** (versions  `2.4.4` and  `2.4.5`)

[![dernières releases APM](https://gitlab.com/second-bureau/pegasus/atom-ide/provision-apm-atom-package-manager/raw/master/documentations/images/impr.ecran/Firefox_Screenshot_2019-12-25T18-36-16.752Z.png?inline=false)](https://github.com/atom/apm/releases)

* Right, from there, here is my alternative, to reproduce the successful build from source I obtained weeks ago : making sure that my build from source uses an _inambiguous_ version of the source code of APM, in our case version `2.4.3` of APM, instead of always git cloning latest commit on master (which is ahead of `2.4.5`, and any release actually). 
* Well i did, and it worked, as of release `0.0.2` of the present git repo;

_**Final Remark**_


Fianlly, I remark that when you develop any software, moving from version `4.0`, to version `5.6.2`, of a runtime dependency, well of course you can expect that things will "break" in your software !!!

So, what is happening on the `Atom` Project ?  

Are they migrating the `git-utils` dependency because they suddenly realized they left behind  tons of releases of `git-uils` ?

Or has there been a massive problem with `git-utils` it self, and it took tons of releases to fix it ? Well if that is the case, one thing I don' understand is that `git-utils` is a project administered gy the Atom Organization on Github, so all those `git-utils` releases, if they were not useful to `APM`, who (which project) were they useful too?

Well all those questions confort my initial motivation for creating this repo : saving `Atom` (from `Microsoft` ?) 

To the `Atom` team : I'll be glad to contribute if asked. Actually this `docker-compose` automation already is a contribution.

Again, I looooove Atom like :heart: :heart: :heart: 

So merry Christmas `Atom`


_I'll write more about that on my soon to grand opening new blog (stay tuned)_
