FROM ubuntu:16.04

# add user group, user and make user home dir
RUN groupadd --gid 1000 yapi && \
    useradd --uid 1000 --gid yapi --shell /bin/bash --create-home yapi

# set pwd to yapi home dir
WORKDIR /home/yapi

# install dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential \
    python \
    wget \
    git \
    apt-transport-https \
    ca-certificates

# install nodejs
RUN wget http://cdn.npm.taobao.org/dist/node/v11.15.0/node-v11.15.0-linux-x64.tar.gz && \
    tar -xzvf node-v11.15.0-linux-x64.tar.gz && \
    ln -s /home/yapi/node-v11.15.0-linux-x64/bin/node /usr/local/bin/node && \
    ln -s /home/yapi/node-v11.15.0-linux-x64/bin/npm /usr/local/bin/npm

RUN mkdir -p /home/yapi/log

RUN chown -R yapi:yapi /home/yapi/log && \
    chown -R yapi:yapi /home/yapi/node-v11.15.0-linux-x64

VOLUME ["/home/yapi/log"]

# download yapi source code
USER yapi

RUN mkdir yapi && \
    wget https://github.com/YMFE/yapi/archive/v1.8.5.tar.gz && \
    tar -xzvf v1.8.5.tar.gz -C yapi --strip-components 1

# npm install dependencies and run build
WORKDIR /home/yapi/yapi

RUN npm install && \
    npm install -g yapi-cli --registry https://registry.npm.taobao.org && \
    /home/yapi/node-v11.15.0-linux-x64/bin/yapi plugin --name yapi-plugin-gitlab
