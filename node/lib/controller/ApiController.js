'use strict';

const BaseController = require('./BaseController');

/**
 * Controller for /api routes
 * @class
 */
class ApiController extends BaseController {
  /**
   * Constructor for ApiController
   * @constructor
   */
  constructor() {
    super();
  }

  /**
   * Function ping to check if server is running or not
   * @param {object} req - The request object received
   * @param {object} res - The response object to be sent
   */
  ping(req, res) {
    res.status(200).send('Server is alive!');
  }
}

module.exports = ApiController;
