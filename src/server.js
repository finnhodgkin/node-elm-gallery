const hapi = require('hapi');
const inert = require('inert');
const router = require('./router');

const server = new hapi.Server();

server.connection({
  port: process.env.PORT || 4000,
});

server.register([inert], err => {
  if (err) throw err;

  server.route(router);
});

module.exports = server;
