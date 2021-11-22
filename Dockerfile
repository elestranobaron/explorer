FROM ubuntu:20.04
COPY . /explorer
WORKDIR /explorer

#shared libraries and dependencies
RUN apt update
RUN apt-get install -y nodejs-legacy
RUN apt-get install -y npm

#get add-apt-repository
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA392127

#mongodb
RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
RUN apt-get update
RUN apt-get install -y mongodb-org

#build explorer
RUN service mongod
RUN npm install forever -g

RUN mongo explorerdb mongo.js
RUN npm install --production
#open service port
EXPOSE 9999 19999
CMD ["muscleupcoind", "--printtoconsole"]