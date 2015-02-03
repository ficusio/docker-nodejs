var koa = require('koa'),
  app = koa(),
  Router = require('koa-router'),
  router = new Router(),
  send = require('koa-send'),
  path = require('path'),
  exec = require('mz/child_process').exec;


router.get('/', function*() {
  this.body = '<html><body>' +
    '<a href="/package.json">Show package.json</a><br>' +
    '<a href="/ls">Show node_modules directory</a><br>' +
  '</body></html>';
});

router.get('/package.json', function*() {
  yield send(this, path.resolve(__dirname, '..', 'package.json'));
});

router.get('/ls', function*() {
  var output = yield exec('ls -la node_modules');
  this.body = '$ ls -la node_modules\n' + output[0];
});


app.use(function*(next) {
  console.log(this.method + ' ' + this.path + this.request.search);
  var t0 = process.hrtime(), dt, dtMs;
  yield* next;
  dt = process.hrtime(t0);
  dtMs = Math.round(dt[0]*1e6 + dt[1]/1e3)/1e3;
  this.set('X-Response-Time', dtMs + ' ms');
});

app.use(router.middleware());


require('http').createServer(app.callback())

.on('error', function(err) {
  console.log('error starting server:', err);
})

.listen(3000, function() {
  console.log('listening on port 3000');
});


exitOnSignal('SIGINT');
exitOnSignal('SIGTERM');


function exitOnSignal(signal) {
  process.on(signal, function() {
    console.log('\ncaught ' + signal + ', exiting');
    process.exit(1);
  });
}
