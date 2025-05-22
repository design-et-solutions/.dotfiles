export DISPLAY=:0
xhost +local:docker

docker stop sight-container
docker container rm sight-container
docker run \
  --network host \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --device /dev/dri:/dev/dri \
  --name sight-container sight-image
