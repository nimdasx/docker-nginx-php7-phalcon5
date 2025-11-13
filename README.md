# docker nginx php-7.4 phalcon-5.0

```
phalcon 5.4 adalah versi terakhir yang support php 7.4

## build dan push ke github
docker build --tag ghcr.io/nimdasx/nginx-php7-phalcon5 .
docker push ghcr.io/nimdasx/nginx-php7-phalcon5

## build dan push ke docker hub
docker build --tag nimdasx/nginx-php7-phalcon5 .
docker push nimdasx/nginx-php7-phalcon5

docker buildx build --platform linux/amd64 --tag nimdasx/nginx-php7-phalcon5 --push .

## harbor
CR=harbor.sofy.web.id
PU=x/nginx-php7-phalcon5
docker login $CR
docker build -t $CR/$PU .
docker push $CR/$PU
docker buildx build --platform linux/amd64 --tag $CR/$PU --push . 
````