# 🔧 Stage 1: Build the React app
FROM node:20-alpine as build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

RUN npm run build

# 🚀 Stage 2: Serve using optimized NGINX
FROM nginx:alpine

# Remove default nginx config
RUN rm -rf /etc/nginx/conf.d

# Add custom nginx config
COPY nginx.conf /etc/nginx/conf.d

# Copy the built React files
COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
