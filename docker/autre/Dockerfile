FROM node:8.16.2-alpine



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

# Set Python version
ARG APM_BUILD_PYTHON_VERSION='3.7.0'
# Set pyenv home
ARG PYENV_HOME=/root/.pyenv

# Install pyenv, then install python versions
RUN git clone --depth 1 https://github.com/pyenv/pyenv.git $PYENV_HOME && \
    rm -rfv $PYENV_HOME/.git

ENV PATH $PYENV_HOME/shims:$PYENV_HOME/bin:$PATH

RUN pyenv install $APM_BUILD_PYTHON_VERSION
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
RUN apk add git libsecret
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

# 
# This will install the dependencies with your built-in version of
# Node/npm, and then rebuild them with the bundled versions.
# 

RUN echo "---------------------------------------------"
RUN echo "Version de [NodeJS] AVANT installation [ATOM APM] : "
RUN node --version
RUN echo "---------------------------------------------"

RUN npm install 

RUN echo "---------------------------------------------"
RUN echo "Version de [NodeJS] APRES installation [ATOM APM] : "
RUN node --version
RUN echo "---------------------------------------------"

RUN echo "---------------------------------------------"
RUN echo "Emplacement auquel est installé [ATOM APM] : [$(which apm)]"
RUN which apm
RUN echo "---------------------------------------------"



# ---
# Run the specs
RUN ./bin/npm test
# Compile the CoffeeScript code
RUN ./bin/npm run build

CMD ["/bin/sh"]