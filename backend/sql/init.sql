CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS levels (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  grade INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS topics (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  level_id INTEGER NOT NULL REFERENCES levels(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS questions (
  id SERIAL PRIMARY KEY,
  topic_id INTEGER NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  type TEXT NOT NULL DEFAULT 'multiple_choice',
  question TEXT NOT NULL,
  options JSONB NOT NULL,
  correct_answer JSONB NOT NULL
);

CREATE TABLE IF NOT EXISTS progress (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  topic_id INTEGER NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
  score INTEGER NOT NULL CHECK (score >= 0 AND score <= 100),
  updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, topic_id)
);

CREATE TABLE IF NOT EXISTS config (
  id SERIAL PRIMARY KEY,
  maintenance BOOLEAN NOT NULL DEFAULT FALSE,
  force_update BOOLEAN NOT NULL DEFAULT FALSE,
  app_message TEXT NOT NULL DEFAULT 'Bienvenido'
);

INSERT INTO config (maintenance, force_update, app_message)
SELECT FALSE, FALSE, 'Bienvenido a Matemagica'
WHERE NOT EXISTS (SELECT 1 FROM config);

INSERT INTO levels (name, grade)
SELECT * FROM (VALUES
  ('Nivel 1', 1),
  ('Nivel 2', 2),
  ('Nivel 3', 3)
) AS seed(name, grade)
WHERE NOT EXISTS (SELECT 1 FROM levels);

INSERT INTO topics (name, level_id)
SELECT * FROM (VALUES
  ('Sumas basicas', 1),
  ('Restas basicas', 1),
  ('Multiplicacion', 2),
  ('Division', 3)
) AS seed(name, level_id)
WHERE NOT EXISTS (SELECT 1 FROM topics);

INSERT INTO questions (topic_id, type, question, options, correct_answer)
SELECT * FROM (VALUES
  (1, 'multiple_choice', '5 + 3', '[6,7,8,9]'::jsonb, '8'::jsonb),
  (1, 'multiple_choice', '2 + 4', '[5,6,7,8]'::jsonb, '6'::jsonb),
  (2, 'multiple_choice', '9 - 4', '[3,4,5,6]'::jsonb, '5'::jsonb),
  (3, 'multiple_choice', '3 x 4', '[7,10,12,14]'::jsonb, '12'::jsonb),
  (4, 'multiple_choice', '12 / 3', '[2,3,4,5]'::jsonb, '4'::jsonb)
) AS seed(topic_id, type, question, options, correct_answer)
WHERE NOT EXISTS (SELECT 1 FROM questions);
