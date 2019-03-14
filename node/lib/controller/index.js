'use strict';

const ApiController = require('./ApiController');
const V1Controller = require('./V1Controller');

exports.apiController = new ApiController();
exports.v1Controller = new V1Controller();
