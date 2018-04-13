IMAGENAME=$1
docker images | grep ${IMAGENAME} | awk '{print $1 }' | xargs -I {} docker stop {}
docker rm $(docker ps -a -q)
docker ps -a | awk '{ print $1,$2 }' | grep ${IMAGENAME} | awk '{print $1 }' | xargs -I {} docker rm {}