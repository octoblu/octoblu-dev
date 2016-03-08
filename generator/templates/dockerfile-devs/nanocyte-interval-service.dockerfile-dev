FROM node:5
MAINTAINER Octoblu <docker@octoblu.com>

EXPOSE 80

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN npm install --production

CMD [ "npm", "start" ]
