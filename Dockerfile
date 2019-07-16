FROM node:lts-alpine

LABEL version="1.1"
LABEL name=dardino/angular:1.1

## ## ## ## ## ## ## ## ## REPOSITORIES
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main      >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/testing   >> /etc/apk/repositories
## ## ## ## ## ## ## ## ## END REPOSITORIES


## ## ## ## ## ## ## ## ## JAVA
RUN apk update
RUN apk fetch openjdk8
RUN apk add openjdk8
RUN apk add yarn
RUN apk add bash
## ## ## ## ## ## ## ## ## FINE JAVA

## ## ## ## ## ## ## ## ## SONAR
ENV VERSION=3.3.0.1492 \
    PATH=$PATH:/opt/sonar-scanner/bin

RUN apk add --no-cache --virtual=.run-deps bash ca-certificates git nodejs python3 && \
    apk add --no-cache --virtual=.build-deps build-base python3-dev unzip wget && \
    python3 -m pip install --upgrade pip && \
    python3 -m pip install pylint~=2.2.2 && \
    wget -O /tmp/sonar.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$VERSION-linux.zip && \
    unzip /tmp/sonar.zip -d /tmp && \
    mkdir -p /opt/sonar-scanner && \
    cp -R /tmp/sonar-scanner-$VERSION-linux/* /opt/sonar-scanner/ && \
    sed -i 's/use_embedded_jre=true/use_embedded_jre=false/' $(which sonar-scanner) && \
    apk del .build-deps && \
    rm -rf /tmp/* /opt/sonar-scanner/jre/
## ## ## ## ## ## ## ## ## END SONAR

## ## ## ## ## ## ## ## ## CHROME
RUN apk update && apk upgrade
RUN apk add --no-cache    chromium@edge    harfbuzz@edge    nss@edge    freetype@edge    ttf-freefont@edge    chromium-chromedriver
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/lib/chromium/
RUN rm -rf /var/cache/* && \
    mkdir /var/cache/apk && \
    yarn global add webdriver-manager
## ## ## ## ## ## ## ## ## END CHROME

## ## ## ## ## ## ## ## ## Angular
RUN yarn global add @angular/cli && \
    yarn global add webpack && \
    yarn global add webpack-cli && \
    yarn global add node-sass && \
    yarn global add sass && \
    yarn global add stylus && \
    yarn global add less && \
    yarn global add typescript && \
    yarn global add create-react-app && \
    yarn global add npm-cli-login && \
    webdriver-manager update
## ## ## ## ## ## ## ## ## END Angular

## ## ## ## ## ## ## ## ## FontForge
RUN apk add fontforge@edge
## ## ## ## ## ## ## ## ## END FontForge

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

CMD [ "node" ]

