#!/bin/bash

# Arrêter le script à la moindre erreur
set -e

###########################################
# Variables
###########################################
APP_NAME="entreprise-app"
IMAGE_NAME="maven:latest"
CONTAINER_NAME="entreprise-app-container"
PORT="9090"

###########################################
# 1. Vérification de l'environnement
###########################################
echo "=== Vérification de l'environnement ==="

java -version
mvn -version
docker --version

mvn clean >> CI_log.log 2>&1

###########################################
# 2. Dépendances
###########################################
echo "=== Téléchargement des dépendances ==="

mvn dependency:resolve >> CI_log.log 2>&1

###########################################
# 3. Build
###########################################
echo "=== Build du projet ==="

mvn clean compile >> CI_log.log 2>&1

###########################################
# 4. Tests
###########################################
echo "=== Exécution des tests ==="

mvn test >> CI_log.log 2>&1

###########################################
# 5. Packaging
###########################################
echo "=== Packaging ==="

mvn package -DskipTests >> CI_log.log 2>&1

###########################################
# 6. Déploiement Docker
###########################################
#echo "=== Déploiement Docker ==="

# Sauvegarde de l'ancienne image
#docker tag ${IMAGE_NAME} ${IMAGE_NAME}-backup 2>log.txt || true

# Reconstruction de l'image
#docker build -t ${IMAGE_NAME} .

# Arrêt de l'ancien conteneur
#docker stop ${CONTAINER_NAME} 2>log.txt || true
#docker rm ${CONTAINER_NAME} 2>log.txt || true

# Démarrage du nouveau conteneur
#docker run -d \
#  --name ${CONTAINER_NAME} \
#  -p ${PORT}:${PORT} \
#  ${IMAGE_NAME}

###########################################
# 7. Test post-déploiement
###########################################
#echo "=== Vérification du service ==="

#sleep 15

#if curl -f http://localhost:${PORT}/actuator/health > log.txt 2>&1
#then
#    echo "application deployed successfully"
#else
#    echo "post deployment test failed"
#    echo "=== Rollback ==="

#    docker stop ${CONTAINER_NAME} || true
#    docker rm ${CONTAINER_NAME} || true

#    docker run -d \
#      --name ${CONTAINER_NAME} \
#      -p ${PORT}:${PORT} \
#      ${IMAGE_NAME}-backup

#    echo "Rollback done"
#    exit 1
#fi

#echo "Pipeline ended successfully"