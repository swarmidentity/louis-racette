FROM node:14.16.0-alpine as builder

RUN apk add --no-cache python make g++

COPY . ./app

WORKDIR /app

RUN npm ci

FROM node:14.16.0-alpine as app

COPY --from=builder ./app ./app

RUN apk --no-cache add curl

WORKDIR /app

EXPOSE 3000

CMD ["node", "index.js"]
