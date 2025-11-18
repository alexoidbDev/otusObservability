### Rocket.Chat configuration
### https://github.com/RocketChat/Docker.Official.Image/blob/master/env.example

### only if you will use registry.rocket.chat/rocketchat/rocket.chat
# export RELEASE=6.12.1 # https://github.com/RocketChat/Rocket.Chat/releases

export MONGO_URL=mongodb://database:27017,database:27018,database:27019/rocketchat?replicaSet=rs0
export MONGO_OPLOG_URL=mongodb://database:27017,database:27018,database:27019/local?replicaSet=rs0
export PORT=3000
export ROOT_URL="http://192.168.250.10:8080" # load balancer addr
export INSTANCE_IP=$(ip -o -4 addr show enp0s8 | awk '{print $4}' | cut -d/ -f1) #${HOSTNAME}
export TCP_PORT=3100 # for communication between nodes
export HOST_PORT=3000
export ADMIN_USERNAME=chatmaster
export ADMIN_NAME="admin"
export ADMIN_EMAIL=chatmaster@localhost.com
export ADMIN_PASS=chatmasterassword
export INITIAL_USER=yes

export REG_TOKEN=8024fe1b-7605-43f6-848b-9c9f5379a344