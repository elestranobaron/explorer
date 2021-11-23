FROM ubuntu:20.04
COPY . /explorer
WORKDIR /

#shared libraries and dependencies
ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt update
RUN apt install -y wget git
RUN apt-get install -y nodejs
RUN apt-get install -y npm

#get add-apt-repository
RUN wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -

#mongodb
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list
RUN apt-get update
RUN apt-get install -y mongodb-org


#open service port
EXPOSE 9999 19999
CMD mongod --fork -f /etc/mongod.conf && npm install forever -g && cd explorer && mongo explorerdb mongo.js && npm i -g npm-check-updates && ncu -u && npm install --production && cp encoding.js explorer/node_modules/whatwg-url/lib/encoding.js && cp database.js explorer/lib/database.js && forever start -c "npm start" ./