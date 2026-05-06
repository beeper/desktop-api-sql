ALTER TYPE beeper_desktop_api_chats.chat
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE accountID TEXT,
  ADD ATTRIBUTE network TEXT,
  ADD ATTRIBUTE participants beeper_desktop_api_chats.chat_participant,
  ADD ATTRIBUTE title TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE unreadCount BIGINT,
  ADD ATTRIBUTE capabilities beeper_desktop_api_chats.chat_capability,
  ADD ATTRIBUTE description TEXT,
  ADD ATTRIBUTE draft beeper_desktop_api_chats.chat_draft,
  ADD ATTRIBUTE imgURL TEXT,
  ADD ATTRIBUTE isArchived BOOLEAN,
  ADD ATTRIBUTE isLowPriority BOOLEAN,
  ADD ATTRIBUTE isMarkedUnread BOOLEAN,
  ADD ATTRIBUTE isMuted BOOLEAN,
  ADD ATTRIBUTE isPinned BOOLEAN,
  ADD ATTRIBUTE isReadOnly BOOLEAN,
  ADD ATTRIBUTE lastActivity TIMESTAMP,
  ADD ATTRIBUTE lastReadMessageSortKey TEXT,
  ADD ATTRIBUTE localChatID TEXT,
  ADD ATTRIBUTE messageExpirySeconds BIGINT,
  ADD ATTRIBUTE reminder beeper_desktop_api_chats.chat_reminder,
  ADD ATTRIBUTE snooze beeper_desktop_api_chats.chat_snooze,
  ADD ATTRIBUTE unreadMentionsCount BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat(
  id TEXT,
  accountID TEXT,
  network TEXT,
  participants beeper_desktop_api_chats.chat_participant,
  title TEXT,
  type TEXT,
  unreadCount BIGINT,
  capabilities beeper_desktop_api_chats.chat_capability DEFAULT NULL,
  description TEXT DEFAULT NULL,
  draft beeper_desktop_api_chats.chat_draft DEFAULT NULL,
  imgURL TEXT DEFAULT NULL,
  isArchived BOOLEAN DEFAULT NULL,
  isLowPriority BOOLEAN DEFAULT NULL,
  isMarkedUnread BOOLEAN DEFAULT NULL,
  isMuted BOOLEAN DEFAULT NULL,
  isPinned BOOLEAN DEFAULT NULL,
  isReadOnly BOOLEAN DEFAULT NULL,
  lastActivity TIMESTAMP DEFAULT NULL,
  lastReadMessageSortKey TEXT DEFAULT NULL,
  localChatID TEXT DEFAULT NULL,
  messageExpirySeconds BIGINT DEFAULT NULL,
  reminder beeper_desktop_api_chats.chat_reminder DEFAULT NULL,
  snooze beeper_desktop_api_chats.chat_snooze DEFAULT NULL,
  unreadMentionsCount BIGINT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    accountID,
    network,
    participants,
    title,
    type,
    unreadCount,
    capabilities,
    description,
    draft,
    imgURL,
    isArchived,
    isLowPriority,
    isMarkedUnread,
    isMuted,
    isPinned,
    isReadOnly,
    lastActivity,
    lastReadMessageSortKey,
    localChatID,
    messageExpirySeconds,
    reminder,
    snooze,
    unreadMentionsCount
  )::beeper_desktop_api_chats.chat;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_participant
  ADD ATTRIBUTE hasMore BOOLEAN,
  ADD ATTRIBUTE items beeper_desktop_api_chats.chat_participant_item[],
  ADD ATTRIBUTE total BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_participant(
  hasMore BOOLEAN,
  items beeper_desktop_api_chats.chat_participant_item[],
  total BIGINT
)
RETURNS beeper_desktop_api_chats.chat_participant
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(hasMore, items, total)::beeper_desktop_api_chats.chat_participant;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_participant_item
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE cannotMessage BOOLEAN,
  ADD ATTRIBUTE email TEXT,
  ADD ATTRIBUTE fullName TEXT,
  ADD ATTRIBUTE imgURL TEXT,
  ADD ATTRIBUTE isSelf BOOLEAN,
  ADD ATTRIBUTE phoneNumber TEXT,
  ADD ATTRIBUTE username TEXT,
  ADD ATTRIBUTE isAdmin BOOLEAN,
  ADD ATTRIBUTE isNetworkBot BOOLEAN,
  ADD ATTRIBUTE isPending BOOLEAN;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_participant_item(
  id TEXT,
  cannotMessage BOOLEAN DEFAULT NULL,
  email TEXT DEFAULT NULL,
  fullName TEXT DEFAULT NULL,
  imgURL TEXT DEFAULT NULL,
  isSelf BOOLEAN DEFAULT NULL,
  phoneNumber TEXT DEFAULT NULL,
  username TEXT DEFAULT NULL,
  isAdmin BOOLEAN DEFAULT NULL,
  isNetworkBot BOOLEAN DEFAULT NULL,
  isPending BOOLEAN DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_participant_item
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    cannotMessage,
    email,
    fullName,
    imgURL,
    isSelf,
    phoneNumber,
    username,
    isAdmin,
    isNetworkBot,
    isPending
  )::beeper_desktop_api_chats.chat_participant_item;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_capability
  ADD ATTRIBUTE allowedReactions TEXT[],
  ADD ATTRIBUTE archive BOOLEAN,
  ADD ATTRIBUTE attachments JSONB,
  ADD ATTRIBUTE customEmojiReactions BOOLEAN,
  ADD ATTRIBUTE delete BIGINT,
  ADD ATTRIBUTE deleteChat BOOLEAN,
  ADD ATTRIBUTE deleteChatForEveryone BOOLEAN,
  ADD ATTRIBUTE deleteForMe BOOLEAN,
  ADD ATTRIBUTE deleteMaxAge BIGINT,
  ADD ATTRIBUTE disappearingTimer beeper_desktop_api_chats.chat_capability_disappearing_timer,
  ADD ATTRIBUTE edit BIGINT,
  ADD ATTRIBUTE editMaxAge BIGINT,
  ADD ATTRIBUTE editMaxCount BIGINT,
  ADD ATTRIBUTE formatting JSONB,
  ADD ATTRIBUTE locationMessage BIGINT,
  ADD ATTRIBUTE markAsUnread BOOLEAN,
  ADD ATTRIBUTE maxTextLength BIGINT,
  ADD ATTRIBUTE messageRequest beeper_desktop_api_chats.chat_capability_message_request,
  ADD ATTRIBUTE participantActions beeper_desktop_api_chats.chat_capability_participant_action,
  ADD ATTRIBUTE poll BIGINT,
  ADD ATTRIBUTE reaction BIGINT,
  ADD ATTRIBUTE reactionCount BIGINT,
  ADD ATTRIBUTE readReceipts BOOLEAN,
  ADD ATTRIBUTE reply BIGINT,
  ADD ATTRIBUTE state beeper_desktop_api_chats.chat_capability_state,
  ADD ATTRIBUTE thread BIGINT,
  ADD ATTRIBUTE typingNotifications BOOLEAN;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_capability(
  allowedReactions TEXT[] DEFAULT NULL,
  archive BOOLEAN DEFAULT NULL,
  attachments JSONB DEFAULT NULL,
  customEmojiReactions BOOLEAN DEFAULT NULL,
  delete BIGINT DEFAULT NULL,
  deleteChat BOOLEAN DEFAULT NULL,
  deleteChatForEveryone BOOLEAN DEFAULT NULL,
  deleteForMe BOOLEAN DEFAULT NULL,
  deleteMaxAge BIGINT DEFAULT NULL,
  disappearingTimer beeper_desktop_api_chats.chat_capability_disappearing_timer DEFAULT NULL,
  edit BIGINT DEFAULT NULL,
  editMaxAge BIGINT DEFAULT NULL,
  editMaxCount BIGINT DEFAULT NULL,
  formatting JSONB DEFAULT NULL,
  locationMessage BIGINT DEFAULT NULL,
  markAsUnread BOOLEAN DEFAULT NULL,
  maxTextLength BIGINT DEFAULT NULL,
  messageRequest beeper_desktop_api_chats.chat_capability_message_request DEFAULT NULL,
  participantActions beeper_desktop_api_chats.chat_capability_participant_action DEFAULT NULL,
  poll BIGINT DEFAULT NULL,
  reaction BIGINT DEFAULT NULL,
  reactionCount BIGINT DEFAULT NULL,
  readReceipts BOOLEAN DEFAULT NULL,
  reply BIGINT DEFAULT NULL,
  state beeper_desktop_api_chats.chat_capability_state DEFAULT NULL,
  thread BIGINT DEFAULT NULL,
  typingNotifications BOOLEAN DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_capability
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    allowedReactions,
    archive,
    attachments,
    customEmojiReactions,
    delete,
    deleteChat,
    deleteChatForEveryone,
    deleteForMe,
    deleteMaxAge,
    disappearingTimer,
    edit,
    editMaxAge,
    editMaxCount,
    formatting,
    locationMessage,
    markAsUnread,
    maxTextLength,
    messageRequest,
    participantActions,
    poll,
    reaction,
    reactionCount,
    readReceipts,
    reply,
    state,
    thread,
    typingNotifications
  )::beeper_desktop_api_chats.chat_capability;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_capability_disappearing_timer
  ADD ATTRIBUTE omitEmptyTimer BOOLEAN,
  ADD ATTRIBUTE timers BIGINT[],
  ADD ATTRIBUTE types TEXT[];

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_capability_disappearing_timer(
  omitEmptyTimer BOOLEAN DEFAULT NULL,
  timers BIGINT[] DEFAULT NULL,
  types TEXT[] DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_capability_disappearing_timer
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    omitEmptyTimer, timers, types
  )::beeper_desktop_api_chats.chat_capability_disappearing_timer;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_capability_message_request
  ADD ATTRIBUTE acceptWithButton BIGINT, ADD ATTRIBUTE acceptWithMessage BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_capability_message_request(
  acceptWithButton BIGINT DEFAULT NULL, acceptWithMessage BIGINT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_capability_message_request
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    acceptWithButton, acceptWithMessage
  )::beeper_desktop_api_chats.chat_capability_message_request;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_capability_participant_action
  ADD ATTRIBUTE ban BIGINT,
  ADD ATTRIBUTE invite BIGINT,
  ADD ATTRIBUTE kick BIGINT,
  ADD ATTRIBUTE leave BIGINT,
  ADD ATTRIBUTE revokeInvite BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_capability_participant_action(
  ban BIGINT DEFAULT NULL,
  invite BIGINT DEFAULT NULL,
  kick BIGINT DEFAULT NULL,
  leave BIGINT DEFAULT NULL,
  revokeInvite BIGINT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_capability_participant_action
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    ban, invite, kick, leave, revokeInvite
  )::beeper_desktop_api_chats.chat_capability_participant_action;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_capability_state
  ADD ATTRIBUTE avatar beeper_desktop_api_chats.chat_capability_state_avatar,
  ADD ATTRIBUTE description beeper_desktop_api_chats.chat_capability_state_description,
  ADD ATTRIBUTE disappearingTimer beeper_desktop_api_chats.chat_capability_state_disappearing_timer,
  ADD ATTRIBUTE title beeper_desktop_api_chats.chat_capability_state_title;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_capability_state(
  avatar beeper_desktop_api_chats.chat_capability_state_avatar DEFAULT NULL,
  description beeper_desktop_api_chats.chat_capability_state_description DEFAULT NULL,
  disappearingTimer beeper_desktop_api_chats.chat_capability_state_disappearing_timer DEFAULT NULL,
  title beeper_desktop_api_chats.chat_capability_state_title DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_capability_state
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    avatar, description, disappearingTimer, title
  )::beeper_desktop_api_chats.chat_capability_state;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_capability_state_avatar
  ADD ATTRIBUTE level BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_capability_state_avatar(
  level BIGINT
)
RETURNS beeper_desktop_api_chats.chat_capability_state_avatar
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(level)::beeper_desktop_api_chats.chat_capability_state_avatar;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_capability_state_description
  ADD ATTRIBUTE level BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_capability_state_description(
  level BIGINT
)
RETURNS beeper_desktop_api_chats.chat_capability_state_description
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(level)::beeper_desktop_api_chats.chat_capability_state_description;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_capability_state_disappearing_timer
  ADD ATTRIBUTE level BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_capability_state_disappearing_timer(
  level BIGINT
)
RETURNS beeper_desktop_api_chats.chat_capability_state_disappearing_timer
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    level
  )::beeper_desktop_api_chats.chat_capability_state_disappearing_timer;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_capability_state_title
  ADD ATTRIBUTE level BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_capability_state_title(
  level BIGINT
)
RETURNS beeper_desktop_api_chats.chat_capability_state_title
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(level)::beeper_desktop_api_chats.chat_capability_state_title;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_draft
  ADD ATTRIBUTE text TEXT, ADD ATTRIBUTE attachments JSONB;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_draft(
  text TEXT, attachments JSONB DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_draft
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(text, attachments)::beeper_desktop_api_chats.chat_draft;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_reminder
  ADD ATTRIBUTE dismissOnIncomingMessage BOOLEAN,
  ADD ATTRIBUTE remindAt TIMESTAMP;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_reminder(
  dismissOnIncomingMessage BOOLEAN DEFAULT NULL, remindAt TIMESTAMP DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_reminder
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    dismissOnIncomingMessage, remindAt
  )::beeper_desktop_api_chats.chat_reminder;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_snooze
  ADD ATTRIBUTE snoozeUntil TIMESTAMP, ADD ATTRIBUTE userSnoozedAt TIMESTAMP;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_snooze(
  snoozeUntil TIMESTAMP DEFAULT NULL, userSnoozedAt TIMESTAMP DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_snooze
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(snoozeUntil, userSnoozedAt)::beeper_desktop_api_chats.chat_snooze;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_create_response
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE accountID TEXT,
  ADD ATTRIBUTE network TEXT,
  ADD ATTRIBUTE participants beeper_desktop_api_chats.chat_create_response_participant,
  ADD ATTRIBUTE title TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE unreadCount BIGINT,
  ADD ATTRIBUTE chatID TEXT,
  ADD ATTRIBUTE capabilities beeper_desktop_api_chats.chat_create_response_capability,
  ADD ATTRIBUTE description TEXT,
  ADD ATTRIBUTE draft beeper_desktop_api_chats.chat_create_response_draft,
  ADD ATTRIBUTE imgURL TEXT,
  ADD ATTRIBUTE isArchived BOOLEAN,
  ADD ATTRIBUTE isLowPriority BOOLEAN,
  ADD ATTRIBUTE isMarkedUnread BOOLEAN,
  ADD ATTRIBUTE isMuted BOOLEAN,
  ADD ATTRIBUTE isPinned BOOLEAN,
  ADD ATTRIBUTE isReadOnly BOOLEAN,
  ADD ATTRIBUTE lastActivity TIMESTAMP,
  ADD ATTRIBUTE lastReadMessageSortKey TEXT,
  ADD ATTRIBUTE localChatID TEXT,
  ADD ATTRIBUTE messageExpirySeconds BIGINT,
  ADD ATTRIBUTE reminder beeper_desktop_api_chats.chat_create_response_reminder,
  ADD ATTRIBUTE snooze beeper_desktop_api_chats.chat_create_response_snooze,
  ADD ATTRIBUTE unreadMentionsCount BIGINT,
  ADD ATTRIBUTE status TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_create_response(
  id TEXT,
  accountID TEXT,
  network TEXT,
  participants beeper_desktop_api_chats.chat_create_response_participant,
  title TEXT,
  type TEXT,
  unreadCount BIGINT,
  chatID TEXT,
  capabilities beeper_desktop_api_chats.chat_create_response_capability DEFAULT NULL,
  description TEXT DEFAULT NULL,
  draft beeper_desktop_api_chats.chat_create_response_draft DEFAULT NULL,
  imgURL TEXT DEFAULT NULL,
  isArchived BOOLEAN DEFAULT NULL,
  isLowPriority BOOLEAN DEFAULT NULL,
  isMarkedUnread BOOLEAN DEFAULT NULL,
  isMuted BOOLEAN DEFAULT NULL,
  isPinned BOOLEAN DEFAULT NULL,
  isReadOnly BOOLEAN DEFAULT NULL,
  lastActivity TIMESTAMP DEFAULT NULL,
  lastReadMessageSortKey TEXT DEFAULT NULL,
  localChatID TEXT DEFAULT NULL,
  messageExpirySeconds BIGINT DEFAULT NULL,
  reminder beeper_desktop_api_chats.chat_create_response_reminder DEFAULT NULL,
  snooze beeper_desktop_api_chats.chat_create_response_snooze DEFAULT NULL,
  unreadMentionsCount BIGINT DEFAULT NULL,
  status TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_create_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    accountID,
    network,
    participants,
    title,
    type,
    unreadCount,
    chatID,
    capabilities,
    description,
    draft,
    imgURL,
    isArchived,
    isLowPriority,
    isMarkedUnread,
    isMuted,
    isPinned,
    isReadOnly,
    lastActivity,
    lastReadMessageSortKey,
    localChatID,
    messageExpirySeconds,
    reminder,
    snooze,
    unreadMentionsCount,
    status
  )::beeper_desktop_api_chats.chat_create_response;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_create_response_participant
  ADD ATTRIBUTE hasMore BOOLEAN,
  ADD ATTRIBUTE items beeper_desktop_api_chats.chat_create_response_participant_item[],
  ADD ATTRIBUTE total BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_create_response_participant(
  hasMore BOOLEAN,
  items beeper_desktop_api_chats.chat_create_response_participant_item[],
  total BIGINT
)
RETURNS beeper_desktop_api_chats.chat_create_response_participant
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    hasMore, items, total
  )::beeper_desktop_api_chats.chat_create_response_participant;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_create_response_participant_item
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE cannotMessage BOOLEAN,
  ADD ATTRIBUTE email TEXT,
  ADD ATTRIBUTE fullName TEXT,
  ADD ATTRIBUTE imgURL TEXT,
  ADD ATTRIBUTE isSelf BOOLEAN,
  ADD ATTRIBUTE phoneNumber TEXT,
  ADD ATTRIBUTE username TEXT,
  ADD ATTRIBUTE isAdmin BOOLEAN,
  ADD ATTRIBUTE isNetworkBot BOOLEAN,
  ADD ATTRIBUTE isPending BOOLEAN;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_create_response_participant_item(
  id TEXT,
  cannotMessage BOOLEAN DEFAULT NULL,
  email TEXT DEFAULT NULL,
  fullName TEXT DEFAULT NULL,
  imgURL TEXT DEFAULT NULL,
  isSelf BOOLEAN DEFAULT NULL,
  phoneNumber TEXT DEFAULT NULL,
  username TEXT DEFAULT NULL,
  isAdmin BOOLEAN DEFAULT NULL,
  isNetworkBot BOOLEAN DEFAULT NULL,
  isPending BOOLEAN DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_create_response_participant_item
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    cannotMessage,
    email,
    fullName,
    imgURL,
    isSelf,
    phoneNumber,
    username,
    isAdmin,
    isNetworkBot,
    isPending
  )::beeper_desktop_api_chats.chat_create_response_participant_item;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_create_response_capability
  ADD ATTRIBUTE allowedReactions TEXT[],
  ADD ATTRIBUTE archive BOOLEAN,
  ADD ATTRIBUTE attachments JSONB,
  ADD ATTRIBUTE customEmojiReactions BOOLEAN,
  ADD ATTRIBUTE delete BIGINT,
  ADD ATTRIBUTE deleteChat BOOLEAN,
  ADD ATTRIBUTE deleteChatForEveryone BOOLEAN,
  ADD ATTRIBUTE deleteForMe BOOLEAN,
  ADD ATTRIBUTE deleteMaxAge BIGINT,
  ADD ATTRIBUTE disappearingTimer beeper_desktop_api_chats.chat_create_response_capability_disappearing_timer,
  ADD ATTRIBUTE edit BIGINT,
  ADD ATTRIBUTE editMaxAge BIGINT,
  ADD ATTRIBUTE editMaxCount BIGINT,
  ADD ATTRIBUTE formatting JSONB,
  ADD ATTRIBUTE locationMessage BIGINT,
  ADD ATTRIBUTE markAsUnread BOOLEAN,
  ADD ATTRIBUTE maxTextLength BIGINT,
  ADD ATTRIBUTE messageRequest beeper_desktop_api_chats.chat_create_response_capability_message_request,
  ADD ATTRIBUTE participantActions beeper_desktop_api_chats.chat_create_response_capability_participant_action,
  ADD ATTRIBUTE poll BIGINT,
  ADD ATTRIBUTE reaction BIGINT,
  ADD ATTRIBUTE reactionCount BIGINT,
  ADD ATTRIBUTE readReceipts BOOLEAN,
  ADD ATTRIBUTE reply BIGINT,
  ADD ATTRIBUTE state beeper_desktop_api_chats.chat_create_response_capability_state,
  ADD ATTRIBUTE thread BIGINT,
  ADD ATTRIBUTE typingNotifications BOOLEAN;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_create_response_capability(
  allowedReactions TEXT[] DEFAULT NULL,
  archive BOOLEAN DEFAULT NULL,
  attachments JSONB DEFAULT NULL,
  customEmojiReactions BOOLEAN DEFAULT NULL,
  delete BIGINT DEFAULT NULL,
  deleteChat BOOLEAN DEFAULT NULL,
  deleteChatForEveryone BOOLEAN DEFAULT NULL,
  deleteForMe BOOLEAN DEFAULT NULL,
  deleteMaxAge BIGINT DEFAULT NULL,
  disappearingTimer beeper_desktop_api_chats.chat_create_response_capability_disappearing_timer DEFAULT NULL,
  edit BIGINT DEFAULT NULL,
  editMaxAge BIGINT DEFAULT NULL,
  editMaxCount BIGINT DEFAULT NULL,
  formatting JSONB DEFAULT NULL,
  locationMessage BIGINT DEFAULT NULL,
  markAsUnread BOOLEAN DEFAULT NULL,
  maxTextLength BIGINT DEFAULT NULL,
  messageRequest beeper_desktop_api_chats.chat_create_response_capability_message_request DEFAULT NULL,
  participantActions beeper_desktop_api_chats.chat_create_response_capability_participant_action DEFAULT NULL,
  poll BIGINT DEFAULT NULL,
  reaction BIGINT DEFAULT NULL,
  reactionCount BIGINT DEFAULT NULL,
  readReceipts BOOLEAN DEFAULT NULL,
  reply BIGINT DEFAULT NULL,
  state beeper_desktop_api_chats.chat_create_response_capability_state DEFAULT NULL,
  thread BIGINT DEFAULT NULL,
  typingNotifications BOOLEAN DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_create_response_capability
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    allowedReactions,
    archive,
    attachments,
    customEmojiReactions,
    delete,
    deleteChat,
    deleteChatForEveryone,
    deleteForMe,
    deleteMaxAge,
    disappearingTimer,
    edit,
    editMaxAge,
    editMaxCount,
    formatting,
    locationMessage,
    markAsUnread,
    maxTextLength,
    messageRequest,
    participantActions,
    poll,
    reaction,
    reactionCount,
    readReceipts,
    reply,
    state,
    thread,
    typingNotifications
  )::beeper_desktop_api_chats.chat_create_response_capability;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_create_response_capability_disappearing_timer
  ADD ATTRIBUTE omitEmptyTimer BOOLEAN,
  ADD ATTRIBUTE timers BIGINT[],
  ADD ATTRIBUTE types TEXT[];

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_create_response_capability_disappearing_timer(
  omitEmptyTimer BOOLEAN DEFAULT NULL,
  timers BIGINT[] DEFAULT NULL,
  types TEXT[] DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_create_response_capability_disappearing_timer
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    omitEmptyTimer, timers, types
  )::beeper_desktop_api_chats.chat_create_response_capability_disappearing_timer;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_create_response_capability_message_request
  ADD ATTRIBUTE acceptWithButton BIGINT, ADD ATTRIBUTE acceptWithMessage BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_create_response_capability_message_request(
  acceptWithButton BIGINT DEFAULT NULL, acceptWithMessage BIGINT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_create_response_capability_message_request
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    acceptWithButton, acceptWithMessage
  )::beeper_desktop_api_chats.chat_create_response_capability_message_request;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_create_response_capability_participant_action
  ADD ATTRIBUTE ban BIGINT,
  ADD ATTRIBUTE invite BIGINT,
  ADD ATTRIBUTE kick BIGINT,
  ADD ATTRIBUTE leave BIGINT,
  ADD ATTRIBUTE revokeInvite BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_create_response_capability_participant_action(
  ban BIGINT DEFAULT NULL,
  invite BIGINT DEFAULT NULL,
  kick BIGINT DEFAULT NULL,
  leave BIGINT DEFAULT NULL,
  revokeInvite BIGINT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_create_response_capability_participant_action
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    ban, invite, kick, leave, revokeInvite
  )::beeper_desktop_api_chats.chat_create_response_capability_participant_action;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_create_response_capability_state
  ADD ATTRIBUTE avatar beeper_desktop_api_chats.chat_create_response_capability_state_avatar,
  ADD ATTRIBUTE description beeper_desktop_api_chats.chat_create_response_capability_state_description,
  ADD ATTRIBUTE disappearingTimer beeper_desktop_api_chats.chat_create_response_capability_state_disappearing_timer,
  ADD ATTRIBUTE title beeper_desktop_api_chats.chat_create_response_capability_state_title;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_create_response_capability_state(
  avatar beeper_desktop_api_chats.chat_create_response_capability_state_avatar DEFAULT NULL,
  description beeper_desktop_api_chats.chat_create_response_capability_state_description DEFAULT NULL,
  disappearingTimer beeper_desktop_api_chats.chat_create_response_capability_state_disappearing_timer DEFAULT NULL,
  title beeper_desktop_api_chats.chat_create_response_capability_state_title DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_create_response_capability_state
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    avatar, description, disappearingTimer, title
  )::beeper_desktop_api_chats.chat_create_response_capability_state;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_create_response_capability_state_avatar
  ADD ATTRIBUTE level BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_create_response_capability_state_avatar(
  level BIGINT
)
RETURNS beeper_desktop_api_chats.chat_create_response_capability_state_avatar
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    level
  )::beeper_desktop_api_chats.chat_create_response_capability_state_avatar;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_create_response_capability_state_description
  ADD ATTRIBUTE level BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_create_response_capability_state_description(
  level BIGINT
)
RETURNS beeper_desktop_api_chats.chat_create_response_capability_state_description
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    level
  )::beeper_desktop_api_chats.chat_create_response_capability_state_description;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_create_response_capability_state_disappearing_timer
  ADD ATTRIBUTE level BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_create_response_capability_state_disappearing_timer(
  level BIGINT
)
RETURNS beeper_desktop_api_chats.chat_create_response_capability_state_disappearing_timer
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    level
  )::beeper_desktop_api_chats.chat_create_response_capability_state_disappearing_timer;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_create_response_capability_state_title
  ADD ATTRIBUTE level BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_create_response_capability_state_title(
  level BIGINT
)
RETURNS beeper_desktop_api_chats.chat_create_response_capability_state_title
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    level
  )::beeper_desktop_api_chats.chat_create_response_capability_state_title;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_create_response_draft
  ADD ATTRIBUTE text TEXT, ADD ATTRIBUTE attachments JSONB;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_create_response_draft(
  text TEXT, attachments JSONB DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_create_response_draft
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    text, attachments
  )::beeper_desktop_api_chats.chat_create_response_draft;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_create_response_reminder
  ADD ATTRIBUTE dismissOnIncomingMessage BOOLEAN,
  ADD ATTRIBUTE remindAt TIMESTAMP;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_create_response_reminder(
  dismissOnIncomingMessage BOOLEAN DEFAULT NULL, remindAt TIMESTAMP DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_create_response_reminder
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    dismissOnIncomingMessage, remindAt
  )::beeper_desktop_api_chats.chat_create_response_reminder;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_create_response_snooze
  ADD ATTRIBUTE snoozeUntil TIMESTAMP, ADD ATTRIBUTE userSnoozedAt TIMESTAMP;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_create_response_snooze(
  snoozeUntil TIMESTAMP DEFAULT NULL, userSnoozedAt TIMESTAMP DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_create_response_snooze
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    snoozeUntil, userSnoozedAt
  )::beeper_desktop_api_chats.chat_create_response_snooze;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_list_response
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE accountID TEXT,
  ADD ATTRIBUTE network TEXT,
  ADD ATTRIBUTE participants beeper_desktop_api_chats.chat_list_response_participant,
  ADD ATTRIBUTE title TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE unreadCount BIGINT,
  ADD ATTRIBUTE capabilities beeper_desktop_api_chats.chat_list_response_capability,
  ADD ATTRIBUTE description TEXT,
  ADD ATTRIBUTE draft beeper_desktop_api_chats.chat_list_response_draft,
  ADD ATTRIBUTE imgURL TEXT,
  ADD ATTRIBUTE isArchived BOOLEAN,
  ADD ATTRIBUTE isLowPriority BOOLEAN,
  ADD ATTRIBUTE isMarkedUnread BOOLEAN,
  ADD ATTRIBUTE isMuted BOOLEAN,
  ADD ATTRIBUTE isPinned BOOLEAN,
  ADD ATTRIBUTE isReadOnly BOOLEAN,
  ADD ATTRIBUTE lastActivity TIMESTAMP,
  ADD ATTRIBUTE lastReadMessageSortKey TEXT,
  ADD ATTRIBUTE localChatID TEXT,
  ADD ATTRIBUTE messageExpirySeconds BIGINT,
  ADD ATTRIBUTE reminder beeper_desktop_api_chats.chat_list_response_reminder,
  ADD ATTRIBUTE snooze beeper_desktop_api_chats.chat_list_response_snooze,
  ADD ATTRIBUTE unreadMentionsCount BIGINT,
  ADD ATTRIBUTE preview beeper_desktop_api.message;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_list_response(
  id TEXT,
  accountID TEXT,
  network TEXT,
  participants beeper_desktop_api_chats.chat_list_response_participant,
  title TEXT,
  type TEXT,
  unreadCount BIGINT,
  capabilities beeper_desktop_api_chats.chat_list_response_capability DEFAULT NULL,
  description TEXT DEFAULT NULL,
  draft beeper_desktop_api_chats.chat_list_response_draft DEFAULT NULL,
  imgURL TEXT DEFAULT NULL,
  isArchived BOOLEAN DEFAULT NULL,
  isLowPriority BOOLEAN DEFAULT NULL,
  isMarkedUnread BOOLEAN DEFAULT NULL,
  isMuted BOOLEAN DEFAULT NULL,
  isPinned BOOLEAN DEFAULT NULL,
  isReadOnly BOOLEAN DEFAULT NULL,
  lastActivity TIMESTAMP DEFAULT NULL,
  lastReadMessageSortKey TEXT DEFAULT NULL,
  localChatID TEXT DEFAULT NULL,
  messageExpirySeconds BIGINT DEFAULT NULL,
  reminder beeper_desktop_api_chats.chat_list_response_reminder DEFAULT NULL,
  snooze beeper_desktop_api_chats.chat_list_response_snooze DEFAULT NULL,
  unreadMentionsCount BIGINT DEFAULT NULL,
  preview beeper_desktop_api.message DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_list_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    accountID,
    network,
    participants,
    title,
    type,
    unreadCount,
    capabilities,
    description,
    draft,
    imgURL,
    isArchived,
    isLowPriority,
    isMarkedUnread,
    isMuted,
    isPinned,
    isReadOnly,
    lastActivity,
    lastReadMessageSortKey,
    localChatID,
    messageExpirySeconds,
    reminder,
    snooze,
    unreadMentionsCount,
    preview
  )::beeper_desktop_api_chats.chat_list_response;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_list_response_participant
  ADD ATTRIBUTE hasMore BOOLEAN,
  ADD ATTRIBUTE items beeper_desktop_api_chats.chat_list_response_participant_item[],
  ADD ATTRIBUTE total BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_list_response_participant(
  hasMore BOOLEAN,
  items beeper_desktop_api_chats.chat_list_response_participant_item[],
  total BIGINT
)
RETURNS beeper_desktop_api_chats.chat_list_response_participant
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    hasMore, items, total
  )::beeper_desktop_api_chats.chat_list_response_participant;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_list_response_participant_item
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE cannotMessage BOOLEAN,
  ADD ATTRIBUTE email TEXT,
  ADD ATTRIBUTE fullName TEXT,
  ADD ATTRIBUTE imgURL TEXT,
  ADD ATTRIBUTE isSelf BOOLEAN,
  ADD ATTRIBUTE phoneNumber TEXT,
  ADD ATTRIBUTE username TEXT,
  ADD ATTRIBUTE isAdmin BOOLEAN,
  ADD ATTRIBUTE isNetworkBot BOOLEAN,
  ADD ATTRIBUTE isPending BOOLEAN;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_list_response_participant_item(
  id TEXT,
  cannotMessage BOOLEAN DEFAULT NULL,
  email TEXT DEFAULT NULL,
  fullName TEXT DEFAULT NULL,
  imgURL TEXT DEFAULT NULL,
  isSelf BOOLEAN DEFAULT NULL,
  phoneNumber TEXT DEFAULT NULL,
  username TEXT DEFAULT NULL,
  isAdmin BOOLEAN DEFAULT NULL,
  isNetworkBot BOOLEAN DEFAULT NULL,
  isPending BOOLEAN DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_list_response_participant_item
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    cannotMessage,
    email,
    fullName,
    imgURL,
    isSelf,
    phoneNumber,
    username,
    isAdmin,
    isNetworkBot,
    isPending
  )::beeper_desktop_api_chats.chat_list_response_participant_item;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_list_response_capability
  ADD ATTRIBUTE allowedReactions TEXT[],
  ADD ATTRIBUTE archive BOOLEAN,
  ADD ATTRIBUTE attachments JSONB,
  ADD ATTRIBUTE customEmojiReactions BOOLEAN,
  ADD ATTRIBUTE delete BIGINT,
  ADD ATTRIBUTE deleteChat BOOLEAN,
  ADD ATTRIBUTE deleteChatForEveryone BOOLEAN,
  ADD ATTRIBUTE deleteForMe BOOLEAN,
  ADD ATTRIBUTE deleteMaxAge BIGINT,
  ADD ATTRIBUTE disappearingTimer beeper_desktop_api_chats.chat_list_response_capability_disappearing_timer,
  ADD ATTRIBUTE edit BIGINT,
  ADD ATTRIBUTE editMaxAge BIGINT,
  ADD ATTRIBUTE editMaxCount BIGINT,
  ADD ATTRIBUTE formatting JSONB,
  ADD ATTRIBUTE locationMessage BIGINT,
  ADD ATTRIBUTE markAsUnread BOOLEAN,
  ADD ATTRIBUTE maxTextLength BIGINT,
  ADD ATTRIBUTE messageRequest beeper_desktop_api_chats.chat_list_response_capability_message_request,
  ADD ATTRIBUTE participantActions beeper_desktop_api_chats.chat_list_response_capability_participant_action,
  ADD ATTRIBUTE poll BIGINT,
  ADD ATTRIBUTE reaction BIGINT,
  ADD ATTRIBUTE reactionCount BIGINT,
  ADD ATTRIBUTE readReceipts BOOLEAN,
  ADD ATTRIBUTE reply BIGINT,
  ADD ATTRIBUTE state beeper_desktop_api_chats.chat_list_response_capability_state,
  ADD ATTRIBUTE thread BIGINT,
  ADD ATTRIBUTE typingNotifications BOOLEAN;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_list_response_capability(
  allowedReactions TEXT[] DEFAULT NULL,
  archive BOOLEAN DEFAULT NULL,
  attachments JSONB DEFAULT NULL,
  customEmojiReactions BOOLEAN DEFAULT NULL,
  delete BIGINT DEFAULT NULL,
  deleteChat BOOLEAN DEFAULT NULL,
  deleteChatForEveryone BOOLEAN DEFAULT NULL,
  deleteForMe BOOLEAN DEFAULT NULL,
  deleteMaxAge BIGINT DEFAULT NULL,
  disappearingTimer beeper_desktop_api_chats.chat_list_response_capability_disappearing_timer DEFAULT NULL,
  edit BIGINT DEFAULT NULL,
  editMaxAge BIGINT DEFAULT NULL,
  editMaxCount BIGINT DEFAULT NULL,
  formatting JSONB DEFAULT NULL,
  locationMessage BIGINT DEFAULT NULL,
  markAsUnread BOOLEAN DEFAULT NULL,
  maxTextLength BIGINT DEFAULT NULL,
  messageRequest beeper_desktop_api_chats.chat_list_response_capability_message_request DEFAULT NULL,
  participantActions beeper_desktop_api_chats.chat_list_response_capability_participant_action DEFAULT NULL,
  poll BIGINT DEFAULT NULL,
  reaction BIGINT DEFAULT NULL,
  reactionCount BIGINT DEFAULT NULL,
  readReceipts BOOLEAN DEFAULT NULL,
  reply BIGINT DEFAULT NULL,
  state beeper_desktop_api_chats.chat_list_response_capability_state DEFAULT NULL,
  thread BIGINT DEFAULT NULL,
  typingNotifications BOOLEAN DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_list_response_capability
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    allowedReactions,
    archive,
    attachments,
    customEmojiReactions,
    delete,
    deleteChat,
    deleteChatForEveryone,
    deleteForMe,
    deleteMaxAge,
    disappearingTimer,
    edit,
    editMaxAge,
    editMaxCount,
    formatting,
    locationMessage,
    markAsUnread,
    maxTextLength,
    messageRequest,
    participantActions,
    poll,
    reaction,
    reactionCount,
    readReceipts,
    reply,
    state,
    thread,
    typingNotifications
  )::beeper_desktop_api_chats.chat_list_response_capability;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_list_response_capability_disappearing_timer
  ADD ATTRIBUTE omitEmptyTimer BOOLEAN,
  ADD ATTRIBUTE timers BIGINT[],
  ADD ATTRIBUTE types TEXT[];

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_list_response_capability_disappearing_timer(
  omitEmptyTimer BOOLEAN DEFAULT NULL,
  timers BIGINT[] DEFAULT NULL,
  types TEXT[] DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_list_response_capability_disappearing_timer
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    omitEmptyTimer, timers, types
  )::beeper_desktop_api_chats.chat_list_response_capability_disappearing_timer;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_list_response_capability_message_request
  ADD ATTRIBUTE acceptWithButton BIGINT, ADD ATTRIBUTE acceptWithMessage BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_list_response_capability_message_request(
  acceptWithButton BIGINT DEFAULT NULL, acceptWithMessage BIGINT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_list_response_capability_message_request
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    acceptWithButton, acceptWithMessage
  )::beeper_desktop_api_chats.chat_list_response_capability_message_request;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_list_response_capability_participant_action
  ADD ATTRIBUTE ban BIGINT,
  ADD ATTRIBUTE invite BIGINT,
  ADD ATTRIBUTE kick BIGINT,
  ADD ATTRIBUTE leave BIGINT,
  ADD ATTRIBUTE revokeInvite BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_list_response_capability_participant_action(
  ban BIGINT DEFAULT NULL,
  invite BIGINT DEFAULT NULL,
  kick BIGINT DEFAULT NULL,
  leave BIGINT DEFAULT NULL,
  revokeInvite BIGINT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_list_response_capability_participant_action
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    ban, invite, kick, leave, revokeInvite
  )::beeper_desktop_api_chats.chat_list_response_capability_participant_action;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_list_response_capability_state
  ADD ATTRIBUTE avatar beeper_desktop_api_chats.chat_list_response_capability_state_avatar,
  ADD ATTRIBUTE description beeper_desktop_api_chats.chat_list_response_capability_state_description,
  ADD ATTRIBUTE disappearingTimer beeper_desktop_api_chats.chat_list_response_capability_state_disappearing_timer,
  ADD ATTRIBUTE title beeper_desktop_api_chats.chat_list_response_capability_state_title;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_list_response_capability_state(
  avatar beeper_desktop_api_chats.chat_list_response_capability_state_avatar DEFAULT NULL,
  description beeper_desktop_api_chats.chat_list_response_capability_state_description DEFAULT NULL,
  disappearingTimer beeper_desktop_api_chats.chat_list_response_capability_state_disappearing_timer DEFAULT NULL,
  title beeper_desktop_api_chats.chat_list_response_capability_state_title DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_list_response_capability_state
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    avatar, description, disappearingTimer, title
  )::beeper_desktop_api_chats.chat_list_response_capability_state;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_list_response_capability_state_avatar
  ADD ATTRIBUTE level BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_list_response_capability_state_avatar(
  level BIGINT
)
RETURNS beeper_desktop_api_chats.chat_list_response_capability_state_avatar
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    level
  )::beeper_desktop_api_chats.chat_list_response_capability_state_avatar;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_list_response_capability_state_description
  ADD ATTRIBUTE level BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_list_response_capability_state_description(
  level BIGINT
)
RETURNS beeper_desktop_api_chats.chat_list_response_capability_state_description
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    level
  )::beeper_desktop_api_chats.chat_list_response_capability_state_description;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_list_response_capability_state_disappearing_timer
  ADD ATTRIBUTE level BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_list_response_capability_state_disappearing_timer(
  level BIGINT
)
RETURNS beeper_desktop_api_chats.chat_list_response_capability_state_disappearing_timer
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    level
  )::beeper_desktop_api_chats.chat_list_response_capability_state_disappearing_timer;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_list_response_capability_state_title
  ADD ATTRIBUTE level BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_list_response_capability_state_title(
  level BIGINT
)
RETURNS beeper_desktop_api_chats.chat_list_response_capability_state_title
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    level
  )::beeper_desktop_api_chats.chat_list_response_capability_state_title;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_list_response_draft
  ADD ATTRIBUTE text TEXT, ADD ATTRIBUTE attachments JSONB;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_list_response_draft(
  text TEXT, attachments JSONB DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_list_response_draft
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    text, attachments
  )::beeper_desktop_api_chats.chat_list_response_draft;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_list_response_reminder
  ADD ATTRIBUTE dismissOnIncomingMessage BOOLEAN,
  ADD ATTRIBUTE remindAt TIMESTAMP;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_list_response_reminder(
  dismissOnIncomingMessage BOOLEAN DEFAULT NULL, remindAt TIMESTAMP DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_list_response_reminder
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    dismissOnIncomingMessage, remindAt
  )::beeper_desktop_api_chats.chat_list_response_reminder;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_list_response_snooze
  ADD ATTRIBUTE snoozeUntil TIMESTAMP, ADD ATTRIBUTE userSnoozedAt TIMESTAMP;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_list_response_snooze(
  snoozeUntil TIMESTAMP DEFAULT NULL, userSnoozedAt TIMESTAMP DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_list_response_snooze
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    snoozeUntil, userSnoozedAt
  )::beeper_desktop_api_chats.chat_list_response_snooze;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_start_response
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE accountID TEXT,
  ADD ATTRIBUTE network TEXT,
  ADD ATTRIBUTE participants beeper_desktop_api_chats.chat_start_response_participant,
  ADD ATTRIBUTE title TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE unreadCount BIGINT,
  ADD ATTRIBUTE chatID TEXT,
  ADD ATTRIBUTE capabilities beeper_desktop_api_chats.chat_start_response_capability,
  ADD ATTRIBUTE description TEXT,
  ADD ATTRIBUTE draft beeper_desktop_api_chats.chat_start_response_draft,
  ADD ATTRIBUTE imgURL TEXT,
  ADD ATTRIBUTE isArchived BOOLEAN,
  ADD ATTRIBUTE isLowPriority BOOLEAN,
  ADD ATTRIBUTE isMarkedUnread BOOLEAN,
  ADD ATTRIBUTE isMuted BOOLEAN,
  ADD ATTRIBUTE isPinned BOOLEAN,
  ADD ATTRIBUTE isReadOnly BOOLEAN,
  ADD ATTRIBUTE lastActivity TIMESTAMP,
  ADD ATTRIBUTE lastReadMessageSortKey TEXT,
  ADD ATTRIBUTE localChatID TEXT,
  ADD ATTRIBUTE messageExpirySeconds BIGINT,
  ADD ATTRIBUTE reminder beeper_desktop_api_chats.chat_start_response_reminder,
  ADD ATTRIBUTE snooze beeper_desktop_api_chats.chat_start_response_snooze,
  ADD ATTRIBUTE unreadMentionsCount BIGINT,
  ADD ATTRIBUTE status TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_start_response(
  id TEXT,
  accountID TEXT,
  network TEXT,
  participants beeper_desktop_api_chats.chat_start_response_participant,
  title TEXT,
  type TEXT,
  unreadCount BIGINT,
  chatID TEXT,
  capabilities beeper_desktop_api_chats.chat_start_response_capability DEFAULT NULL,
  description TEXT DEFAULT NULL,
  draft beeper_desktop_api_chats.chat_start_response_draft DEFAULT NULL,
  imgURL TEXT DEFAULT NULL,
  isArchived BOOLEAN DEFAULT NULL,
  isLowPriority BOOLEAN DEFAULT NULL,
  isMarkedUnread BOOLEAN DEFAULT NULL,
  isMuted BOOLEAN DEFAULT NULL,
  isPinned BOOLEAN DEFAULT NULL,
  isReadOnly BOOLEAN DEFAULT NULL,
  lastActivity TIMESTAMP DEFAULT NULL,
  lastReadMessageSortKey TEXT DEFAULT NULL,
  localChatID TEXT DEFAULT NULL,
  messageExpirySeconds BIGINT DEFAULT NULL,
  reminder beeper_desktop_api_chats.chat_start_response_reminder DEFAULT NULL,
  snooze beeper_desktop_api_chats.chat_start_response_snooze DEFAULT NULL,
  unreadMentionsCount BIGINT DEFAULT NULL,
  status TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_start_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    accountID,
    network,
    participants,
    title,
    type,
    unreadCount,
    chatID,
    capabilities,
    description,
    draft,
    imgURL,
    isArchived,
    isLowPriority,
    isMarkedUnread,
    isMuted,
    isPinned,
    isReadOnly,
    lastActivity,
    lastReadMessageSortKey,
    localChatID,
    messageExpirySeconds,
    reminder,
    snooze,
    unreadMentionsCount,
    status
  )::beeper_desktop_api_chats.chat_start_response;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_start_response_participant
  ADD ATTRIBUTE hasMore BOOLEAN,
  ADD ATTRIBUTE items beeper_desktop_api_chats.chat_start_response_participant_item[],
  ADD ATTRIBUTE total BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_start_response_participant(
  hasMore BOOLEAN,
  items beeper_desktop_api_chats.chat_start_response_participant_item[],
  total BIGINT
)
RETURNS beeper_desktop_api_chats.chat_start_response_participant
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    hasMore, items, total
  )::beeper_desktop_api_chats.chat_start_response_participant;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_start_response_participant_item
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE cannotMessage BOOLEAN,
  ADD ATTRIBUTE email TEXT,
  ADD ATTRIBUTE fullName TEXT,
  ADD ATTRIBUTE imgURL TEXT,
  ADD ATTRIBUTE isSelf BOOLEAN,
  ADD ATTRIBUTE phoneNumber TEXT,
  ADD ATTRIBUTE username TEXT,
  ADD ATTRIBUTE isAdmin BOOLEAN,
  ADD ATTRIBUTE isNetworkBot BOOLEAN,
  ADD ATTRIBUTE isPending BOOLEAN;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_start_response_participant_item(
  id TEXT,
  cannotMessage BOOLEAN DEFAULT NULL,
  email TEXT DEFAULT NULL,
  fullName TEXT DEFAULT NULL,
  imgURL TEXT DEFAULT NULL,
  isSelf BOOLEAN DEFAULT NULL,
  phoneNumber TEXT DEFAULT NULL,
  username TEXT DEFAULT NULL,
  isAdmin BOOLEAN DEFAULT NULL,
  isNetworkBot BOOLEAN DEFAULT NULL,
  isPending BOOLEAN DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_start_response_participant_item
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    cannotMessage,
    email,
    fullName,
    imgURL,
    isSelf,
    phoneNumber,
    username,
    isAdmin,
    isNetworkBot,
    isPending
  )::beeper_desktop_api_chats.chat_start_response_participant_item;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_start_response_capability
  ADD ATTRIBUTE allowedReactions TEXT[],
  ADD ATTRIBUTE archive BOOLEAN,
  ADD ATTRIBUTE attachments JSONB,
  ADD ATTRIBUTE customEmojiReactions BOOLEAN,
  ADD ATTRIBUTE delete BIGINT,
  ADD ATTRIBUTE deleteChat BOOLEAN,
  ADD ATTRIBUTE deleteChatForEveryone BOOLEAN,
  ADD ATTRIBUTE deleteForMe BOOLEAN,
  ADD ATTRIBUTE deleteMaxAge BIGINT,
  ADD ATTRIBUTE disappearingTimer beeper_desktop_api_chats.chat_start_response_capability_disappearing_timer,
  ADD ATTRIBUTE edit BIGINT,
  ADD ATTRIBUTE editMaxAge BIGINT,
  ADD ATTRIBUTE editMaxCount BIGINT,
  ADD ATTRIBUTE formatting JSONB,
  ADD ATTRIBUTE locationMessage BIGINT,
  ADD ATTRIBUTE markAsUnread BOOLEAN,
  ADD ATTRIBUTE maxTextLength BIGINT,
  ADD ATTRIBUTE messageRequest beeper_desktop_api_chats.chat_start_response_capability_message_request,
  ADD ATTRIBUTE participantActions beeper_desktop_api_chats.chat_start_response_capability_participant_action,
  ADD ATTRIBUTE poll BIGINT,
  ADD ATTRIBUTE reaction BIGINT,
  ADD ATTRIBUTE reactionCount BIGINT,
  ADD ATTRIBUTE readReceipts BOOLEAN,
  ADD ATTRIBUTE reply BIGINT,
  ADD ATTRIBUTE state beeper_desktop_api_chats.chat_start_response_capability_state,
  ADD ATTRIBUTE thread BIGINT,
  ADD ATTRIBUTE typingNotifications BOOLEAN;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_start_response_capability(
  allowedReactions TEXT[] DEFAULT NULL,
  archive BOOLEAN DEFAULT NULL,
  attachments JSONB DEFAULT NULL,
  customEmojiReactions BOOLEAN DEFAULT NULL,
  delete BIGINT DEFAULT NULL,
  deleteChat BOOLEAN DEFAULT NULL,
  deleteChatForEveryone BOOLEAN DEFAULT NULL,
  deleteForMe BOOLEAN DEFAULT NULL,
  deleteMaxAge BIGINT DEFAULT NULL,
  disappearingTimer beeper_desktop_api_chats.chat_start_response_capability_disappearing_timer DEFAULT NULL,
  edit BIGINT DEFAULT NULL,
  editMaxAge BIGINT DEFAULT NULL,
  editMaxCount BIGINT DEFAULT NULL,
  formatting JSONB DEFAULT NULL,
  locationMessage BIGINT DEFAULT NULL,
  markAsUnread BOOLEAN DEFAULT NULL,
  maxTextLength BIGINT DEFAULT NULL,
  messageRequest beeper_desktop_api_chats.chat_start_response_capability_message_request DEFAULT NULL,
  participantActions beeper_desktop_api_chats.chat_start_response_capability_participant_action DEFAULT NULL,
  poll BIGINT DEFAULT NULL,
  reaction BIGINT DEFAULT NULL,
  reactionCount BIGINT DEFAULT NULL,
  readReceipts BOOLEAN DEFAULT NULL,
  reply BIGINT DEFAULT NULL,
  state beeper_desktop_api_chats.chat_start_response_capability_state DEFAULT NULL,
  thread BIGINT DEFAULT NULL,
  typingNotifications BOOLEAN DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_start_response_capability
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    allowedReactions,
    archive,
    attachments,
    customEmojiReactions,
    delete,
    deleteChat,
    deleteChatForEveryone,
    deleteForMe,
    deleteMaxAge,
    disappearingTimer,
    edit,
    editMaxAge,
    editMaxCount,
    formatting,
    locationMessage,
    markAsUnread,
    maxTextLength,
    messageRequest,
    participantActions,
    poll,
    reaction,
    reactionCount,
    readReceipts,
    reply,
    state,
    thread,
    typingNotifications
  )::beeper_desktop_api_chats.chat_start_response_capability;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_start_response_capability_disappearing_timer
  ADD ATTRIBUTE omitEmptyTimer BOOLEAN,
  ADD ATTRIBUTE timers BIGINT[],
  ADD ATTRIBUTE types TEXT[];

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_start_response_capability_disappearing_timer(
  omitEmptyTimer BOOLEAN DEFAULT NULL,
  timers BIGINT[] DEFAULT NULL,
  types TEXT[] DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_start_response_capability_disappearing_timer
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    omitEmptyTimer, timers, types
  )::beeper_desktop_api_chats.chat_start_response_capability_disappearing_timer;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_start_response_capability_message_request
  ADD ATTRIBUTE acceptWithButton BIGINT, ADD ATTRIBUTE acceptWithMessage BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_start_response_capability_message_request(
  acceptWithButton BIGINT DEFAULT NULL, acceptWithMessage BIGINT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_start_response_capability_message_request
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    acceptWithButton, acceptWithMessage
  )::beeper_desktop_api_chats.chat_start_response_capability_message_request;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_start_response_capability_participant_action
  ADD ATTRIBUTE ban BIGINT,
  ADD ATTRIBUTE invite BIGINT,
  ADD ATTRIBUTE kick BIGINT,
  ADD ATTRIBUTE leave BIGINT,
  ADD ATTRIBUTE revokeInvite BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_start_response_capability_participant_action(
  ban BIGINT DEFAULT NULL,
  invite BIGINT DEFAULT NULL,
  kick BIGINT DEFAULT NULL,
  leave BIGINT DEFAULT NULL,
  revokeInvite BIGINT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_start_response_capability_participant_action
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    ban, invite, kick, leave, revokeInvite
  )::beeper_desktop_api_chats.chat_start_response_capability_participant_action;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_start_response_capability_state
  ADD ATTRIBUTE avatar beeper_desktop_api_chats.chat_start_response_capability_state_avatar,
  ADD ATTRIBUTE description beeper_desktop_api_chats.chat_start_response_capability_state_description,
  ADD ATTRIBUTE disappearingTimer beeper_desktop_api_chats.chat_start_response_capability_state_disappearing_timer,
  ADD ATTRIBUTE title beeper_desktop_api_chats.chat_start_response_capability_state_title;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_start_response_capability_state(
  avatar beeper_desktop_api_chats.chat_start_response_capability_state_avatar DEFAULT NULL,
  description beeper_desktop_api_chats.chat_start_response_capability_state_description DEFAULT NULL,
  disappearingTimer beeper_desktop_api_chats.chat_start_response_capability_state_disappearing_timer DEFAULT NULL,
  title beeper_desktop_api_chats.chat_start_response_capability_state_title DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_start_response_capability_state
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    avatar, description, disappearingTimer, title
  )::beeper_desktop_api_chats.chat_start_response_capability_state;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_start_response_capability_state_avatar
  ADD ATTRIBUTE level BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_start_response_capability_state_avatar(
  level BIGINT
)
RETURNS beeper_desktop_api_chats.chat_start_response_capability_state_avatar
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    level
  )::beeper_desktop_api_chats.chat_start_response_capability_state_avatar;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_start_response_capability_state_description
  ADD ATTRIBUTE level BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_start_response_capability_state_description(
  level BIGINT
)
RETURNS beeper_desktop_api_chats.chat_start_response_capability_state_description
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    level
  )::beeper_desktop_api_chats.chat_start_response_capability_state_description;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_start_response_capability_state_disappearing_timer
  ADD ATTRIBUTE level BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_start_response_capability_state_disappearing_timer(
  level BIGINT
)
RETURNS beeper_desktop_api_chats.chat_start_response_capability_state_disappearing_timer
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    level
  )::beeper_desktop_api_chats.chat_start_response_capability_state_disappearing_timer;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_start_response_capability_state_title
  ADD ATTRIBUTE level BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_start_response_capability_state_title(
  level BIGINT
)
RETURNS beeper_desktop_api_chats.chat_start_response_capability_state_title
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    level
  )::beeper_desktop_api_chats.chat_start_response_capability_state_title;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_start_response_draft
  ADD ATTRIBUTE text TEXT, ADD ATTRIBUTE attachments JSONB;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_start_response_draft(
  text TEXT, attachments JSONB DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_start_response_draft
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    text, attachments
  )::beeper_desktop_api_chats.chat_start_response_draft;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_start_response_reminder
  ADD ATTRIBUTE dismissOnIncomingMessage BOOLEAN,
  ADD ATTRIBUTE remindAt TIMESTAMP;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_start_response_reminder(
  dismissOnIncomingMessage BOOLEAN DEFAULT NULL, remindAt TIMESTAMP DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_start_response_reminder
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    dismissOnIncomingMessage, remindAt
  )::beeper_desktop_api_chats.chat_start_response_reminder;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_start_response_snooze
  ADD ATTRIBUTE snoozeUntil TIMESTAMP, ADD ATTRIBUTE userSnoozedAt TIMESTAMP;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_start_response_snooze(
  snoozeUntil TIMESTAMP DEFAULT NULL, userSnoozedAt TIMESTAMP DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_start_response_snooze
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    snoozeUntil, userSnoozedAt
  )::beeper_desktop_api_chats.chat_start_response_snooze;
$$;

ALTER TYPE beeper_desktop_api_chats.update_params_draft
  ADD ATTRIBUTE text TEXT, ADD ATTRIBUTE attachments JSONB;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_update_params_draft(
  text TEXT, attachments JSONB DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.update_params_draft
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(text, attachments)::beeper_desktop_api_chats.update_params_draft;
$$;

ALTER TYPE beeper_desktop_api_chats.start_params_user
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE email TEXT,
  ADD ATTRIBUTE fullName TEXT,
  ADD ATTRIBUTE phoneNumber TEXT,
  ADD ATTRIBUTE username TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_start_params_user(
  id TEXT DEFAULT NULL,
  email TEXT DEFAULT NULL,
  fullName TEXT DEFAULT NULL,
  phoneNumber TEXT DEFAULT NULL,
  username TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.start_params_user
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, email, fullName, phoneNumber, username
  )::beeper_desktop_api_chats.start_params_user;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats._create(
  account_id TEXT,
  participant_ids TEXT[],
  type TEXT,
  message_text TEXT DEFAULT NULL,
  title TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.chats.with_raw_response.create(
      account_id=account_id,
      participant_ids=participant_ids,
      type=type,
      message_text=not_given if message_text is None else message_text,
      title=not_given if title is None else title,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.create(
  account_id TEXT,
  participant_ids TEXT[],
  type TEXT,
  message_text TEXT DEFAULT NULL,
  title TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_create_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_chats.chat_create_response,
      beeper_desktop_api_chats._create(
        account_id, participant_ids, type, message_text, title
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats._retrieve(
  chat_id TEXT, max_participant_count BIGINT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.chats.with_raw_response.retrieve(
      chat_id=chat_id,
      max_participant_count=not_given if max_participant_count is None else max_participant_count,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.retrieve(
  chat_id TEXT, max_participant_count BIGINT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_chats.chat,
      beeper_desktop_api_chats._retrieve(chat_id, max_participant_count)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats._update(
  chat_id TEXT,
  description TEXT DEFAULT NULL,
  draft beeper_desktop_api_chats.update_params_draft DEFAULT NULL,
  img_url TEXT DEFAULT NULL,
  is_archived BOOLEAN DEFAULT NULL,
  is_low_priority BOOLEAN DEFAULT NULL,
  is_muted BOOLEAN DEFAULT NULL,
  is_pinned BOOLEAN DEFAULT NULL,
  message_expiry_seconds BIGINT DEFAULT NULL,
  title TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.chats.with_raw_response.update(
      chat_id=chat_id,
      description=not_given if description is None else description,
      draft=not_given if draft is None else GD["__beeper_desktop_api_context__"].strip_none(draft),
      img_url=not_given if img_url is None else img_url,
      is_archived=not_given if is_archived is None else is_archived,
      is_low_priority=not_given if is_low_priority is None else is_low_priority,
      is_muted=not_given if is_muted is None else is_muted,
      is_pinned=not_given if is_pinned is None else is_pinned,
      message_expiry_seconds=not_given if message_expiry_seconds is None else message_expiry_seconds,
      title=not_given if title is None else title,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.update(
  chat_id TEXT,
  description TEXT DEFAULT NULL,
  draft beeper_desktop_api_chats.update_params_draft DEFAULT NULL,
  img_url TEXT DEFAULT NULL,
  is_archived BOOLEAN DEFAULT NULL,
  is_low_priority BOOLEAN DEFAULT NULL,
  is_muted BOOLEAN DEFAULT NULL,
  is_pinned BOOLEAN DEFAULT NULL,
  message_expiry_seconds BIGINT DEFAULT NULL,
  title TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_chats.chat,
      beeper_desktop_api_chats._update(
        chat_id,
        description,
        draft,
        img_url,
        is_archived,
        is_low_priority,
        is_muted,
        is_pinned,
        message_expiry_seconds,
        title
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats._list_first_page_py(
  account_ids TEXT[] DEFAULT NULL,
  cursor TEXT DEFAULT NULL,
  direction TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  from beeper_desktop_api._types import not_given
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__beeper_desktop_api_context__"].client.chats.list(
      account_ids=not_given if account_ids is None else account_ids,
      cursor=not_given if cursor is None else cursor,
      direction=not_given if direction is None else direction,
  )
  next_page_info = page.next_page_info()
  if next_page_info is None:
      next_request_options = None
  else:
      next_request_options = page._info_to_options(next_page_info).model_dump_json(
        exclude_unset=True,
        exclude={'post_parser'}
      )

  # We convert to JSON instead of letting PL/Python perform data mapping because PL/Python errors for
  # omitted fields instead of defaulting them to NULL, but we want to be more lenient, which we handle
  # in the calling function later.
  type_adapter = TypeAdapter(Any)
  return (
    type_adapter.dump_json(page._get_page_items(), exclude_unset=True).decode("utf-8"),
    next_request_options
  )
$$;

-- A simpler wrapper around `beeper_desktop_api_chats._list_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION beeper_desktop_api_chats._list_first_page(
  account_ids TEXT[] DEFAULT NULL,
  cursor TEXT DEFAULT NULL,
  direction TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN beeper_desktop_api_chats._list_first_page_py(
      account_ids, cursor, direction
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats._list_next_page(request_options JSONB)
RETURNS beeper_desktop_api_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from beeper_desktop_api.types import ChatListResponse
  from beeper_desktop_api.pagination import SyncCursorNoLimit
  from beeper_desktop_api._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__beeper_desktop_api_context__"].client._request_api_list(
    model=ChatListResponse,
    page=SyncCursorNoLimit[ChatListResponse],
    options=FinalRequestOptions.construct(**json.loads(request_options))
  )
  next_page_info = page.next_page_info()
  if next_page_info is None:
      next_request_options = None
  else:
      next_request_options = page._info_to_options(next_page_info).model_dump_json(
        exclude_unset=True,
        exclude={'post_parser'}
      )

  # We convert to JSON instead of letting PL/Python perform data mapping because PL/Python errors for
  # omitted fields instead of defaulting them to NULL, but we want to be more lenient, which we handle
  # in the calling function later.
  type_adapter = TypeAdapter(Any)
  return (
    type_adapter.dump_json(page._get_page_items(), exclude_unset=True).decode("utf-8"),
    next_request_options
  )
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.list(
  account_ids TEXT[] DEFAULT NULL,
  cursor TEXT DEFAULT NULL,
  direction TEXT DEFAULT NULL
)
RETURNS SETOF beeper_desktop_api_chats.chat_list_response
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM beeper_desktop_api_chats._list_first_page(
      account_ids, cursor, direction
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN beeper_desktop_api_chats._list_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::beeper_desktop_api_chats.chat_list_response, data)).* FROM paginated;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats._archive(
  chat_id TEXT, archived BOOLEAN DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpython3u
AS $$
  from beeper_desktop_api._types import not_given

  GD["__beeper_desktop_api_context__"].client.chats.archive(
      chat_id=chat_id,
      archived=not_given if archived is None else archived,
  )
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.archive(
  chat_id TEXT, archived BOOLEAN DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    PERFORM beeper_desktop_api_chats._archive(chat_id, archived);
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats._mark_read(
  chat_id TEXT, message_id TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.chats.with_raw_response.mark_read(
      chat_id=chat_id,
      message_id=not_given if message_id is None else message_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.mark_read(
  chat_id TEXT, message_id TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_chats.chat,
      beeper_desktop_api_chats._mark_read(chat_id, message_id)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats._mark_unread(
  chat_id TEXT, message_id TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.chats.with_raw_response.mark_unread(
      chat_id=chat_id,
      message_id=not_given if message_id is None else message_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.mark_unread(
  chat_id TEXT, message_id TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_chats.chat,
      beeper_desktop_api_chats._mark_unread(chat_id, message_id)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats._notify_anyway(chat_id TEXT)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  response = GD["__beeper_desktop_api_context__"].client.chats.with_raw_response.notify_anyway(
      chat_id=chat_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.notify_anyway(chat_id TEXT)
RETURNS beeper_desktop_api_chats.chat
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_chats.chat,
      beeper_desktop_api_chats._notify_anyway(chat_id)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats._search_first_page_py(
  account_ids TEXT[] DEFAULT NULL,
  cursor TEXT DEFAULT NULL,
  direction TEXT DEFAULT NULL,
  inbox TEXT DEFAULT NULL,
  include_muted BOOLEAN DEFAULT NULL,
  last_activity_after TIMESTAMP DEFAULT NULL,
  last_activity_before TIMESTAMP DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  query TEXT DEFAULT NULL,
  scope TEXT DEFAULT NULL,
  type TEXT DEFAULT NULL,
  unread_only BOOLEAN DEFAULT NULL
)
RETURNS beeper_desktop_api_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  from beeper_desktop_api._types import not_given
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__beeper_desktop_api_context__"].client.chats.search(
      account_ids=not_given if account_ids is None else account_ids,
      cursor=not_given if cursor is None else cursor,
      direction=not_given if direction is None else direction,
      inbox=not_given if inbox is None else inbox,
      include_muted=not_given if include_muted is None else include_muted,
      last_activity_after=not_given if last_activity_after is None else last_activity_after,
      last_activity_before=not_given if last_activity_before is None else last_activity_before,
      limit=not_given if limit is None else limit,
      query=not_given if query is None else query,
      scope=not_given if scope is None else scope,
      type=not_given if type is None else type,
      unread_only=not_given if unread_only is None else unread_only,
  )
  next_page_info = page.next_page_info()
  if next_page_info is None:
      next_request_options = None
  else:
      next_request_options = page._info_to_options(next_page_info).model_dump_json(
        exclude_unset=True,
        exclude={'post_parser'}
      )

  # We convert to JSON instead of letting PL/Python perform data mapping because PL/Python errors for
  # omitted fields instead of defaulting them to NULL, but we want to be more lenient, which we handle
  # in the calling function later.
  type_adapter = TypeAdapter(Any)
  return (
    type_adapter.dump_json(page._get_page_items(), exclude_unset=True).decode("utf-8"),
    next_request_options
  )
$$;

-- A simpler wrapper around `beeper_desktop_api_chats._search_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION beeper_desktop_api_chats._search_first_page(
  account_ids TEXT[] DEFAULT NULL,
  cursor TEXT DEFAULT NULL,
  direction TEXT DEFAULT NULL,
  inbox TEXT DEFAULT NULL,
  include_muted BOOLEAN DEFAULT NULL,
  last_activity_after TIMESTAMP DEFAULT NULL,
  last_activity_before TIMESTAMP DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  query TEXT DEFAULT NULL,
  scope TEXT DEFAULT NULL,
  type TEXT DEFAULT NULL,
  unread_only BOOLEAN DEFAULT NULL
)
RETURNS beeper_desktop_api_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN beeper_desktop_api_chats._search_first_page_py(
      account_ids,
      cursor,
      direction,
      inbox,
      include_muted,
      last_activity_after,
      last_activity_before,
      "limit",
      query,
      scope,
      type,
      unread_only
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats._search_next_page(request_options JSONB)
RETURNS beeper_desktop_api_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from beeper_desktop_api.types import Chat
  from beeper_desktop_api.pagination import SyncCursorSearch
  from beeper_desktop_api._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__beeper_desktop_api_context__"].client._request_api_list(
    model=Chat,
    page=SyncCursorSearch[Chat],
    options=FinalRequestOptions.construct(**json.loads(request_options))
  )
  next_page_info = page.next_page_info()
  if next_page_info is None:
      next_request_options = None
  else:
      next_request_options = page._info_to_options(next_page_info).model_dump_json(
        exclude_unset=True,
        exclude={'post_parser'}
      )

  # We convert to JSON instead of letting PL/Python perform data mapping because PL/Python errors for
  # omitted fields instead of defaulting them to NULL, but we want to be more lenient, which we handle
  # in the calling function later.
  type_adapter = TypeAdapter(Any)
  return (
    type_adapter.dump_json(page._get_page_items(), exclude_unset=True).decode("utf-8"),
    next_request_options
  )
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.search(
  account_ids TEXT[] DEFAULT NULL,
  cursor TEXT DEFAULT NULL,
  direction TEXT DEFAULT NULL,
  inbox TEXT DEFAULT NULL,
  include_muted BOOLEAN DEFAULT NULL,
  last_activity_after TIMESTAMP DEFAULT NULL,
  last_activity_before TIMESTAMP DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  query TEXT DEFAULT NULL,
  scope TEXT DEFAULT NULL,
  type TEXT DEFAULT NULL,
  unread_only BOOLEAN DEFAULT NULL
)
RETURNS SETOF beeper_desktop_api_chats.chat
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM beeper_desktop_api_chats._search_first_page(
      account_ids,
      cursor,
      direction,
      inbox,
      include_muted,
      last_activity_after,
      last_activity_before,
      "limit",
      query,
      scope,
      type,
      unread_only
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN beeper_desktop_api_chats._search_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::beeper_desktop_api_chats.chat, data)).* FROM paginated;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats._start(
  account_id TEXT,
  "user" beeper_desktop_api_chats.start_params_user,
  allow_invite BOOLEAN DEFAULT NULL,
  message_text TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.chats.with_raw_response.start(
      account_id=account_id,
      user=GD["__beeper_desktop_api_context__"].strip_none(user),
      allow_invite=not_given if allow_invite is None else allow_invite,
      message_text=not_given if message_text is None else message_text,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.start(
  account_id TEXT,
  "user" beeper_desktop_api_chats.start_params_user,
  allow_invite BOOLEAN DEFAULT NULL,
  message_text TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_start_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_chats.chat_start_response,
      beeper_desktop_api_chats._start(
        account_id, "user", allow_invite, message_text
      )
    );
  END;
$$;