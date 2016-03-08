FROM node:5
MAINTAINER Octoblu, Inc. <docker@octoblu.com>

EXPOSE 80

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD https://meshblu.octoblu.com/publickey /usr/src/app/public-key.json

COPY package.json /usr/src/app/
RUN npm -s install --production
COPY . /usr/src/app/

CMD [ "node", "command.js" ]
