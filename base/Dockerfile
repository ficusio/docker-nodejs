FROM alpine:3.3

ENV NODEJS_VERSION 5.6.0

RUN echo "==> Installing dependencies..." \
 && apk update \
 && apk add --virtual build-deps \
    curl make gcc g++ python paxctl \
    musl-dev openssl-dev zlib-dev \
    linux-headers binutils-gold \
 && mkdir -p /root/nodejs \
 && cd /root/nodejs \
 && echo "==> Downloading..." \
 && curl -sSL http://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}.tar.gz | tar -xz \
 && cd node-* \
 && echo "==> Configuring..." \
 && readonly NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || echo 1) \
 && echo "using upto $NPROC threads" \
 && ./configure \
   --prefix=/usr \
   --shared-openssl \
   --shared-zlib \
 && make -j${NPROC} -C out mksnapshot \
 && paxctl -c -m out/Release/mksnapshot \
 && make -j${NPROC} \
 && echo "==> Installing..." \
 && make install \
 && echo "==> Finishing..." \
 && apk del build-deps \
 && apk add \
    openssl libgcc libstdc++ \
 && rm -rf /var/cache/apk/* \
 && echo "==> Updating NPM..." \
 && npm i -g npm \
 && npm cache clean \
 && rm -rf ~/.node-gyp /tmp/* \
 && rm -rf /root/nodejs
