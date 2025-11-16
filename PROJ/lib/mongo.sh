#!/bin/bash
set -o errexit   # abort on nonzero exit status
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

docker compose -f /opt/conf/mongo.docker-compose.yml up -d
sleep 5
docker exec mongo1 mongosh --eval 'rs.initiate({_id: "rs0", members: [{ _id: 0, host: "database:27017" }, { _id: 1, host: "database:27018" }, { _id: 2, host: "database:27019" }]})'
sleep 10
docker exec mongo1 mongosh --eval 'db = db.getSiblingDB("rocketchat"); db.testCollection.insertOne({message: "Hello World"});'
docker exec mongo1 mongosh admin --eval 'db = db.getSiblingDB("admin"); db.createUser({ user: "rocket-app", pwd: "rocketpassword", roles: [{ role: "dbOwner", db: "rocketchat" }] })'

# docker exec -it mongo1 mongosh

