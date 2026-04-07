const express = require('express');
const { body, param } = require('express-validator');
const { saveProgress, getProgressByUser } = require('../controllers/progressController');
const validateRequest = require('../middleware/validateRequest');

const router = express.Router();

router.post(
  '/',
  [
    body('user_id').isInt({ min: 1 }),
    body('topic_id').isInt({ min: 1 }),
    body('score').isInt({ min: 0, max: 100 }),
  ],
  validateRequest,
  saveProgress
);

router.get('/:userId', [param('userId').isInt({ min: 1 })], validateRequest, getProgressByUser);

module.exports = router;
