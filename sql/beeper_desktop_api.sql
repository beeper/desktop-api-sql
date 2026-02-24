ALTER TYPE beeper_desktop_api.attachment
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE duration DOUBLE PRECISION,
  ADD ATTRIBUTE file_name TEXT,
  ADD ATTRIBUTE file_size DOUBLE PRECISION,
  ADD ATTRIBUTE is_gif BOOLEAN,
  ADD ATTRIBUTE is_sticker BOOLEAN,
  ADD ATTRIBUTE is_voice_note BOOLEAN,
  ADD ATTRIBUTE mime_type TEXT,
  ADD ATTRIBUTE poster_img TEXT,
  ADD ATTRIBUTE size beeper_desktop_api.attachment_size,
  ADD ATTRIBUTE src_url TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_attachment(
  type TEXT,
  id TEXT DEFAULT NULL,
  duration DOUBLE PRECISION DEFAULT NULL,
  file_name TEXT DEFAULT NULL,
  file_size DOUBLE PRECISION DEFAULT NULL,
  is_gif BOOLEAN DEFAULT NULL,
  is_sticker BOOLEAN DEFAULT NULL,
  is_voice_note BOOLEAN DEFAULT NULL,
  mime_type TEXT DEFAULT NULL,
  poster_img TEXT DEFAULT NULL,
  size beeper_desktop_api.attachment_size DEFAULT NULL,
  src_url TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api.attachment
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    type,
    id,
    duration,
    file_name,
    file_size,
    is_gif,
    is_sticker,
    is_voice_note,
    mime_type,
    poster_img,
    size,
    src_url
  )::beeper_desktop_api.attachment;
$$;

ALTER TYPE beeper_desktop_api.attachment_size
  ADD ATTRIBUTE height DOUBLE PRECISION, ADD ATTRIBUTE width DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_attachment_size(
  height DOUBLE PRECISION DEFAULT NULL, width DOUBLE PRECISION DEFAULT NULL
)
RETURNS beeper_desktop_api.attachment_size
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(height, width)::beeper_desktop_api.attachment_size;
$$;

ALTER TYPE beeper_desktop_api.error
  ADD ATTRIBUTE code TEXT,
  ADD ATTRIBUTE message TEXT,
  ADD ATTRIBUTE details JSONB;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_error(
  code TEXT, message TEXT, details JSONB DEFAULT NULL
)
RETURNS beeper_desktop_api.error
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(code, message, details)::beeper_desktop_api.error;
$$;

ALTER TYPE beeper_desktop_api.message
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE account_id TEXT,
  ADD ATTRIBUTE chat_id TEXT,
  ADD ATTRIBUTE sender_id TEXT,
  ADD ATTRIBUTE sort_key TEXT,
  ADD ATTRIBUTE "timestamp" TIMESTAMP,
  ADD ATTRIBUTE attachments beeper_desktop_api.attachment[],
  ADD ATTRIBUTE is_sender BOOLEAN,
  ADD ATTRIBUTE is_unread BOOLEAN,
  ADD ATTRIBUTE linked_message_id TEXT,
  ADD ATTRIBUTE reactions beeper_desktop_api.reaction[],
  ADD ATTRIBUTE sender_name TEXT,
  ADD ATTRIBUTE text TEXT,
  ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_message(
  id TEXT,
  account_id TEXT,
  chat_id TEXT,
  sender_id TEXT,
  sort_key TEXT,
  "timestamp" TIMESTAMP,
  attachments beeper_desktop_api.attachment[] DEFAULT NULL,
  is_sender BOOLEAN DEFAULT NULL,
  is_unread BOOLEAN DEFAULT NULL,
  linked_message_id TEXT DEFAULT NULL,
  reactions beeper_desktop_api.reaction[] DEFAULT NULL,
  sender_name TEXT DEFAULT NULL,
  text TEXT DEFAULT NULL,
  type TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api.message
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    account_id,
    chat_id,
    sender_id,
    sort_key,
    "timestamp",
    attachments,
    is_sender,
    is_unread,
    linked_message_id,
    reactions,
    sender_name,
    text,
    type
  )::beeper_desktop_api.message;
$$;

ALTER TYPE beeper_desktop_api.reaction
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE participant_id TEXT,
  ADD ATTRIBUTE reaction_key TEXT,
  ADD ATTRIBUTE emoji BOOLEAN,
  ADD ATTRIBUTE img_url TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_reaction(
  id TEXT,
  participant_id TEXT,
  reaction_key TEXT,
  emoji BOOLEAN DEFAULT NULL,
  img_url TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api.reaction
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, participant_id, reaction_key, emoji, img_url
  )::beeper_desktop_api.reaction;
$$;

ALTER TYPE beeper_desktop_api.user
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE cannot_message BOOLEAN,
  ADD ATTRIBUTE email TEXT,
  ADD ATTRIBUTE full_name TEXT,
  ADD ATTRIBUTE img_url TEXT,
  ADD ATTRIBUTE is_self BOOLEAN,
  ADD ATTRIBUTE phone_number TEXT,
  ADD ATTRIBUTE username TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_user(
  id TEXT,
  cannot_message BOOLEAN DEFAULT NULL,
  email TEXT DEFAULT NULL,
  full_name TEXT DEFAULT NULL,
  img_url TEXT DEFAULT NULL,
  is_self BOOLEAN DEFAULT NULL,
  phone_number TEXT DEFAULT NULL,
  username TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api.user
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    cannot_message,
    email,
    full_name,
    img_url,
    is_self,
    phone_number,
    username
  )::beeper_desktop_api.user;
$$;