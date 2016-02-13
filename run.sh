eval "$(docker-machine env tech-com)"
docker-compose up
docker-osx-dev

#traefic
eval (docker-machine env tech-com)
docker run -d -p 8080:8080 -p 80:80 -v $PWD/traefik.toml:/traefik.toml emilevauge/traefik
