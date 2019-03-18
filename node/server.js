'use strict';

const bodyParser = require('body-parser');
const express = require('express');
const routes = require('./lib').routes;

const app = express();

const host = '0.0.0.0';
const port = 3001; // dev port

// Add middlewares here
app.use(bodyParser.urlencoded({
  extended: false,
}));
app.use(bodyParser.json());

// Add routes here
app.use('/api', routes.api);
app.use('/v1', routes.v1);

// Start the web server
const listener = app.listen(process.env.PORT || port, host, () => {
  console.log(`Server is listening on port: ${listener.address().port}`);
});
