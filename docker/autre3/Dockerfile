FROM node:8.16.2-alpine

ARG VERSION_APM=2.4.3

# This is because the project you're trying to build requires the node-gyp package to build something natively on the platform. That package required Python 2.7 and a few other pieces too.

# --
# RUN apt-get update -y
RUN apk update


# ------------------------------------------------------------------------------
# + Dépendance BuildFrom Src : PYTHON
# ------------------------------------------------------------------------------
#
# Update & Install dependencies
RUN apk add --no-cache --update \
    linux-headers \
    git \
    bash \
    libffi-dev \
    openssl-dev \
    bzip2-dev \
    zlib-dev \
    readline-dev \
    sqlite-dev \
    build-base

# [node-gyp] : This is because the project you're trying to build requires the
# node-gyp package to build something natively on the platform. That package
# required Python 2.7 and a few other pieces too.
# cf. https://westerndevs.com/JavaScript/How-to-Fix-node-gyp-Error-on-Windows/

#
# For future reference : 
# I had already ca-certificates installed but the error persisted.
# The problem was that my certificates were located in [/etc/ssl/certs/ca-certificates.crt] instead 
# of [/etc/pki/tls/certs/ca-bundle.crt], so I just had to set the environmental 
# variable CURL_CA_BUNDLE to the correct path
# Jean-Baptiste Lasselle : thank you so much to Robert Smith : 
# https://stackoverflow.com/questions/3160909/how-do-i-deal-with-certificates-using-curl-while-trying-to-access-an-https-url
# https://stackoverflow.com/users/460147/robert-smith
# 
ARG CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
ENV CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt


# Set Python version
# ARG APM_BUILD_PYTHON_VERSION='3.7.0'
ARG APM_BUILD_PYTHON_VERSION='2.7.16'
# Another Problem : Python 2 is now DEPRECATED => We will HAVE to make the build recipe of APM evolve
#                   https://www.python.org/download/releases/2.7/
# Set pyenv home
ARG PYENV_HOME=/root/.pyenv

# Install pyenv, then install python versions
RUN git clone --depth 1 https://github.com/pyenv/pyenv.git $PYENV_HOME && \
    rm -rfv $PYENV_HOME/.git

ENV PATH $PYENV_HOME/shims:$PYENV_HOME/bin:$PATH

RUN pyenv install -v $APM_BUILD_PYTHON_VERSION
RUN pyenv global $APM_BUILD_PYTHON_VERSION
RUN pip install --upgrade pip && pyenv rehash

# Clean
RUN rm -rf ~/.cache/pip
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# + Dépendance BuildFrom Src : LIBSECRET
# ------------------------------------------------------------------------------
#
# Install libsecret-1-dev (or the relevant libsecret development dependency) if you are on Linux
# RUN apt-get install -y libsecret-1-dev
# https://pkgs.alpinelinux.org/contents?branch=edge&name=libsecret-dev&arch=x86_64&repo=main
RUN apk add git libsecret-dev
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------
# ------------------------------------------------------------------------------


# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# ------------------------------------------------------------------------------
# + BUILD FROM SOURCE APM
# ------------------------------------------------------------------------------
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#

RUN mkdir -p /pipeline/ops
# Avec clefs SSH, l'import en interne :
#    git@gitlab.com:second-bureau/pegasus/atom-ide/apm
#
RUN git clone https://github.com/atom/apm /pipeline/ops
WORKDIR /pipeline/ops
RUN git checkout tags/$VERSION_APM
# RUN git checkout $VERSION_APM
#
# This will install the dependencies with your built-in version of
# Node/npm, and then rebuild them with the bundled versions.
#
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
# ------------------------------------------------------------------------------
# + ELECTRON INSTALLATION
# ------------------------------------------------------------------------------
# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
#
# - L'installation d'électron est nécessaire pour exécuter [apm install hydrogen] (et surement toute autre instruction d'installation apm)
# - mais il est possible qu' [APM], lorsqu'il est "buildé", "grave dans le marbre", la version liée de [Electron]. Cette inscription dans le marbre et ensuite utilisée à l'exécution d'APM, pour mener les builds; je ne vois pas encore le rapport avecl'ensemble de mes notes.
#

RUN echo " Installation ELECTRON JBL"
# RUN npm install electron -g
# Known issue : https://github.com/electron/electron/issues/11755
RUN npm install --save-dev electron --unsafe-perm=true --allow-root
# just because it seems like electron is expected by apm somewhere else than the standard installation ..? Like in the build project maybe... I dunno yet.
# RUN npm install electron --save-dev --unsafe-perm=true --allow-root

RUN echo "---------------------------------------------"
RUN echo "Version de [NodeJS] AVANT installation [ATOM APM] : "
RUN node --version
RUN echo "---------------------------------------------"
# [node-gyp] : This is because the project you're trying to build requires the
# node-gyp package to build something natively on the platform. That package
# required Python 2.7 and a few other pieces too.
#

RUN npm install

RUN echo "---------------------------------------------"
RUN echo "Version de [NodeJS] APRES installation [ATOM APM] : "
RUN node --version
RUN echo "---------------------------------------------"

RUN echo "---------------------------------------------"
RUN echo "Emplacement auquel est installé [ATOM APM] : [$(which apm)]"
# RUN which apm
# RUN apm --help
RUN ls -allh .
RUN ls -allh bin
RUN apk add tree && tree -allh ./bin

# Ajout lien symbolique pour que apm puisse trouver l'exécutable NODEJS
RUN echo "$(which node)" |awk -F '/' '{ for (i = 1; i < NF ; i++) { for (j = 1; j<=i;j++) { if ( j != 1){ printf "/" $j}; };print ""}}' | tail -n 1 > ./.embedded.node.home.pgs
# ARG EMBEDDED_NODE_HOME=$(cat ./.embedded.node.home.pgs)
RUN export EMBEDDED_NODE_HOME=$(cat ./.embedded.node.home.pgs) && rm -fr $EMBEDDED_NODE_HOME/node_modules
RUN export EMBEDDED_NODE_HOME=$(cat ./.embedded.node.home.pgs) && ln -s $EMBEDDED_NODE_HOME/node /pipeline/ops/bin/node
RUN echo "---------------------------------------------"



# ---
# Run the specs
RUN ./bin/npm test --force
# Compile the CoffeeScript code
RUN ./bin/npm run build

RUN ./bin/apm --version

# RUN ./bin/apm install maisnimportequoi



CMD ["/bin/sh"]
# CMD ["/pipeline/ops/bin/apm", "install", "maisnimportequoi"]
# CMD ["/pipeline/ops/bin/apm", "install", "hydrogen"]
