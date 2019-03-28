'use strict';

const express = require('express');
const v1Controller = require('../controller').v1Controller;

const router = new express.Router();

router.route('/user')
    .post(v1Controller.createUser);
router.route('/user/:user')
    .get(v1Controller.getUser)
    .patch(v1Controller.updateUser)
    .delete(v1Controller.deleteUser);

module.exports = router;
