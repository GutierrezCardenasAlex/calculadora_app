const express = require('express');
const cors = require('cors');

const configRoutes = require('./routes/configRoutes');
const authRoutes = require('./routes/authRoutes');
const catalogRoutes = require('./routes/catalogRoutes');
const progressRoutes = require('./routes/progressRoutes');
const { notFoundHandler, errorHandler } = require('./middleware/errorMiddleware');

const app = express();

app.use(cors({ origin: process.env.CORS_ORIGIN || '*' }));
app.use(express.json());

app.get('/health', (_req, res) => {
  res.json({ status: 'ok' });
});

app.use('/config', configRoutes);
app.use('/auth', authRoutes);
app.use('/', catalogRoutes);
app.use('/progress', progressRoutes);

app.use(notFoundHandler);
app.use(errorHandler);

module.exports = app;
