const { validationResult } = require('express-validator');
const { query } = require('../config/database');
const asyncHandler = require('../utils/asyncHandler');

const login = asyncHandler(async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ message: 'Datos invalidos', errors: errors.array() });
  }

  const normalizedName = req.body.name.trim();

  const existingUser = await query(
    'SELECT id, name FROM users WHERE LOWER(name) = LOWER($1) LIMIT 1',
    [normalizedName]
  );

  if (existingUser.rows[0]) {
    return res.json(existingUser.rows[0]);
  }

  const createdUser = await query(
    'INSERT INTO users (name) VALUES ($1) RETURNING id, name',
    [normalizedName]
  );

  return res.status(201).json(createdUser.rows[0]);
});

module.exports = {
  login,
};
