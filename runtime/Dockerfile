FROM ficusio/nodejs-base:0.12

WORKDIR /app
ONBUILD COPY package.json npm-shrinkwrap.json* /app/

# Install NPM deps first to allow reusing of Docker image cache when package.json
# is not changed:
#
# 1. install development deps that might be needed to compile binary Node.js modules;
# 2. install NPM-managed application deps, but don't install devDependencies;
# 3. remove development deps from step 1;
# 4. clear various NPM caches.
#
ONBUILD RUN deps="make gcc g++ python musl-dev" \
 && apk update \
 && apk add bash $deps \
 && npm install --production \
 && apk del $deps \
 && rm -rf /var/cache/apk/* \
 && npm cache clean \
 && rm -rf ~/.node-gyp /tmp/npm*

# Copy app files to a temporary dir to prevent just installed /app/node_modules
# from getting overwritten by the ones copied from developer's machine.
#
ONBUILD COPY . /tmp/app/

# Move app files from the temporary dir to WORKDIR.
#
# Bash and dotglob are here to move all files, including hidden ones.
# Which is surprisingly non-obvious operation.
#
ONBUILD RUN bash -c 'shopt -s dotglob \
 && rm -rf /tmp/app/{node_modules,Dockerfile,Makefile,.dockerignore} \
 && cp -pRf /tmp/app/* /app/ \
 && rm -rf /tmp/app'


CMD ["node", "index.js"]
