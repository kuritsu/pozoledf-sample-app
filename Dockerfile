FROM node:12

RUN mkdir -p /app

COPY . /app

WORKDIR /app

RUN npm install

ENTRYPOINT ["npm", "start"]
