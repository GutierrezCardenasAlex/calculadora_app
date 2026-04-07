const { query } = require('../config/database');
const asyncHandler = require('../utils/asyncHandler');

const getConfig = asyncHandler(async (_req, res) => {
  const result = await query(
    `SELECT maintenance, force_update, app_message
     FROM config
     ORDER BY id ASC
     LIMIT 1`
  );

  const config = result.rows[0] || {
    maintenance: false,
    force_update: false,
    app_message: 'Bienvenido',
  };

  res.json(config);
});

module.exports = {
  getConfig,
};
