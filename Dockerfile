FROM node:16-alpine as build-stage

WORKDIR /app

RUN npm install -g @vue/cli;

# Install app dependencies
# Copy package.json and package-lock.json before other files
# Utilize Docker cache to save re-installing dependencies if unchanged
COPY package.json package-lock.json /app/
RUN npm install
# Copy the rest of your app's source code from your host to your image filesystem.
COPY . .

RUN npm run build

####
# Production stage
####
FROM 333travel/nginx-baseline:latest

#copy only builded files
COPY --from=build-stage /app/dist /var/www/html