#stage 1
FROM node:20-alpine AS node
WORKDIR /app
COPY . .
RUN npm install --force
RUN NODE_OPTIONS=--openssl-legacy-provider npm run build-prod
COPY ./web.config /app/dist/bixana-site

#stage 2
FROM nginx:1.23.0-alpine
EXPOSE 8080
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=node /app/dist/bixana-site /usr/share/nginx/html
# Expose the default Nginx port. Cloud Run will remap this to the PORT env var.
