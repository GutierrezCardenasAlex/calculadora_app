const express = require('express');
const { param } = require('express-validator');
const {
  getLevels,
  getTopicsByLevel,
  getQuestionsByTopic,
} = require('../controllers/catalogController');
const validateRequest = require('../middleware/validateRequest');

const router = express.Router();

router.get('/levels', getLevels);
router.get('/topics/:levelId', [param('levelId').isInt({ min: 1 })], validateRequest, getTopicsByLevel);
router.get(
  '/questions/:topicId',
  [param('topicId').isInt({ min: 1 })],
  validateRequest,
  getQuestionsByTopic
);

module.exports = router;
