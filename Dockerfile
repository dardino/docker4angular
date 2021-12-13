FROM node:lts-alpine

LABEL version="0.0.9"
LABEL name=dardino/angular:0.0.9

LABEL "@angular/cli"=13.1.1
LABEL "create-react-app"=4.0.3
LABEL "express"=4.17.1
LABEL "less"=4.1.2
LABEL "node-sass"=7.0.0
LABEL "npm-cli-login"=1.0.0
LABEL "sass"=1.45.0
LABEL "stylus"=0.55.0
LABEL "typescript"=4.5.3
LABEL "webdriver-manager"=12.1.8
LABEL "webpack-cli"=4.9.1
LABEL "full-icu"=1.4.0
LABEL "cross-env"=7.0.3
LABEL "webpack"=5.65.0


## ## ## ## ## ## ## ## ## REPOSITORIES
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main      >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/testing   >> /etc/apk/repositories
## ## ## ## ## ## ## ## ## END REPOSITORIES


## ## ## ## ## ## ## ## ## JAVA
RUN apk update
RUN apk fetch openjdk8
RUN apk add --no-cache openjdk8 yarn bash openssl zip unzip wget curl
## ## ## ## ## ## ## ## ## FINE JAVA

## ## ## ## ## ## ## ## ## SONAR
ENV VERSION=3.3.0.1492 \
    PATH=$PATH:/opt/sonar-scanner/bin

RUN apk add --no-cache --virtual=.run-deps bash ca-certificates git nodejs python3 py3-pip && \
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
RUN apk add --no-cache  mesa-gles@edge       \ 
                        chromium@edge        \ 
                        nss@edge             \
                        freetype@edge        \ 
                        freetype-dev@edge    \
                        harfbuzz@edge        \ 
                        ca-certificates@edge \
                        ttf-freefont@edge    \ 
                        chromium-chromedriver@edge
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/lib/chromium/
RUN rm -rf /var/cache/* && \
    mkdir /var/cache/apk && \
    yarn global add webdriver-manager@12.1.8
RUN alias chrome=/usr/bin/chromium-browser
## ## ## ## ## ## ## ## ## END CHROME

## ## ## ## ## ## ## ## ## Nodejs packages
RUN yarn global add @angular/cli@13.1.1  && \
    yarn global add create-react-app@4.0.3  && \
    yarn global add express@4.17.1  && \
    yarn global add less@4.1.2  && \
    yarn global add node-sass@7.0.0  && \
    yarn global add npm-cli-login@1.0.0  && \
    yarn global add sass@1.45.0  && \
    yarn global add stylus@0.55.0  && \
    yarn global add typescript@4.5.3  && \
    yarn global add webpack-cli@4.9.1  && \
    yarn global add full-icu@1.4.0  && \
    yarn global add cross-env@7.0.3  && \
    yarn global add webpack@5.65.0  && \
    webdriver-manager update
ENV NODE_ICU_DATA=/usr/local/share/.config/yarn/global/node_modules/full-icu
## ## ## ## ## ## ## ## ## END Angular

## ## ## ## ## ## ## ## ## FontForge
RUN apk add fontforge@edge
## ## ## ## ## ## ## ## ## END FontForge

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

CMD [ "bash" ]
