FROM node:lts-alpine

LABEL version="0.0.7"
LABEL name=dardino/angular:0.0.7
LABEL "full-icu"=1.3.1
LABEL "cross-env"=7.0.2
LABEL "@angular/cli"=10.1.1
LABEL "create-react-app"=3.4.1
LABEL "express"=4.17.1
LABEL "less"=3.12.2
LABEL "node-sass"=4.14.1
LABEL "npm-cli-login"=0.1.1
LABEL "sass"=1.26.1
LABEL "stylus"=0.54.8
LABEL "typescript"=4.0.2
LABEL "webpack-cli"=3.3.1
LABEL "webpack"=4.44.1


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
RUN apk add openssl
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
    yarn global add webdriver-manager@12.1.7
RUN alias chrome=/usr/bin/chromium-browser
## ## ## ## ## ## ## ## ## END CHROME

## ## ## ## ## ## ## ## ## Nodejs packages
RUN yarn global add full-icu@1.3.1             && \
    yarn global add cross-env@7.0.2            && \
    yarn global add @angular/cli@10.1.1        && \
    yarn global add create-react-app@3.4.1     && \
    yarn global add express@4.17.1             && \
    yarn global add less@3.12.2                && \
    yarn global add node-sass@4.14.1           && \
    yarn global add npm-cli-login@0.1.1        && \
    yarn global add sass@1.26.10               && \
    yarn global add stylus@0.54.8              && \
    yarn global add typescript@4.0.2           && \
    yarn global add webpack-cli@3.3.12         && \
    yarn global add webpack@4.44.1             && \
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
