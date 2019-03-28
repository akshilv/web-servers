FROM node:alpine
ENV NODE_ENV production
ENV PORT 4000
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "./"]
RUN npm install --production --silent
COPY . .
EXPOSE ${PORT}
CMD ["npm", "start"]