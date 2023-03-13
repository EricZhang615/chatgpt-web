# build front-end
FROM node:lts-alpine AS builder

COPY ./ /app
WORKDIR /app

RUN npm config set registry http://registry.npmmirror.com

RUN npm install pnpm -g && pnpm install && pnpm run build

RUN pnpm config set registry http://registry.npmmirror.com

# service
FROM node:lts-alpine

COPY /service /app
COPY --from=builder /app/dist /app/public

WORKDIR /app
RUN npm install pnpm -g --loglevel verbose && pnpm install --loglevel verbose

EXPOSE 3002

CMD ["pnpm", "run", "start"]