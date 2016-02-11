FROM alpine:3.3

ENV NODEJS_VERSION=4.2.4 \
    NPM_VERSION=3.7

RUN info(){ printf '\n--\n%s\n--\n\n' "$*"; } \
 && info "==> Installing Node..." \
 && apk add --update nodejs \
 && info "==> Updating NPM..." \
 && npm i -g npm@$NPM_VERSION \
 && info "==> Cleaning up..." \
 && npm cache clean \
 && rm -rf ~/.node-gyp /tmp/* /usr/share/man /var/cache/apk/* \
    /usr/lib/node_modules/npm/man /usr/lib/node_modules/npm/doc \
    /usr/lib/node_modules/npm/html /root/nodejs \
 && echo 'Done! =)'
