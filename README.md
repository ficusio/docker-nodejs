This repository contains Dockerfiles for [ficusio/nodejs-base](https://hub.docker.com/u/ficusio/nodejs-base/) and [ficusio/nodejs](https://hub.docker.com/u/ficusio/nodejs/) images, both ~36MB virtual size.

### `ficusio/nodejs-base`

This image contains NodeJS v0.11.16 and npm v2.3.0. It is based on [Alpine linux](https://registry.hub.docker.com/u/alpinelinux/base/), which, despite being a very lightweight distribution, provides [`apk` package manager](http://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management), allowing to esaily install many [pre-built packages](http://forum.alpinelinux.org/packages).

### `ficusio/nodejs`

This image is an extended version of `ficusio/nodejs-base`. It uses `ONBUILD` hooks to automatically install NPM-managed dependencies and copy application files to the resulting Docker image. Heavily inspired by [google/nodejs-runtime](https://github.com/GoogleCloudPlatform/nodejs-docker/tree/master/runtime) image.

See [this example application](https://github.com/ficusio/docker-nodejs/tree/master/_example) and its [Dockerfile](https://github.com/ficusio/docker-nodejs/blob/master/_example/Dockerfile) for an example of usage.
