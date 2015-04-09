FROM alpine:3.1

ENV NODEJS_VERSION 0.12.2

RUN echo "==> Installing dependencies..." \
 && apk update \
 && apk add \
    curl make gcc g++ python paxctl \
    musl-dev openssl-dev zlib-dev \
 && mkdir -p /root/nodejs \
 && cd /root/nodejs \
 && echo "==> Downloading..." \
 && curl -sSL http://nodejs.org/dist/v${NODEJS_VERSION}/node-v${NODEJS_VERSION}.tar.gz | tar -xz \
 && cd node-* \
 && echo "==> Configuring..." \
 && readonly NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) \
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
 && apk del \
    curl make gcc g++ python paxctl \
    musl-dev openssl-dev zlib-dev \
 && apk add \
    openssl libgcc libstdc++ \
 && rm -rf /var/cache/apk/* \
 && rm -rf /root/nodejs
