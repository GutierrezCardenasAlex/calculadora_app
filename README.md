# App Calculadora

Proyecto educativo para primaria con:

- `frontend/`: app Flutter con splash, login simple, consumo dinámico y cache local con Hive.
- `backend/`: API Node.js + Express + PostgreSQL.
- `docker-compose.yml`: backend y PostgreSQL para despliegue en VPS.

## Inicio rápido

1. Copia `.env.example` a `.env`.
2. En `backend/`, instala dependencias con `npm install`.
3. Levanta servicios con `docker compose up --build`.
4. En `frontend/`, ejecuta `flutter pub get` y luego `flutter run`.

## Endpoints

- `GET /config`
- `POST /auth/login`
- `GET /levels`
- `GET /topics/:levelId`
- `GET /questions/:topicId`
- `POST /progress`
- `GET /progress/:userId`
