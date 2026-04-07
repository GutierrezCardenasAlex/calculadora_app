const { validationResult } = require('express-validator');
const { query } = require('../config/database');
const asyncHandler = require('../utils/asyncHandler');

const saveProgress = asyncHandler(async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ message: 'Datos invalidos', errors: errors.array() });
  }

  const { user_id: userId, topic_id: topicId, score } = req.body;

  const result = await query(
    `INSERT INTO progress (user_id, topic_id, score)
     VALUES ($1, $2, $3)
     ON CONFLICT (user_id, topic_id)
     DO UPDATE SET score = EXCLUDED.score, updated_at = NOW()
     RETURNING id, user_id, topic_id, score, updated_at`,
    [userId, topicId, score]
  );

  res.status(201).json(result.rows[0]);
});

const getProgressByUser = asyncHandler(async (req, res) => {
  const userId = Number(req.params.userId);
  const result = await query(
    `SELECT p.id, p.user_id, p.topic_id, p.score, p.updated_at, t.name AS topic_name
     FROM progress p
     INNER JOIN topics t ON t.id = p.topic_id
     WHERE p.user_id = $1
     ORDER BY p.updated_at DESC`,
    [userId]
  );
  res.json(result.rows);
});

module.exports = {
  saveProgress,
  getProgressByUser,
};
