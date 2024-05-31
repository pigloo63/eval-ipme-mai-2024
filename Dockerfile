FROM node:21 as base

# Build stage
FROM base as build
WORKDIR /app
ADD package.json ./
COPY . .
COPY --chown=node:node ./package*.json ./
RUN npm install -D ts-node && \
    yarn install && \
    yarn run build

# Production stage
FROM base
ENV NODE_ENV=production
WORKDIR /app
COPY --chown=node:node ./package*.json ./
COPY --from=build /app .
EXPOSE 3333
CMD ["node", "ace", "migration:run"]
CMD ["node", "./build/bin/server.js"]
