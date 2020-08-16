FROM node:10-alpine AS BUILD_IMAGE
# couchbase sdk requirements
RUN apk update && apk add python make g++ && rm -rf /var/cache/apk/*

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

FROM node:10-alpine
RUN apk update && apk add bash && rm -rf /var/cache/apk/*


WORKDIR /usr/src/app

# copy from build image
COPY --from=BUILD_IMAGE /usr/src/app .
RUN chmod +x wait-for-it.sh


EXPOSE 3000
CMD [ "node", "./bin/www" ]

