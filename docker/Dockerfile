FROM node:8.16.2-alpine



# --
# RUN apt-get update -y
RUN apk update
# Install libsecret-1-dev (or the relevant libsecret development dependency) if you are on Linux
# RUN apt-get install -y libsecret-1-dev
RUN apk add git libsecret
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