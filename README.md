# docker nginx php-7.4 phalcon-5.0
## catatan
````
docker run -d -p 80:80 -v /Users/sofyan/Dev/php:/app --name dinosaurus nimdasx/nginx-php7-phalcon5
````
## build dan push ke github
````
docker build --tag ghcr.io/nimdasx/nginx-php7-phalcon5 .
docker push ghcr.io/nimdasx/nginx-php7-phalcon5
````
## build dan push ke docker hub
````
docker build --tag nimdasx/nginx-php7-phalcon5 .
docker push nimdasx/nginx-php7-phalcon5
````