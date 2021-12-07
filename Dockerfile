esimon@leap15-2:~/Documents/techniques/informatique/developpement/docker> cat Dockerfile
FROM alpine:3.14
RUN apk update
RUN apk add --no-cache git
ENTRYPOINT ["git"]
