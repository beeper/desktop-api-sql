ALTER TYPE beeper_desktop_api_chats_messages_reactions.reaction_delete_response
  ADD ATTRIBUTE chat_id TEXT,
  ADD ATTRIBUTE message_id TEXT,
  ADD ATTRIBUTE reaction_key TEXT,
  ADD ATTRIBUTE success BOOLEAN;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats_messages_reactions.make_reaction_delete_response(
  chat_id TEXT, message_id TEXT, reaction_key TEXT, success BOOLEAN
)
RETURNS beeper_desktop_api_chats_messages_reactions.reaction_delete_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    chat_id, message_id, reaction_key, success
  )::beeper_desktop_api_chats_messages_reactions.reaction_delete_response;
$$;

ALTER TYPE beeper_desktop_api_chats_messages_reactions.reaction_add_response
  ADD ATTRIBUTE chat_id TEXT,
  ADD ATTRIBUTE message_id TEXT,
  ADD ATTRIBUTE reaction_key TEXT,
  ADD ATTRIBUTE success BOOLEAN,
  ADD ATTRIBUTE transaction_id TEXT;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats_messages_reactions.make_reaction_add_response(
  chat_id TEXT,
  message_id TEXT,
  reaction_key TEXT,
  success BOOLEAN,
  transaction_id TEXT
)
RETURNS beeper_desktop_api_chats_messages_reactions.reaction_add_response
LANGUAGE SQL
IMMUTABLE
AS $$
  SELECT ROW(
    chat_id, message_id, reaction_key, success, transaction_id
  )::beeper_desktop_api_chats_messages_reactions.reaction_add_response;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats_messages_reactions._delete(
  chat_id TEXT, message_id TEXT, reaction_key TEXT
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  response = GD["__beeper_desktop_api_context__"].client.chats.messages.reactions.with_raw_response.delete(
      chat_id=chat_id,
      message_id=message_id,
      reaction_key=reaction_key,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats_messages_reactions.delete(
  chat_id TEXT, message_id TEXT, reaction_key TEXT
)
RETURNS beeper_desktop_api_chats_messages_reactions.reaction_delete_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_chats_messages_reactions.reaction_delete_response,
      beeper_desktop_api_chats_messages_reactions._delete(
        chat_id, message_id, reaction_key
      )
    );
  END;
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats_messages_reactions._add(
  chat_id TEXT,
  message_id TEXT,
  reaction_key TEXT,
  transaction_id TEXT DEFAULT NULL
)
RETURNS JSONB
LANGUAGE plpython3u
AS $$
  from beeper_desktop_api._types import not_given

  response = GD["__beeper_desktop_api_context__"].client.chats.messages.reactions.with_raw_response.add(
      chat_id=chat_id,
      message_id=message_id,
      reaction_key=reaction_key,
      transaction_id=not_given if transaction_id is None else transaction_id,
  )

  # We don't parse the JSON and let PL/Python perform data mapping because PL/Python errors for omitted
  # fields instead of defaulting them to NULL, but we want to be more lenient, which we handle in the
  # caller later.
  return response.text()
$$;

CREATE OR REPLACE FUNCTION beeper_desktop_api_chats_messages_reactions.add(
  chat_id TEXT,
  message_id TEXT,
  reaction_key TEXT,
  transaction_id TEXT DEFAULT NULL
)
RETURNS beeper_desktop_api_chats_messages_reactions.reaction_add_response
LANGUAGE plpgsql
AS $$
  BEGIN
    PERFORM beeper_desktop_api_internal.ensure_context();
    RETURN jsonb_populate_record(
      NULL::beeper_desktop_api_chats_messages_reactions.reaction_add_response,
      beeper_desktop_api_chats_messages_reactions._add(
        chat_id, message_id, reaction_key, transaction_id
      )
    );
  END;
$$;