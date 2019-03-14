'use strict';

const express = require('express');
const bodyParser = require('body-parser');

const app = express();

const port = 3000;

app.use(bodyParser.urlencoded({
  extended: false,
}));
app.use(bodyParser.json());

app.get('/', (req, res) => {
  res.status(200).send('done');
});

// Start the web server
const listener = app.listen(process.env.PORT || port, () => {
  console.log(`Server is listening on port: ${listener.address().port}`);
});
