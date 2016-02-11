[![](https://badge.imagelayers.io/ficusio/node-alpine:latest.svg)](https://imagelayers.io/?images=ficusio/node-alpine:latest 'Get your own badge on imagelayers.io')

This repository contains Dockerfiles for [ficusio/node-alpine](https://hub.docker.com/r/ficusio/node-alpine/) image, which is ~37MB in virtual size.

#### `node-alpine:latest, node-alpine:5.6, node-alpine:5`

This image contains Node.js v5.6.0 and NPM v3.7.1. It is based on [Alpine linux](https://hub.docker.com/r/library/alpine/), which, despite being a very lightweight distribution, provides [`apk` package manager](http://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management), allowing easy installation of many [pre-built packages](https://pkgs.alpinelinux.org/packages).

#### `node-alpine:onbuild, node-alpine:5.6-onbuild, node-alpine:5-onbuild`

This is an extended version of `node-alpine`, with added `ONBUILD` triggers (similar to and inspired by [google/nodejs-runtime](https://github.com/GoogleCloudPlatform/nodejs-docker/tree/master/runtime) image). These triggers execute on each build of a derived image, and perform two tasks:

* Copy everything from the directory containing `Dockerfile` to the `/app` directory inside the container, but skip `node_modules` directory and all files/dirs listed in the `.dockerignore` file;
* Install NPM-managed dependencies; reuse Docker image cache if dependencies have not changed since previous build.

This allows Dockerfiles of derived images to contain less boilerplate instructions:

```dockerfile
FROM ficusio/node-alpine:5-onbuild
EXPOSE 8080
# This will be performed automatically:
# WORKDIR /app
# COPY . /app
# npm install --production
# CMD ["node", "index.js"]
```

The image's [Dockerfile](onbuild/Dockerfile) contains comments that explain all steps performed by these triggers. There is also [an example application](_example) which uses this image as a base.

### Known problems

There is [an issue](https://github.com/joyent/node/issues/9131) with Node.js/Docker combination which prevents Node from exiting on `INT` and `TERM` signals when it runs inside a Docker container. It can be worked around by manually handling these signals in the app, which is a useful thing anyway:

```js
exitOnSignal('SIGINT');
exitOnSignal('SIGTERM');

function exitOnSignal(signal) {
  process.on(signal, function() {
    console.log('\ncaught ' + signal + ', exiting');
    // perform all required cleanup
    process.exit(1);
  });
}
```
