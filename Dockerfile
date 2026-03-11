#STAGE 1
FROM node:18-alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm install



#STAGE 2
FROM node:18-alpine

COPY --from=build /app/node_modules ./node_modules

COPY . .

EXPOSE 3000

USER node

CMD ["node", "server.js"]

