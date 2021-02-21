FROM node:12

RUN mkdir -p /app

COPY . /app

WORKDIR /app

ENTRYPOINT ["npm", "start"]
