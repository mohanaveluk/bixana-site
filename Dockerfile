#stage 1
FROM node:20-alpine AS node
WORKDIR /app
COPY . .
RUN npm install --force
RUN export NODE_OPTIONS=--openssl-legacy-provider
RUN npm run build-prod
COPY ./web.config /app/dist/bixana-site
COPY ./web.config /app/dist/bixana-site

#stage 2
FROM nginx:1.23.0-alpine
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=node /app/dist/bixana-site /usr/share/nginx/html
# Expose the default Nginx port. Cloud Run will remap this to the PORT env var.
EXPOSE 8080 
# Command to start Nginx. 'daemon off;' keeps Nginx in the foreground, essential for Docker containers.
CMD ["nginx", "-g", "daemon off;"]