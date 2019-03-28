'use strict';

/**
 * This file is used to create a single db object that will be used
 * throughout the project
 */
const Promise = require('bluebird');

const initOptions = {
  promiseLib: Promise,
};

const pgp = require('pg-promise')(initOptions);
const cn = require('./conf.json'); // Store the config file

cn.host = process.env.PGHOST;

const db = pgp(cn);

// Check whether the connection to DB succeeded or not
db.proc('version')
    .then(() => {
      console.log('DB Connected');
    })
    .catch((error) => {
      console.log('Error connecting to DB: ', error);
    });

module.exports = db;
