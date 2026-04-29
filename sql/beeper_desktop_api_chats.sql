ALTER TYPE beeper_desktop_api_chats.chat
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE accountID TEXT,
  ADD ATTRIBUTE participants beeper_desktop_api_chats.chat_participant,
  ADD ATTRIBUTE title TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE unreadCount BIGINT,
  ADD ATTRIBUTE isArchived BOOLEAN,
  ADD ATTRIBUTE isMuted BOOLEAN,
  ADD ATTRIBUTE isPinned BOOLEAN,
  ADD ATTRIBUTE lastActivity TIMESTAMP,
  ADD ATTRIBUTE lastReadMessageSortKey TEXT,
  ADD ATTRIBUTE localChatID TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat(
  id TEXT,
  accountID TEXT,
  participants beeper_desktop_api_chats.chat_participant,
  title TEXT,
  type TEXT,
  unreadCount BIGINT,
  isArchived BOOLEAN DEFAULT NULL,
  isMuted BOOLEAN DEFAULT NULL,
  isPinned BOOLEAN DEFAULT NULL,
  lastActivity TIMESTAMP DEFAULT NULL,
  lastReadMessageSortKey TEXT DEFAULT NULL,
  localChatID TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    accountID,
    participants,
    title,
    type,
    unreadCount,
    isArchived,
    isMuted,
    isPinned,
    lastActivity,
    lastReadMessageSortKey,
    localChatID
  )::beeper_desktop_api_chats.chat;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_participant
  ADD ATTRIBUTE hasMore BOOLEAN,
  ADD ATTRIBUTE items beeper_desktop_api.user[],
  ADD ATTRIBUTE total BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_participant(
  hasMore BOOLEAN, items beeper_desktop_api.user[], total BIGINT
)
RETURNS beeper_desktop_api_chats.chat_participant
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(hasMore, items, total)::beeper_desktop_api_chats.chat_participant;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_create_response
  ADD ATTRIBUTE chatID TEXT, ADD ATTRIBUTE status TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_create_response(
  chatID TEXT, status TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_create_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(chatID, status)::beeper_desktop_api_chats.chat_create_response;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_list_response
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE accountID TEXT,
  ADD ATTRIBUTE participants beeper_desktop_api_chats.chat_list_response_participant,
  ADD ATTRIBUTE title TEXT,
  ADD ATTRIBUTE type TEXT,
  ADD ATTRIBUTE unreadCount BIGINT,
  ADD ATTRIBUTE isArchived BOOLEAN,
  ADD ATTRIBUTE isMuted BOOLEAN,
  ADD ATTRIBUTE isPinned BOOLEAN,
  ADD ATTRIBUTE lastActivity TIMESTAMP,
  ADD ATTRIBUTE lastReadMessageSortKey TEXT,
  ADD ATTRIBUTE localChatID TEXT,
  ADD ATTRIBUTE preview beeper_desktop_api.message;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_list_response(
  id TEXT,
  accountID TEXT,
  participants beeper_desktop_api_chats.chat_list_response_participant,
  title TEXT,
  type TEXT,
  unreadCount BIGINT,
  isArchived BOOLEAN DEFAULT NULL,
  isMuted BOOLEAN DEFAULT NULL,
  isPinned BOOLEAN DEFAULT NULL,
  lastActivity TIMESTAMP DEFAULT NULL,
  lastReadMessageSortKey TEXT DEFAULT NULL,
  localChatID TEXT DEFAULT NULL,
  preview beeper_desktop_api.message DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_list_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id,
    accountID,
    participants,
    title,
    type,
    unreadCount,
    isArchived,
    isMuted,
    isPinned,
    lastActivity,
    lastReadMessageSortKey,
    localChatID,
    preview
  )::beeper_desktop_api_chats.chat_list_response;
$$;

ALTER TYPE beeper_desktop_api_chats.chat_list_response_participant
  ADD ATTRIBUTE hasMore BOOLEAN,
  ADD ATTRIBUTE items beeper_desktop_api.user[],
  ADD ATTRIBUTE total BIGINT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_chat_list_response_participant(
  hasMore BOOLEAN, items beeper_desktop_api.user[], total BIGINT
)
RETURNS beeper_desktop_api_chats.chat_list_response_participant
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    hasMore, items, total
  )::beeper_desktop_api_chats.chat_list_response_participant;
$$;

ALTER TYPE beeper_desktop_api_chats.create_params_user
  ADD ATTRIBUTE id TEXT,
  ADD ATTRIBUTE email TEXT,
  ADD ATTRIBUTE fullName TEXT,
  ADD ATTRIBUTE phoneNumber TEXT,
  ADD ATTRIBUTE username TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.make_create_params_user(
  id TEXT DEFAULT NULL,
  email TEXT DEFAULT NULL,
  fullName TEXT DEFAULT NULL,
  phoneNumber TEXT DEFAULT NULL,
  username TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.create_params_user
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    id, email, fullName, phoneNumber, username
  )::beeper_desktop_api_chats.create_params_user;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats._create(
  account_id TEXT,
  allow_invite BOOLEAN DEFAULT NULL,
  message_text TEXT DEFAULT NULL,
  mode TEXT DEFAULT NULL,
  participant_ids TEXT[] DEFAULT NULL,
  title TEXT DEFAULT NULL,
  type TEXT DEFAULT NULL,
  "user" beeper_desktop_api_chats.create_params_user DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.chats.with_raw_response.create(
      account_id=account_id,
      allow_invite=not_given if allow_invite is None else allow_invite,
      message_text=not_given if message_text is None else message_text,
      mode=not_given if mode is None else mode,
      participant_ids=not_given if participant_ids is None else participant_ids,
      title=not_given if title is None else title,
      type=not_given if type is None else type,
      user=not_given if user is None else GD["__beeper_desktop_api_context__"].strip_none(user),
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats.create(
  account_id TEXT,
  allow_invite BOOLEAN DEFAULT NULL,
  message_text TEXT DEFAULT NULL,
  mode TEXT DEFAULT NULL,
  participant_ids TEXT[] DEFAULT NULL,
  title TEXT DEFAULT NULL,
  type TEXT DEFAULT NULL,
  "user" beeper_desktop_api_chats.create_params_user DEFAULT NULL
)
RETURNS beeper_desktop_api_chats.chat_create_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_chats.chat_create_response,
      beeper_desktop_api_chats._create(
        account_id,
        allow_invite,
        message_text,
        mode,
        participant_ids,
        title,
        type,
        "user"
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