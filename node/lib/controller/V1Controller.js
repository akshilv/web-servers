'use strict';

const _ = require('lodash');

const BaseController = require('./BaseController');
const db = require('../db').db;

// List of SQL queries
const _qInsertUserIntoUsers = 'INSERT INTO users(user_id, user_name) ' +
  'VALUES($1, $2)';
const _qSelectUserFromUsers = 'SELECT user_id, user_name FROM users WHERE ' +
  'user_name = $1';
const _qDeleteUserFromUsers = 'DELETE FROM users WHERE user_id = $1 AND ' +
  'user_name = $2';
const _qPatchUserFromUsers = 'UPDATE users SET user_name = $1 WHERE ' +
  'user_id = $2 AND user_name = $3';

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
    db.one(_qSelectUserFromUsers, [req.params.user])
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
    if (_.has(req, 'query.user_id')) {
      db.none(_qDeleteUserFromUsers, [req.query.user_id, req.params.user])
          .then(() => {
            console.log('User deleted');
            res.status(204).send({});
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
   * Update details of a user
   * @param {object} req
   * @param {object} res
   */
  updateUser(req, res) {
    console.log('update user');
    if (_.has(req, 'body.new_user_name') && _.has(req, 'body.user_id')) {
      db.none(_qPatchUserFromUsers, [req.body.new_user_name, req.body.user_id,
        req.params.user])
          .then(() => {
            res.status(200).send('User updated');
          })
          .catch((error) => {
            res.status(400).send(JSON.stringify(error));
          });
    } else {
      console.log('Incomplete parameters');
      res.status(400).send('Error: Incomplete parameters');
    }
  }
}

module.exports = V1Controller;
