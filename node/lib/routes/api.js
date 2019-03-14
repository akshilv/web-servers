'use strict';

const express = require('express');
const apiController = require('../controller').apiController;

const router = new express.Router();

router.use('/ping', apiController.ping);

module.exports = router;
