ALTER TYPE beeper_desktop_api.attachment
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE duration DOUBLE PRECISION,
  ADD ATTRIBUTE fileName TEXT,
  ADD ATTRIBUTE fileSize DOUBLE PRECISION,
  ADD ATTRIBUTE isGif BOOLEAN,
  ADD ATTRIBUTE isSticker BOOLEAN,
  ADD ATTRIBUTE isVoiceNote BOOLEAN,
  ADD ATTRIBUTE mimeType TEXT,
  ADD ATTRIBUTE posterImg TEXT,
  ADD ATTRIBUTE size beeper_desktop_api.attachment_size,
  ADD ATTRIBUTE srcURL TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_attachment(
  type TEXT,
  id TEXT DEFAULT NULL,
  duration DOUBLE PRECISION DEFAULT NULL,
  fileName TEXT DEFAULT NULL,
  fileSize DOUBLE PRECISION DEFAULT NULL,
  isGif BOOLEAN DEFAULT NULL,
  isSticker BOOLEAN DEFAULT NULL,
  isVoiceNote BOOLEAN DEFAULT NULL,
  mimeType TEXT DEFAULT NULL,
  posterImg TEXT DEFAULT NULL,
  size beeper_desktop_api.attachment_size DEFAULT NULL,
  srcURL TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api.attachment
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    type,
    id,
    duration,
    fileName,
    fileSize,
    isGif,
    isSticker,
    isVoiceNote,
    mimeType,
    posterImg,
    size,
    srcURL
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
  ADD ATTRIBUTE accountID TEXT,
  ADD ATTRIBUTE chatID TEXT,
  ADD ATTRIBUTE senderID TEXT,
  ADD ATTRIBUTE sortKey TEXT,
  ADD ATTRIBUTE "timestamp" TIMESTAMP,
  ADD ATTRIBUTE attachments beeper_desktop_api.attachment[],
  ADD ATTRIBUTE isSender BOOLEAN,
  ADD ATTRIBUTE isUnread BOOLEAN,
  ADD ATTRIBUTE linkedMessageID TEXT,
  ADD ATTRIBUTE reactions beeper_desktop_api.reaction[],
  ADD ATTRIBUTE senderName TEXT,
  ADD ATTRIBUTE text TEXT,
  ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_message(
  id TEXT,
  accountID TEXT,
  chatID TEXT,
  senderID TEXT,
  sortKey TEXT,
  "timestamp" TIMESTAMP,
  attachments beeper_desktop_api.attachment[] DEFAULT NULL,
  isSender BOOLEAN DEFAULT NULL,
  isUnread BOOLEAN DEFAULT NULL,
  linkedMessageID TEXT DEFAULT NULL,
  reactions beeper_desktop_api.reaction[] DEFAULT NULL,
  senderName TEXT DEFAULT NULL,
  text TEXT DEFAULT NULL,
  type TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api.message
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    accountID,
    chatID,
    senderID,
    sortKey,
    "timestamp",
    attachments,
    isSender,
    isUnread,
    linkedMessageID,
    reactions,
    senderName,
    text,
    type
  )::beeper_desktop_api.message;
$$;

ALTER TYPE beeper_desktop_api.reaction
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE participantID TEXT,
  ADD ATTRIBUTE reactionKey TEXT,
  ADD ATTRIBUTE emoji BOOLEAN,
  ADD ATTRIBUTE imgURL TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_reaction(
  id TEXT,
  participantID TEXT,
  reactionKey TEXT,
  emoji BOOLEAN DEFAULT NULL,
  imgURL TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api.reaction
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, participantID, reactionKey, emoji, imgURL
  )::beeper_desktop_api.reaction;
$$;

ALTER TYPE beeper_desktop_api.user
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE cannotMessage BOOLEAN,
  ADD ATTRIBUTE email TEXT,
  ADD ATTRIBUTE fullName TEXT,
  ADD ATTRIBUTE imgURL TEXT,
  ADD ATTRIBUTE isSelf BOOLEAN,
  ADD ATTRIBUTE phoneNumber TEXT,
  ADD ATTRIBUTE username TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_user(
  id TEXT,
  cannotMessage BOOLEAN DEFAULT NULL,
  email TEXT DEFAULT NULL,
  fullName TEXT DEFAULT NULL,
  imgURL TEXT DEFAULT NULL,
  isSelf BOOLEAN DEFAULT NULL,
  phoneNumber TEXT DEFAULT NULL,
  username TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api.user
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, cannotMessage, email, fullName, imgURL, isSelf, phoneNumber, username
  )::beeper_desktop_api.user;
$$;