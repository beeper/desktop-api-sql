ALTER TYPE beeper_desktop_api_messages.message_update_response
  ADD ATTRIBUTE chatID TEXT,
  ADD ATTRIBUTE messageID TEXT,
  ADD ATTRIBUTE success BOOLEAN;

CREATE OR REPLACE FUNCTION beeper_desktop_api_messages.make_message_update_response(
  chatID TEXT, messageID TEXT, success BOOLEAN
)
RETURNS beeper_desktop_api_messages.message_update_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    chatID, messageID, success
  )::beeper_desktop_api_messages.message_update_response;
$$;

ALTER TYPE beeper_desktop_api_messages.message_send_response
  ADD ATTRIBUTE chatID TEXT, ADD ATTRIBUTE pendingMessageID TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_messages.make_message_send_response(
  chatID TEXT, pendingMessageID TEXT
)
RETURNS beeper_desktop_api_messages.message_send_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    chatID, pendingMessageID
  )::beeper_desktop_api_messages.message_send_response;
$$;

ALTER TYPE beeper_desktop_api_messages.attachment
  ADD ATTRIBUTE uploadID TEXT,
  ADD ATTRIBUTE duration DOUBLE PRECISION,
  ADD ATTRIBUTE fileName TEXT,
  ADD ATTRIBUTE mimeType TEXT,
  ADD ATTRIBUTE size beeper_desktop_api_messages.attachment_size,
  ADD ATTRIBUTE type TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_messages.make_attachment(
  uploadID TEXT,
  duration DOUBLE PRECISION DEFAULT NULL,
  fileName TEXT DEFAULT NULL,
  mimeType TEXT DEFAULT NULL,
  size beeper_desktop_api_messages.attachment_size DEFAULT NULL,
  type TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_messages.attachment
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    uploadID, duration, fileName, mimeType, size, type
  )::beeper_desktop_api_messages.attachment;
$$;

ALTER TYPE beeper_desktop_api_messages.attachment_size
  ADD ATTRIBUTE height DOUBLE PRECISION, ADD ATTRIBUTE width DOUBLE PRECISION;

CREATE OR REPLACE FUNCTION beeper_desktop_api_messages.make_attachment_size(
  height DOUBLE PRECISION, width DOUBLE PRECISION
)
RETURNS beeper_desktop_api_messages.attachment_size
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(height, width)::beeper_desktop_api_messages.attachment_size;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_messages._update(
  chat_id TEXT, message_id TEXT, text TEXT
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  response = GD["__beeper_desktop_api_context__"].client.messages.with_raw_response.update(
      chat_id=chat_id,
      message_id=message_id,
      text=text,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_messages.update(
  chat_id TEXT, message_id TEXT, text TEXT
)
RETURNS beeper_desktop_api_messages.message_update_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_messages.message_update_response,
      beeper_desktop_api_messages._update(chat_id, message_id, text)
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_messages._list_first_page_py(
  chat_id TEXT, cursor TEXT DEFAULT NULL, direction TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  from beeper_desktop_api._types import not_given
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__beeper_desktop_api_context__"].client.messages.list(
      chat_id=chat_id,
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

-- A simpler wrapper around `beeper_desktop_api_messages._list_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION beeper_desktop_api_messages._list_first_page(
  chat_id TEXT, cursor TEXT DEFAULT NULL, direction TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN beeper_desktop_api_messages._list_first_page_py(
      chat_id, cursor, direction
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_messages._list_next_page(request_options JSONB)
RETURNS beeper_desktop_api_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from beeper_desktop_api.types.shared import Message
  from beeper_desktop_api.pagination import SyncCursorSortKey
  from beeper_desktop_api._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__beeper_desktop_api_context__"].client._request_api_list(
    model=Message,
    page=SyncCursorSortKey[Message],
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

CREATE OR REPLACE FUNCTION beeper_desktop_api_messages.list(
  chat_id TEXT, cursor TEXT DEFAULT NULL, direction TEXT DEFAULT NULL
)
RETURNS SETOF beeper_desktop_api.message
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM beeper_desktop_api_messages._list_first_page(
      chat_id, cursor, direction
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN beeper_desktop_api_messages._list_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::beeper_desktop_api.message, data)).* FROM paginated;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_messages._search_first_page_py(
  account_ids TEXT[] DEFAULT NULL,
  chat_ids TEXT[] DEFAULT NULL,
  chat_type TEXT DEFAULT NULL,
  cursor TEXT DEFAULT NULL,
  date_after TIMESTAMP DEFAULT NULL,
  date_before TIMESTAMP DEFAULT NULL,
  direction TEXT DEFAULT NULL,
  exclude_low_priority BOOLEAN DEFAULT NULL,
  include_muted BOOLEAN DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  media_types TEXT[] DEFAULT NULL,
  query TEXT DEFAULT NULL,
  sender TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  from beeper_desktop_api._types import not_given
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__beeper_desktop_api_context__"].client.messages.search(
      account_ids=not_given if account_ids is None else account_ids,
      chat_ids=not_given if chat_ids is None else chat_ids,
      chat_type=not_given if chat_type is None else chat_type,
      cursor=not_given if cursor is None else cursor,
      date_after=not_given if date_after is None else date_after,
      date_before=not_given if date_before is None else date_before,
      direction=not_given if direction is None else direction,
      exclude_low_priority=not_given if exclude_low_priority is None else exclude_low_priority,
      include_muted=not_given if include_muted is None else include_muted,
      limit=not_given if limit is None else limit,
      media_types=not_given if media_types is None else media_types,
      query=not_given if query is None else query,
      sender=not_given if sender is None else sender,
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

-- A simpler wrapper around `beeper_desktop_api_messages._search_first_page` that ensures the global client is initialized.
CREATE OR REPLACE FUNCTION beeper_desktop_api_messages._search_first_page(
  account_ids TEXT[] DEFAULT NULL,
  chat_ids TEXT[] DEFAULT NULL,
  chat_type TEXT DEFAULT NULL,
  cursor TEXT DEFAULT NULL,
  date_after TIMESTAMP DEFAULT NULL,
  date_before TIMESTAMP DEFAULT NULL,
  direction TEXT DEFAULT NULL,
  exclude_low_priority BOOLEAN DEFAULT NULL,
  include_muted BOOLEAN DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  media_types TEXT[] DEFAULT NULL,
  query TEXT DEFAULT NULL,
  sender TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_internal.page
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN beeper_desktop_api_messages._search_first_page_py(
      account_ids,
      chat_ids,
      chat_type,
      cursor,
      date_after,
      date_before,
      direction,
      exclude_low_priority,
      include_muted,
      "limit",
      media_types,
      query,
      sender
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_messages._search_next_page(request_options JSONB)
RETURNS beeper_desktop_api_internal.page
LANGUAGE plpython3u
STABLE
AS $$
  import json
  from beeper_desktop_api.types.shared import Message
  from beeper_desktop_api.pagination import SyncCursorSearch
  from beeper_desktop_api._models import FinalRequestOptions
  from pydantic import TypeAdapter
  from typing import Any

  page = GD["__beeper_desktop_api_context__"].client._request_api_list(
    model=Message,
    page=SyncCursorSearch[Message],
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

CREATE OR REPLACE FUNCTION beeper_desktop_api_messages.search(
  account_ids TEXT[] DEFAULT NULL,
  chat_ids TEXT[] DEFAULT NULL,
  chat_type TEXT DEFAULT NULL,
  cursor TEXT DEFAULT NULL,
  date_after TIMESTAMP DEFAULT NULL,
  date_before TIMESTAMP DEFAULT NULL,
  direction TEXT DEFAULT NULL,
  exclude_low_priority BOOLEAN DEFAULT NULL,
  include_muted BOOLEAN DEFAULT NULL,
  "limit" BIGINT DEFAULT NULL,
  media_types TEXT[] DEFAULT NULL,
  query TEXT DEFAULT NULL,
  sender TEXT DEFAULT NULL
)
RETURNS SETOF beeper_desktop_api.message
LANGUAGE SQL
STABLE
AS $$
  WITH RECURSIVE paginated AS (
    SELECT page.*
    FROM beeper_desktop_api_messages._search_first_page(
      account_ids,
      chat_ids,
      chat_type,
      cursor,
      date_after,
      date_before,
      direction,
      exclude_low_priority,
      include_muted,
      "limit",
      media_types,
      query,
      sender
    ) AS page

    UNION ALL

    SELECT page.*
    FROM paginated
    CROSS JOIN beeper_desktop_api_messages._search_next_page(paginated.next_request_options) AS page
    WHERE paginated.next_request_options IS NOT NULL
  )
  SELECT (jsonb_populate_recordset(NULL::beeper_desktop_api.message, data)).* FROM paginated;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_messages._send(
  chat_id TEXT,
  attachment beeper_desktop_api_messages.attachment DEFAULT NULL,
  reply_to_message_id TEXT DEFAULT NULL,
  text TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.messages.with_raw_response.send(
      chat_id=chat_id,
      attachment=not_given if attachment is None else GD["__beeper_desktop_api_context__"].strip_none(attachment),
      reply_to_message_id=not_given if reply_to_message_id is None else reply_to_message_id,
      text=not_given if text is None else text,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_messages.send(
  chat_id TEXT,
  attachment beeper_desktop_api_messages.attachment DEFAULT NULL,
  reply_to_message_id TEXT DEFAULT NULL,
  text TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_messages.message_send_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_messages.message_send_response,
      beeper_desktop_api_messages._send(
        chat_id, attachment, reply_to_message_id, text
      )
    );
  END;
$$;