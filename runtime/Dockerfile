FROM ficusio/nodejs-base:latest

WORKDIR /app

ONBUILD COPY package.json npm-shrinkwrap.json* /app/
ONBUILD RUN npm install --production

# Use temporary dir to prevent just installed /app/node_modules
# from getting overwritten by ones copied from developer's machine.
#
ONBUILD COPY . /tmp/app/

# Bash and dotglob are here to move all files, including hidden ones.
# Which is surprisingly non-obvious operation.
#
ONBUILD RUN bash -c 'shopt -s dotglob \
 && rm -rf /tmp/app/{node_modules,Dockerfile} \
 && mv -f /tmp/app/* ./ \
 && rmdir /tmp/app'

CMD ["node", "index.js"]
