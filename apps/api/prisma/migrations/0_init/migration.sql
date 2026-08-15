-- CyberSafe Lebanon - PostgreSQL baseline schema
-- Reference only. Apply through migrations after privacy/security review.

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE users (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  status varchar(20) NOT NULL DEFAULT 'ACTIVE',
  display_name varchar(80),
  age_band varchar(20),
  preferred_locale varchar(10) NOT NULL DEFAULT 'en',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);

CREATE TABLE user_identities (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  provider varchar(40) NOT NULL,
  provider_subject varchar(255) NOT NULL,
  email varchar(320),
  email_verified boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE(provider, provider_subject)
);

CREATE TABLE anonymous_sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  public_id uuid NOT NULL DEFAULT gen_random_uuid() UNIQUE,
  locale varchar(10) NOT NULL DEFAULT 'en',
  age_band varchar(20),
  created_at timestamptz NOT NULL DEFAULT now(),
  last_seen_at timestamptz NOT NULL DEFAULT now(),
  expires_at timestamptz NOT NULL,
  converted_user_id uuid REFERENCES users(id)
);

CREATE TABLE devices (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE CASCADE,
  anonymous_session_id uuid REFERENCES anonymous_sessions(id) ON DELETE CASCADE,
  platform varchar(20) NOT NULL,
  push_provider varchar(20),
  push_token_ciphertext text,
  app_version varchar(40),
  last_seen_at timestamptz NOT NULL DEFAULT now(),
  revoked_at timestamptz,
  CHECK (user_id IS NOT NULL OR anonymous_session_id IS NOT NULL)
);

CREATE TYPE analysis_input_type AS ENUM ('TEXT','URL','IMAGE');
CREATE TYPE analysis_status AS ENUM ('RECEIVED','QUEUED','PROCESSING','COMPLETED','FAILED','REJECTED');
CREATE TYPE risk_level AS ENUM ('LOW_CONCERN','CAUTION','HIGH_RISK','INSUFFICIENT_INFORMATION');

CREATE TABLE analyses (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE SET NULL,
  anonymous_session_id uuid REFERENCES anonymous_sessions(id) ON DELETE SET NULL,
  input_type analysis_input_type NOT NULL,
  status analysis_status NOT NULL DEFAULT 'RECEIVED',
  risk_level risk_level,
  confidence_band varchar(20),
  summary text,
  language varchar(10),
  policy_version varchar(40) NOT NULL,
  ai_model_ref varchar(100),
  created_at timestamptz NOT NULL DEFAULT now(),
  completed_at timestamptz,
  raw_upload_deleted_at timestamptz
);

CREATE TABLE analysis_inputs (
  analysis_id uuid PRIMARY KEY REFERENCES analyses(id) ON DELETE CASCADE,
  normalized_text_redacted text,
  normalized_url text,
  object_key_quarantine text,
  mime_type varchar(100),
  byte_size bigint,
  sha256 char(64)
);

CREATE TABLE analysis_indicators (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  analysis_id uuid NOT NULL REFERENCES analyses(id) ON DELETE CASCADE,
  indicator_code varchar(80) NOT NULL,
  severity varchar(20) NOT NULL,
  value_redacted text,
  source varchar(30) NOT NULL,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE analysis_recommendations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  analysis_id uuid NOT NULL REFERENCES analyses(id) ON DELETE CASCADE,
  priority integer NOT NULL,
  action_code varchar(80) NOT NULL,
  title text NOT NULL,
  body text,
  playbook_id uuid
);

CREATE TABLE analysis_feedback (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  analysis_id uuid NOT NULL REFERENCES analyses(id) ON DELETE CASCADE,
  user_id uuid REFERENCES users(id) ON DELETE SET NULL,
  anonymous_session_id uuid REFERENCES anonymous_sessions(id) ON DELETE SET NULL,
  rating varchar(20) NOT NULL,
  comment text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE conversations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE SET NULL,
  anonymous_session_id uuid REFERENCES anonymous_sessions(id) ON DELETE SET NULL,
  locale varchar(10) NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);

CREATE TABLE chat_messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  conversation_id uuid NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
  role varchar(20) NOT NULL,
  content_redacted text NOT NULL,
  intent_code varchar(80),
  safety_route varchar(80),
  model_ref varchar(100),
  created_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);

CREATE TABLE knowledge_sources (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  title text NOT NULL,
  source_type varchar(40) NOT NULL,
  canonical_url text,
  owner text NOT NULL,
  publisher text,
  locale varchar(10) NOT NULL,
  status varchar(20) NOT NULL,
  effective_date date,
  review_due_at timestamptz,
  content_hash char(64),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

-- Adjust vector dimensions to the selected embedding model before production.
CREATE TABLE knowledge_chunks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source_id uuid NOT NULL REFERENCES knowledge_sources(id) ON DELETE CASCADE,
  chunk_index integer NOT NULL,
  text text NOT NULL,
  embedding vector(1536),
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  published boolean NOT NULL DEFAULT false,
  UNIQUE(source_id, chunk_index)
);

CREATE TABLE chat_message_sources (
  chat_message_id uuid NOT NULL REFERENCES chat_messages(id) ON DELETE CASCADE,
  knowledge_chunk_id uuid NOT NULL REFERENCES knowledge_chunks(id) ON DELETE CASCADE,
  rank integer NOT NULL,
  PRIMARY KEY(chat_message_id, knowledge_chunk_id)
);

CREATE TABLE content_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  type varchar(40) NOT NULL,
  slug varchar(160) NOT NULL UNIQUE,
  topic varchar(80),
  status varchar(20) NOT NULL DEFAULT 'DRAFT',
  audience varchar(80),
  age_band varchar(20),
  owner text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE content_versions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  content_item_id uuid NOT NULL REFERENCES content_items(id) ON DELETE CASCADE,
  version integer NOT NULL,
  content_json jsonb NOT NULL,
  created_by uuid,
  approved_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  published_at timestamptz,
  UNIQUE(content_item_id, version)
);

CREATE TABLE content_translations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  content_version_id uuid NOT NULL REFERENCES content_versions(id) ON DELETE CASCADE,
  locale varchar(10) NOT NULL,
  translated_content_json jsonb NOT NULL,
  translation_status varchar(20) NOT NULL,
  reviewed_by uuid,
  UNIQUE(content_version_id, locale)
);

CREATE TABLE incident_playbooks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code varchar(80) NOT NULL UNIQUE,
  category varchar(80) NOT NULL,
  status varchar(20) NOT NULL DEFAULT 'DRAFT',
  owner text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE analysis_recommendations
  ADD CONSTRAINT fk_analysis_recommendations_playbook
  FOREIGN KEY (playbook_id) REFERENCES incident_playbooks(id) ON DELETE SET NULL;

CREATE TABLE incident_playbook_versions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  playbook_id uuid NOT NULL REFERENCES incident_playbooks(id) ON DELETE CASCADE,
  version integer NOT NULL,
  logic_json jsonb NOT NULL,
  approved_by uuid,
  published_at timestamptz,
  UNIQUE(playbook_id, version)
);

CREATE TABLE reporting_routes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category varchar(80) NOT NULL,
  organization text NOT NULL,
  country_code char(2),
  channel_type varchar(30) NOT NULL,
  destination text NOT NULL,
  verified_at timestamptz NOT NULL,
  review_due_at timestamptz NOT NULL,
  status varchar(20) NOT NULL,
  owner text NOT NULL
);

CREATE TABLE incident_steps (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  playbook_version_id uuid NOT NULL REFERENCES incident_playbook_versions(id) ON DELETE CASCADE,
  step_code varchar(80) NOT NULL,
  step_type varchar(40) NOT NULL,
  priority integer NOT NULL,
  content_json jsonb NOT NULL,
  next_rule_json jsonb,
  reporting_route_id uuid REFERENCES reporting_routes(id) ON DELETE SET NULL
);

CREATE TABLE reporting_route_translations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  reporting_route_id uuid NOT NULL REFERENCES reporting_routes(id) ON DELETE CASCADE,
  locale varchar(10) NOT NULL,
  title text NOT NULL,
  description text,
  instructions text,
  UNIQUE(reporting_route_id, locale)
);

CREATE TABLE quizzes (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  content_item_id uuid REFERENCES content_items(id) ON DELETE CASCADE,
  version integer NOT NULL,
  passing_score numeric(5,2),
  status varchar(20) NOT NULL
);

CREATE TABLE quiz_questions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  quiz_id uuid NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
  question_version integer NOT NULL,
  type varchar(30) NOT NULL,
  prompt_json jsonb NOT NULL,
  answer_json jsonb NOT NULL,
  explanation_json jsonb
);

CREATE TABLE quiz_attempts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES users(id) ON DELETE SET NULL,
  anonymous_session_id uuid REFERENCES anonymous_sessions(id) ON DELETE SET NULL,
  quiz_id uuid NOT NULL REFERENCES quizzes(id) ON DELETE CASCADE,
  quiz_version integer NOT NULL,
  score numeric(5,2),
  started_at timestamptz NOT NULL DEFAULT now(),
  completed_at timestamptz
);

CREATE TABLE challenges (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code varchar(80) NOT NULL UNIQUE,
  start_at timestamptz,
  end_at timestamptz,
  visibility varchar(30) NOT NULL DEFAULT 'PUBLIC',
  institution_id uuid,
  status varchar(20) NOT NULL
);

CREATE TABLE challenge_tasks (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  challenge_id uuid NOT NULL REFERENCES challenges(id) ON DELETE CASCADE,
  task_type varchar(40) NOT NULL,
  target_id uuid,
  points integer NOT NULL DEFAULT 0
);

CREATE TABLE user_challenge_progress (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  challenge_id uuid NOT NULL REFERENCES challenges(id) ON DELETE CASCADE,
  points integer NOT NULL DEFAULT 0,
  completed_at timestamptz,
  UNIQUE(user_id, challenge_id)
);

CREATE TABLE user_lesson_progress (
  user_id uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  content_item_id uuid NOT NULL REFERENCES content_items(id) ON DELETE CASCADE,
  version integer NOT NULL,
  progress_percent integer NOT NULL DEFAULT 0 CHECK(progress_percent BETWEEN 0 AND 100),
  completed_at timestamptz,
  PRIMARY KEY(user_id, content_item_id)
);

CREATE TABLE alerts (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category varchar(80) NOT NULL,
  severity varchar(20) NOT NULL,
  status varchar(20) NOT NULL,
  starts_at timestamptz,
  ends_at timestamptz,
  audience_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_by uuid,
  approved_by uuid,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE alert_translations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  alert_id uuid NOT NULL REFERENCES alerts(id) ON DELETE CASCADE,
  locale varchar(10) NOT NULL,
  title text NOT NULL,
  summary text,
  body text NOT NULL,
  actions_json jsonb NOT NULL DEFAULT '[]'::jsonb,
  UNIQUE(alert_id, locale)
);

CREATE TABLE notification_preferences (
  user_id uuid PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
  cyber_alerts boolean NOT NULL DEFAULT false,
  learning_reminders boolean NOT NULL DEFAULT false,
  challenge_updates boolean NOT NULL DEFAULT false,
  frequency varchar(20) NOT NULL DEFAULT 'NORMAL',
  quiet_hours_json jsonb NOT NULL DEFAULT '{}'::jsonb,
  updated_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE notification_deliveries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id uuid NOT NULL REFERENCES devices(id) ON DELETE CASCADE,
  notification_type varchar(40) NOT NULL,
  reference_id uuid,
  status varchar(20) NOT NULL,
  provider_message_id text,
  created_at timestamptz NOT NULL DEFAULT now(),
  sent_at timestamptz
);

CREATE TABLE audit_logs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_admin_id uuid,
  action varchar(80) NOT NULL,
  entity_type varchar(80) NOT NULL,
  entity_id uuid,
  before_json jsonb,
  after_json jsonb,
  ip_hash text,
  user_agent_class varchar(80),
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX idx_analyses_user_created ON analyses(user_id, created_at DESC);
CREATE INDEX idx_analyses_guest_created ON analyses(anonymous_session_id, created_at DESC);
CREATE INDEX idx_analysis_indicators_analysis_severity ON analysis_indicators(analysis_id, severity);
CREATE INDEX idx_chat_messages_conversation_created ON chat_messages(conversation_id, created_at);
CREATE INDEX idx_knowledge_chunks_source ON knowledge_chunks(source_id);
CREATE INDEX idx_content_status_type_topic ON content_items(status, type, topic);
CREATE INDEX idx_reporting_routes_lookup ON reporting_routes(status, category, country_code);
CREATE INDEX idx_alerts_window ON alerts(status, starts_at, ends_at);
CREATE INDEX idx_audit_entity ON audit_logs(entity_type, entity_id, created_at DESC);

-- Create HNSW vector index after final embedding dimensions/operator class are selected.
-- Example:
-- CREATE INDEX idx_knowledge_embedding ON knowledge_chunks
-- USING hnsw (embedding vector_cosine_ops);
