FROM quay.io/app-sre/ubi8-nodejs-12 as builder

RUN mkdir /tmp/src
WORKDIR /tmp/src

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

FROM quay.io/app-sre/nginx:latest
COPY --from=builder /tmp/src/build /usr/share/nginx/html/insights/advisor/
RUN mkdir -p /usr/share/nginx/html/apps/
RUN ln -s /usr/share/nginx/html/insights/advisor/ /usr/share/nginx/html/apps/chrome
