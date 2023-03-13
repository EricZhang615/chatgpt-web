# build front-end
FROM node:lts-alpine AS frontend

RUN npm install pnpm -g

WORKDIR /app

COPY ./package.json /app

COPY ./pnpm-lock.yaml /app

RUN pnpm install

COPY . /app

RUN pnpm run build

# build backend
FROM node:lts-alpine as backend

RUN npm install pnpm -g

WORKDIR /app

<<<<<<< HEAD
RUN npm config set registry http://registry.npmmirror.com

RUN npm install pnpm -g && pnpm install && pnpm run build
=======
COPY /service/package.json /app

COPY /service/pnpm-lock.yaml /app

RUN pnpm install

COPY /service /app

RUN pnpm build
>>>>>>> main

RUN pnpm config set registry http://registry.npmmirror.com

# service
FROM node:lts-alpine

RUN npm install pnpm -g

WORKDIR /app
<<<<<<< HEAD
RUN npm install pnpm -g --loglevel verbose && pnpm install --loglevel verbose
=======

COPY /service/package.json /app

COPY /service/pnpm-lock.yaml /app

RUN pnpm install --production && rm -rf /root/.npm /root/.pnpm-store /usr/local/share/.cache /tmp/*

COPY /service /app

COPY --from=frontend /app/dist /app/public

COPY --from=backend /app/build /app/build
>>>>>>> main

EXPOSE 3002

CMD ["pnpm", "run", "prod"]
