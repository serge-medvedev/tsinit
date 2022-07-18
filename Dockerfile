FROM node:18

RUN npm install -g npm@8.14.0 \
    && apt-get update \
    && apt-get install -y jq \
    && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

