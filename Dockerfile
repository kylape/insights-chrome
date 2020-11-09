FROM quay.io/app-sre/ubi8-nodejs-12 as builder
# FROM node:15.1.0 as builder

RUN mkdir /tmp/src
WORKDIR /tmp/src

# USER root
ADD package.json package-lock.json .
ADD .git/ .git
ADD profiles/ profiles
ADD static/ static/
ADD config/ config
ADD scripts/ scripts
ADD src/ src
ADD .eslintrc.yml .stylelintrc.json .babelrc .
RUN npm install
RUN npm run build-dev

FROM redhatinsights/insights-proxy:latest
COPY --from=builder /tmp/src/build /chrome
