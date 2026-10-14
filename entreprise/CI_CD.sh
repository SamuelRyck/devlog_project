#!/bin/bash

set -e
rm CI_log.log

APP_NAME="entreprise-app"
IMAGE_NAME="maven:latest"
CONTAINER_NAME="entreprise-app-container"
PORT="9090"

echo "verification"

java -version
mvn -version
docker --version

mvn clean >> CI_log.log 2>&1


echo "dependances"

mvn dependency:resolve >> CI_log.log 2>&1


echo "build"

mvn clean compile >> CI_log.log 2>&1


echo "=== Exécution des tests ==="

mvn test >> CI_log.log 2>&1


echo "packaging"

mvn package -DskipTests >> CI_log.log 2>&1


echo "deploiement"

# sauvegarde de l'ancienne image
docker tag ${IMAGE_NAME} ${IMAGE_NAME}-backup 2>log.txt || true

# reconstruction image
docker build -t ${IMAGE_NAME} .

# arret de l'ancien conteneur
docker stop ${CONTAINER_NAME} 2>log.txt || true
docker rm ${CONTAINER_NAME} 2>log.txt || true

# demarrage du nouveau conteneur
docker run -d \
  --name ${CONTAINER_NAME} \
  -p ${PORT}:${PORT} \
  ${IMAGE_NAME}


echo "verif service"

sleep 30

if curl -f http://localhost:${PORT}/api/entreprises > log.txt 2>&1
then
    echo "application deployed successfully"
else
    echo "post deployment test failed"
    echo "=== Rollback ==="

    docker stop ${CONTAINER_NAME} || true
    docker rm ${CONTAINER_NAME} || true

    docker run -d \
      --name ${CONTAINER_NAME} \
      -p ${PORT}:${PORT} \
      ${IMAGE_NAME}-backup

    echo "Rollback done"
    exit 1
fi

echo "Pipeline ended successfully"