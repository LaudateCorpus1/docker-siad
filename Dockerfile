FROM alpine:latest

RUN apk add --update wget zip && \
    wget https://github.com/NebulousLabs/Sia/releases/download/v1.3.3/Sia-v1.3.3-linux-amd64.zip && \
    unzip Sia-v1.3.3-linux-amd64.zip

FROM node:8.1-slim

WORKDIR /usr/src/app

COPY --from=0 /Sia-v1.3.3-linux-amd64/siad /usr/bin/siad
COPY --from=0 /Sia-v1.3.3-linux-amd64/siac /usr/bin/siac

RUN mkdir -p /usr/src/app /siad/data
COPY ["node-proxy/package.json", "node-proxy/package-lock.json", "/usr/src/app/"]
RUN npm i && npm cache clean --force

COPY node-proxy /usr/src/app

EXPOSE 9980
EXPOSE 9981
EXPOSE 9982

VOLUME "/siad/data"

ENTRYPOINT ["node", "/usr/src/app/index.js"]
