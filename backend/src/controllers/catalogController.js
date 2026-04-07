const { query } = require('../config/database');
const asyncHandler = require('../utils/asyncHandler');

const getLevels = asyncHandler(async (_req, res) => {
  const result = await query(
    'SELECT id, name, grade FROM levels ORDER BY grade ASC, id ASC'
  );
  res.json(result.rows);
});

const getTopicsByLevel = asyncHandler(async (req, res) => {
  const levelId = Number(req.params.levelId);
  const result = await query(
    'SELECT id, name, level_id FROM topics WHERE level_id = $1 ORDER BY id ASC',
    [levelId]
  );
  res.json(result.rows);
});

const getQuestionsByTopic = asyncHandler(async (req, res) => {
  const topicId = Number(req.params.topicId);
  const result = await query(
    `SELECT id, topic_id, type, question, options, correct_answer
     FROM questions
     WHERE topic_id = $1
     ORDER BY id ASC`,
    [topicId]
  );

  const questions = result.rows.map((row) => ({
    id: row.id,
    topic_id: row.topic_id,
    type: row.type,
    question: row.question,
    options: row.options,
    correct: row.correct_answer,
  }));

  res.json(questions);
});

module.exports = {
  getLevels,
  getTopicsByLevel,
  getQuestionsByTopic,
};
