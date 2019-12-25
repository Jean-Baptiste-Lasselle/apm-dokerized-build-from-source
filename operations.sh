#!/bin/bash 

# testée le `Thu Oct 17 01:11:34 CEST 2019`



docker-compose up -d 

docker exec -it apm_build_from_src sh -c "/pipeline/ops/bin/apm --version"
apm  2.4.3
npm  6.2.0
node 8.16.2 x64
atom unknown
python 2.7.16
git 2.22.2
