FROM node:lts-alpine

LABEL version="1.0"
LABEL name=dardino/angular:testing

## ## ## ## ## ## ## ## ## JAVA
RUN apk update
RUN apk fetch openjdk8
RUN apk add openjdk8
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
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main      >> /etc/apk/repositories
RUN apk update && apk upgrade
RUN apk add --no-cache    chromium@edge    harfbuzz@edge    nss@edge    freetype@edge    ttf-freefont@edge    chromium-chromedriver
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/lib/chromium/
RUN rm -rf /var/cache/* && \
    mkdir /var/cache/apk && \
    npm install -g webdriver-manager
## ## ## ## ## ## ## ## ## END CHROME

## ## ## ## ## ## ## ## ## Angular
RUN npm install -g @angular/cli && \
    npm install -g typescript && \
    webdriver-manager update
## ## ## ## ## ## ## ## ## END Angular


ENTRYPOINT [ "bin/sh" ]
