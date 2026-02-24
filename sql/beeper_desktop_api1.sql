ALTER TYPE beeper_desktop_api.client_focus_response
  ADD ATTRIBUTE success BOOLEAN;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_client_focus_response(
  success BOOLEAN
)
RETURNS beeper_desktop_api.client_focus_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(success)::beeper_desktop_api.client_focus_response;
$$;

ALTER TYPE beeper_desktop_api.client_search_response
  ADD ATTRIBUTE results beeper_desktop_api.client_search_response_result;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_client_search_response(
  results beeper_desktop_api.client_search_response_result
)
RETURNS beeper_desktop_api.client_search_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(results)::beeper_desktop_api.client_search_response;
$$;

ALTER TYPE beeper_desktop_api.client_search_response_result
  ADD ATTRIBUTE chats beeper_desktop_api_chats.chat[],
  ADD ATTRIBUTE in_groups beeper_desktop_api_chats.chat[],
  ADD ATTRIBUTE messages beeper_desktop_api.client_search_response_result_message;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_client_search_response_result(
  chats beeper_desktop_api_chats.chat[],
  in_groups beeper_desktop_api_chats.chat[],
  messages beeper_desktop_api.client_search_response_result_message
)
RETURNS beeper_desktop_api.client_search_response_result
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    chats, in_groups, messages
  )::beeper_desktop_api.client_search_response_result;
$$;

ALTER TYPE beeper_desktop_api.client_search_response_result_message
  ADD ATTRIBUTE chats JSONB,
  ADD ATTRIBUTE has_more BOOLEAN,
  ADD ATTRIBUTE items beeper_desktop_api.message[],
  ADD ATTRIBUTE newest_cursor TEXT,
  ADD ATTRIBUTE oldest_cursor TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api.make_client_search_response_result_message(
  chats JSONB,
  has_more BOOLEAN,
  items beeper_desktop_api.message[],
  newest_cursor TEXT DEFAULT NULL,
  oldest_cursor TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api.client_search_response_result_message
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    chats, has_more, items, newest_cursor, oldest_cursor
  )::beeper_desktop_api.client_search_response_result_message;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api._focus(
  chat_id TEXT DEFAULT NULL,
  draft_attachment_path TEXT DEFAULT NULL,
  draft_text TEXT DEFAULT NULL,
  message_id TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.with_raw_response.focus(
      chat_id=not_given if chat_id is None else chat_id,
      draft_attachment_path=not_given if draft_attachment_path is None else draft_attachment_path,
      draft_text=not_given if draft_text is None else draft_text,
      message_id=not_given if message_id is None else message_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api.focus(
  chat_id TEXT DEFAULT NULL,
  draft_attachment_path TEXT DEFAULT NULL,
  draft_text TEXT DEFAULT NULL,
  message_id TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api.client_focus_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api.client_focus_response,
      beeper_desktop_api._focus(
        chat_id, draft_attachment_path, draft_text, message_id
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api._search(query TEXT)
RETURNS JSONB
LANGUAGE plpython3u
STABLE
AS $$
  response = GD["__beeper_desktop_api_context__"].client.with_raw_response.search(
      query=query,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api.search(query TEXT)
RETURNS beeper_desktop_api.client_search_response
LANGUAGE plpgsql
STABLE
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api.client_search_response,
      beeper_desktop_api._search(query)
    );
  END;
$$;