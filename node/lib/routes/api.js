'use strict';

const express = require('express');
const apiController = require('../controller').apiController;

const router = new express.Router();

router.route('/ping')
    .get(apiController.ping);

module.exports = router;
