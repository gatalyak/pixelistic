FROM node:10-alpine as builder

# install and cache app dependencies
COPY package.json package-lock.json ./
RUN npm install && mkdir /pixelistic_fe && mv ./node_modules ./pixelistic_fe

WORKDIR /pixelistic_fe

COPY . .

RUN npm run build



# ------------------------------------------------------
# Production Build
# ------------------------------------------------------
#FROM nginx:1.17.0-alpine
#COPY --from=builder /pixelistic_fe/build /usr/share/nginx/html
#RUN rm /etc/nginx/conf.d/default.conf
#COPY nginx/nginx.conf /etc/nginx/conf.d
#EXPOSE 80
#CMD ["nginx", "-g", "daemon off;"]


