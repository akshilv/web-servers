'use strict';

const _ = require('lodash');

const BaseController = require('./BaseController');
const db = require('../db').db;

// List of SQL queries
const _qInsertUserIntoUsers = 'INSERT INTO users(user_id, user_name) ' +
  'VALUES($1, $2)';
const _qSelectUserFromUsers = 'SELECT user_id, user_name FROM users WHERE ' +
  'user_name = $1';

/**
 * Controller for /v1 routes
 * @class
 */
class V1Controller extends BaseController {
  /**
   * Constructor for V1Controller
   * @constructor
   */
  constructor() {
    super();
  }

  /**
   * Get a user's details
   * @param {object} req
   * @param {object} res
   */
  getUser(req, res) {
    console.log('get user');
    db.one(_qSelectUserFromUsers, req.params.user)
        .then((user) => {
          console.log('User is: ', user);
          res.status(200).send(user);
        })
        .catch((error) => {
          res.status(400).send('Error: ' + JSON.stringify(error));
        });
  }

  /**
   * Create a user
   * @param {object} req
   * @param {object} res
   */
  createUser(req, res) {
    console.log('create user');
    if (_.has(req, 'body.user_id') && _.has(req, 'body.user_name')) {
      db.none(_qInsertUserIntoUsers, [req.body.user_id, req.body.user_name])
          .then(() => {
            console.log('User created');
            res.status(201).send('User created');
          })
          .catch((error) => {
            res.status(400).send('Error: ' + JSON.stringify(error));
          });
    } else {
      console.log('Incomplete parameters');
      res.status(400).send('Error: Incomplete parameters');
    }
  }

  /**
   * Delete a user
   * @param {object} req
   * @param {object} res
   */
  deleteUser(req, res) {
    console.log('delete user');
  }

  /**
   * Update details of a user
   * @param {object} req
   * @param {object} res
   */
  updateUser(req, res) {
    console.log('update user');
  }
}

module.exports = V1Controller;
