FROM node:14.17.3 as builder
ENV BACKEND_URL=http://localhost:8080
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM node:alpine as app
EXPOSE 80
WORKDIR /app
RUN npm install -g http-server
COPY --from=builder /usr/src/app/dist .
ENTRYPOINT http-server /app/frontend -p 80 --proxy ${BACKEND_URL}
EXPOSE 80
