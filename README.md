[![](https://badge.imagelayers.io/ficusio/node-alpine:latest.svg)](https://imagelayers.io/?images=ficusio/node-alpine:latest 'Get your own badge on imagelayers.io')

This repository contains Dockerfiles for [ficusio/node-alpine] image, which is ~33MB
in virtual size.

[ficusio/node-alpine]: https://hub.docker.com/r/ficusio/node-alpine/


#### `node-alpine:latest, node-alpine:5.7, node-alpine:5`

This image contains Node.js v5.7 and NPM v3.7. It is based on [Alpine linux], which, despite
being a very lightweight distribution, provides [`apk` package manager], allowing easy
installation of many [pre-built packages].

[Alpine linux]: https://hub.docker.com/r/library/alpine/
[`apk` package manager]: http://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management
[pre-built packages]: https://pkgs.alpinelinux.org/packages


#### `node-alpine:onbuild, node-alpine:5.7-onbuild, node-alpine:5-onbuild`

This is an extended version of `node-alpine`, with added `ONBUILD` triggers (similar to and
inspired by [google/nodejs-runtime] image). These triggers execute on each build of a derived
image, and perform two tasks:

* Copy everything from the directory containing `Dockerfile` to the `/app` directory inside
  the container, but skip `node_modules` directory and all files/dirs listed in the
  `.dockerignore` file;
* Install NPM-managed dependencies; reuse Docker image cache if dependencies have not changed
  since previous build.

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

The image's [Dockerfile](onbuild/Dockerfile) contains comments that explain all steps performed
by these triggers. There is also [an example application](_example) which uses this image as a base.

[google/nodejs-runtime]: https://github.com/GoogleCloudPlatform/nodejs-docker/tree/master/runtime


## Known problems

There is [an issue](https://github.com/joyent/node/issues/9131) with Node.js/Docker combination
which prevents Node from exiting on `INT` and `TERM` signals when it runs inside a Docker
container. It can be worked around by manually handling these signals in the app, which is
a useful thing anyway:

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


## Contributing

PRs and issues are welcome!

### Updating Node.js and/or NPM version

* Edit [base/Dockerfile](base/Dockerfile) and change `NODEJS_VERSION`, `NODEJS_SHA256`
  and `NPM_VERSION` variables.
* If you've changed major or patch version of Node, edit [.tags](.tags) file to reflect
  this change. Then, update `FROM` instruction in [onbuild/Dockerfile](onbuild/Dockerfile)
  to match the new `$major.$minor` tag.

### Building

1. To build new version, run `./make build`. It will build new `base` and `onbuild` variations
   and tag them as `$image:$variation-build`, where `$image` comes from the [.image](.image)
   file.

2. To tag images built in the previous step, run `./make tag`. It will tag each
   `$image:$variation-build` image as `$image:$tag-$variation`, for each `$tag` listed in the
   [.tags](.tags) file. The exception to this rule is `base` variation, which gets tagged as
   `$image:$tag`.

3. To push images tagged in step 2, run `./make push`. You'll need push access to the `$image`
   Docker Hub repository.

To perform all these steps at once, run `./make all`.
