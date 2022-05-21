#! /bin/bash
VERSION=1.0.0

sh ./docker-build.sh

docker save harbor.jkservice.org/di/azure_flowlog:${VERSION} -0 azure_flowlog_${VERSION}.tar


mv azure_flowlog_${VERSION}.tar ./docker
