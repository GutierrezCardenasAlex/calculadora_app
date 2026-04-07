require('dotenv').config();

const app = require('./app');
const { testConnection } = require('./config/database');

const port = Number(process.env.BACKEND_PORT || 3000);

async function bootstrap() {
  await testConnection();
  app.listen(port, () => {
    console.log(`Backend listening on port ${port}`);
  });
}

bootstrap().catch((error) => {
  console.error('Failed to start backend', error);
  process.exit(1);
});
