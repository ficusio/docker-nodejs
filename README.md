This repository contains Dockerfiles for [ficusio/nodejs-base](https://hub.docker.com/u/ficusio/nodejs-base/) and [ficusio/nodejs](https://hub.docker.com/u/ficusio/nodejs/) images, both ~36MB virtual size.

### `nodejs-base`

This image contains Node.js v0.11.16 and NPM v2.3.0. It is based on [Alpine linux](https://registry.hub.docker.com/u/alpinelinux/base/), which, despite being a very lightweight distribution, provides [`apk` package manager](http://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management), allowing easy installation of many [pre-built packages](http://forum.alpinelinux.org/packages).

### `nodejs`

This is an extended version of `nodejs-base`, with added `ONBUILD` triggers (similar to and inspired by [google/nodejs-runtime](https://github.com/GoogleCloudPlatform/nodejs-docker/tree/master/runtime) image). These triggers execute on each build of an image that is based on `ficusio/nodejs`, and perform two tasks:

* Copy everything from the directory containing `Dockerfile` to the `/app` directory inside the container, but skip `node_modules` directory and all files/dirs listed in the `.dockerignore` file;
* Install NPM-managed dependencies; reuse Docker image cache if dependencies have not changed since previous build.

This allows Dockerfiles of derived images to contain less boilerplate instructions:

```dockerfile
FROM ficusio/nodejs:latest
EXPOSE 8080
# This will be performed automatically:
# WORKDIR /app
# COPY . /app
# npm install --production
# CMD ["node", "index.js"]
```

The image's [Dockerfile](https://github.com/ficusio/docker-nodejs/blob/master/runtime/Dockerfile) contains comments that explain all steps performed by these triggers. There is also [an example application](https://github.com/ficusio/docker-nodejs/tree/master/_example) which uses this image as a base.

### Known problems

There is [an issue](https://github.com/joyent/node/issues/9131) in Node.js v0.11.16 which prevents it from exiting on `INT` and `TERM` signals when it runs inside a Docker container. This can be mitigated by manually handling these signals (which is a useful thing anyways):

```js
exitOnSignal('SIGINT');
exitOnSignal('SIGTERM');

function exitOnSignal(signal) {
  process.on(signal, function() {
    console.log('\ncaught ' + signal + ', exiting');
    process.exit(1);
  });
}
```
