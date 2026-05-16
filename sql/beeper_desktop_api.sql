ALTER TYPE beeper_desktop_api.app_state_snapshot
  ADD ATTRIBUTE e2ee beeper_desktop_api.app_state_snapshot_e2ee,
  ADD ATTRIBUTE state TEXT,
  ADD ATTRIBUTE matrix beeper_desktop_api.app_state_snapshot_matrix,
  ADD ATTRIBUTE verification beeper_desktop_api.app_state_snapshot_verification;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_app_state_snapshot(
  e2ee beeper_desktop_api.app_state_snapshot_e2ee,
  state TEXT,
  matrix beeper_desktop_api.app_state_snapshot_matrix DEFAULT NULL,
  verification beeper_desktop_api.app_state_snapshot_verification DEFAULT NULL
)
RETURNS beeper_desktop_api.app_state_snapshot
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    e2ee, state, matrix, verification
  )::beeper_desktop_api.app_state_snapshot;
$$;

ALTER TYPE beeper_desktop_api.app_state_snapshot_e2ee
  ADD ATTRIBUTE crossSigning BOOLEAN,
  ADD ATTRIBUTE firstSyncDone BOOLEAN,
  ADD ATTRIBUTE hasBackedUpCode BOOLEAN,
  ADD ATTRIBUTE initialized BOOLEAN,
  ADD ATTRIBUTE keyBackup BOOLEAN,
  ADD ATTRIBUTE secrets beeper_desktop_api.app_state_snapshot_e2ee_secret,
  ADD ATTRIBUTE secretStorage BOOLEAN,
  ADD ATTRIBUTE verified BOOLEAN,
  ADD ATTRIBUTE recoveryCodeGeneratedAt DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_app_state_snapshot_e2ee(
  crossSigning BOOLEAN,
  firstSyncDone BOOLEAN,
  hasBackedUpCode BOOLEAN,
  initialized BOOLEAN,
  keyBackup BOOLEAN,
  secrets beeper_desktop_api.app_state_snapshot_e2ee_secret,
  secretStorage BOOLEAN,
  verified BOOLEAN,
  recoveryCodeGeneratedAt DOUBLE PRECISION DEFAULT NULL
)
RETURNS beeper_desktop_api.app_state_snapshot_e2ee
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    crossSigning,
    firstSyncDone,
    hasBackedUpCode,
    initialized,
    keyBackup,
    secrets,
    secretStorage,
    verified,
    recoveryCodeGeneratedAt
  )::beeper_desktop_api.app_state_snapshot_e2ee;
$$;

ALTER TYPE beeper_desktop_api.app_state_snapshot_e2ee_secret
  ADD ATTRIBUTE masterKey BOOLEAN,
  ADD ATTRIBUTE megolmBackupKey BOOLEAN,
  ADD ATTRIBUTE recoveryCode BOOLEAN,
  ADD ATTRIBUTE selfSigningKey BOOLEAN,
  ADD ATTRIBUTE userSigningKey BOOLEAN;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_app_state_snapshot_e2ee_secret(
  masterKey BOOLEAN,
  megolmBackupKey BOOLEAN,
  recoveryCode BOOLEAN,
  selfSigningKey BOOLEAN,
  userSigningKey BOOLEAN
)
RETURNS beeper_desktop_api.app_state_snapshot_e2ee_secret
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    masterKey, megolmBackupKey, recoveryCode, selfSigningKey, userSigningKey
  )::beeper_desktop_api.app_state_snapshot_e2ee_secret;
$$;

ALTER TYPE beeper_desktop_api.app_state_snapshot_matrix
  ADD ATTRIBUTE deviceID TEXT,
  ADD ATTRIBUTE homeserver TEXT,
  ADD ATTRIBUTE userID TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_app_state_snapshot_matrix(
  deviceID TEXT, homeserver TEXT, userID TEXT
)
RETURNS beeper_desktop_api.app_state_snapshot_matrix
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    deviceID, homeserver, userID
  )::beeper_desktop_api.app_state_snapshot_matrix;
$$;

ALTER TYPE beeper_desktop_api.app_state_snapshot_verification
  ADD ATTRIBUTE availableActions TEXT[],
  ADD ATTRIBUTE state TEXT,
  ADD ATTRIBUTE error beeper_desktop_api.app_state_snapshot_verification_error,
  ADD ATTRIBUTE "from" TEXT,
  ADD ATTRIBUTE fromDevice TEXT,
  ADD ATTRIBUTE otherDevice TEXT,
  ADD ATTRIBUTE qrData TEXT,
  ADD ATTRIBUTE sas beeper_desktop_api.app_state_snapshot_verification_sa,
  ADD ATTRIBUTE supportsSAS BOOLEAN,
  ADD ATTRIBUTE supportsScanQRCode BOOLEAN,
  ADD ATTRIBUTE verificationID TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_app_state_snapshot_verification(
  availableActions TEXT[],
  state TEXT,
  error beeper_desktop_api.app_state_snapshot_verification_error DEFAULT NULL,
  "from" TEXT DEFAULT NULL,
  fromDevice TEXT DEFAULT NULL,
  otherDevice TEXT DEFAULT NULL,
  qrData TEXT DEFAULT NULL,
  sas beeper_desktop_api.app_state_snapshot_verification_sa DEFAULT NULL,
  supportsSAS BOOLEAN DEFAULT NULL,
  supportsScanQRCode BOOLEAN DEFAULT NULL,
  verificationID TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api.app_state_snapshot_verification
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    availableActions,
    state,
    error,
    "from",
    fromDevice,
    otherDevice,
    qrData,
    sas,
    supportsSAS,
    supportsScanQRCode,
    verificationID
  )::beeper_desktop_api.app_state_snapshot_verification;
$$;

ALTER TYPE beeper_desktop_api.app_state_snapshot_verification_error
  ADD ATTRIBUTE code TEXT, ADD ATTRIBUTE reason TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_app_state_snapshot_verification_error(
  code TEXT, reason TEXT
)
RETURNS beeper_desktop_api.app_state_snapshot_verification_error
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    code, reason
  )::beeper_desktop_api.app_state_snapshot_verification_error;
$$;

ALTER TYPE beeper_desktop_api.app_state_snapshot_verification_sa
  ADD ATTRIBUTE decimals TEXT, ADD ATTRIBUTE emojis TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_app_state_snapshot_verification_sa(
  decimals TEXT, emojis TEXT
)
RETURNS beeper_desktop_api.app_state_snapshot_verification_sa
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    decimals, emojis
  )::beeper_desktop_api.app_state_snapshot_verification_sa;
$$;

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
  ADD ATTRIBUTE srcURL TEXT,
  ADD ATTRIBUTE transcription beeper_desktop_api.attachment_transcription;

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
  srcURL TEXT DEFAULT NULL,
  transcription beeper_desktop_api.attachment_transcription DEFAULT NULL
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
    srcURL,
    transcription
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

ALTER TYPE beeper_desktop_api.attachment_transcription
  ADD ATTRIBUTE engine TEXT,
  ADD ATTRIBUTE transcription TEXT,
  ADD ATTRIBUTE language TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_attachment_transcription(
  engine TEXT, transcription TEXT, language TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api.attachment_transcription
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    engine, transcription, language
  )::beeper_desktop_api.attachment_transcription;
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
  ADD ATTRIBUTE editedTimestamp TIMESTAMP,
  ADD ATTRIBUTE isDeleted BOOLEAN,
  ADD ATTRIBUTE isHidden BOOLEAN,
  ADD ATTRIBUTE isSender BOOLEAN,
  ADD ATTRIBUTE isUnread BOOLEAN,
  ADD ATTRIBUTE linkedMessageID TEXT,
  ADD ATTRIBUTE links beeper_desktop_api.message_link[],
  ADD ATTRIBUTE mentions TEXT[],
  ADD ATTRIBUTE reactions beeper_desktop_api.reaction[],
  ADD ATTRIBUTE seen JSONB,
  ADD ATTRIBUTE senderName TEXT,
  ADD ATTRIBUTE sendStatus beeper_desktop_api.message_send_status,
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
  editedTimestamp TIMESTAMP DEFAULT NULL,
  isDeleted BOOLEAN DEFAULT NULL,
  isHidden BOOLEAN DEFAULT NULL,
  isSender BOOLEAN DEFAULT NULL,
  isUnread BOOLEAN DEFAULT NULL,
  linkedMessageID TEXT DEFAULT NULL,
  links beeper_desktop_api.message_link[] DEFAULT NULL,
  mentions TEXT[] DEFAULT NULL,
  reactions beeper_desktop_api.reaction[] DEFAULT NULL,
  seen JSONB DEFAULT NULL,
  senderName TEXT DEFAULT NULL,
  sendStatus beeper_desktop_api.message_send_status DEFAULT NULL,
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
    editedTimestamp,
    isDeleted,
    isHidden,
    isSender,
    isUnread,
    linkedMessageID,
    links,
    mentions,
    reactions,
    seen,
    senderName,
    sendStatus,
    text,
    type
  )::beeper_desktop_api.message;
$$;

ALTER TYPE beeper_desktop_api.message_link
  ADD ATTRIBUTE title TEXT,
  ADD ATTRIBUTE url TEXT,
  ADD ATTRIBUTE favicon TEXT,
  ADD ATTRIBUTE img TEXT,
  ADD ATTRIBUTE imgSize beeper_desktop_api.message_link_img_size,
  ADD ATTRIBUTE originalURL TEXT,
  ADD ATTRIBUTE summary TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_message_link(
  title TEXT,
  url TEXT,
  favicon TEXT DEFAULT NULL,
  img TEXT DEFAULT NULL,
  imgSize beeper_desktop_api.message_link_img_size DEFAULT NULL,
  originalURL TEXT DEFAULT NULL,
  summary TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api.message_link
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    title, url, favicon, img, imgSize, originalURL, summary
  )::beeper_desktop_api.message_link;
$$;

ALTER TYPE beeper_desktop_api.message_link_img_size
  ADD ATTRIBUTE height DOUBLE PRECISION, ADD ATTRIBUTE width DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_message_link_img_size(
  height DOUBLE PRECISION DEFAULT NULL, width DOUBLE PRECISION DEFAULT NULL
)
RETURNS beeper_desktop_api.message_link_img_size
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(height, width)::beeper_desktop_api.message_link_img_size;
$$;

ALTER TYPE beeper_desktop_api.message_send_status
  ADD ATTRIBUTE status TEXT,
  ADD ATTRIBUTE "timestamp" TIMESTAMP,
  ADD ATTRIBUTE deliveredToUsers TEXT[],
  ADD ATTRIBUTE internalError TEXT,
  ADD ATTRIBUTE message TEXT,
  ADD ATTRIBUTE reason TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_message_send_status(
  status TEXT,
  "timestamp" TIMESTAMP,
  deliveredToUsers TEXT[] DEFAULT NULL,
  internalError TEXT DEFAULT NULL,
  message TEXT DEFAULT NULL,
  reason TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api.message_send_status
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    status, "timestamp", deliveredToUsers, internalError, message, reason
  )::beeper_desktop_api.message_send_status;
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