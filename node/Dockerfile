FROM node:alpine
ARG APP_PORT
ENV NODE_ENV production
ENV PORT $APP_PORT
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install --production --silent
COPY . .
EXPOSE ${PORT}
CMD ["npm", "start"]